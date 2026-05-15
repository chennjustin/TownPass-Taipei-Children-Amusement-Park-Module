import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:town_pass/page/children_park/map/children_park_map_constants.dart';
import 'package:town_pass/page/children_park/map/children_park_map_data.dart';
import 'package:town_pass/page/children_park/map/children_park_map_helpers.dart';
import 'package:town_pass/page/children_park/map/children_park_map_models.dart';

class ChildrenParkMapController extends GetxController {
  static const double _pointIconCollisionRadiusPx = 22;
  static const double _clusterIconCollisionRadiusPx = 23;
  static const double _mergeOverlapThreshold = 0.40;

  final RxBool isLoading = true.obs;
  final RxString statusText = '地圖初始化中...'.obs;
  final RxString query = ''.obs;
  final RxBool filterPanelOpen = false.obs;
  final Rx<ChildrenParkMapContentType> selectedContentType =
      ChildrenParkMapContentType.facility.obs;
  final Rx<ChildrenParkRideFilters> rideFilters =
      const ChildrenParkRideFilters().obs;
  final Rxn<ChildrenParkMapPoint> selectedPoint = Rxn<ChildrenParkMapPoint>();
  final RxnString activeCarouselPointId = RxnString();
  final Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
  final Rx<Set<GroundOverlay>> groundOverlays = Rx<Set<GroundOverlay>>({});
  final Rxn<LatLng> userPosition = Rxn<LatLng>();
  final RxDouble userHeading = 0.0.obs;

  GoogleMapController? mapController;
  List<ChildrenParkMapPoint> allPoints = [];
  List<ChildrenParkPlaceDetail> placeDetails = [];
  Map<String, ChildrenParkPlaceDetail> placeDetailsByName = {};
  BitmapDescriptor? defaultMarkerIcon;
  BitmapDescriptor? selectedMarkerIcon;
  BitmapDescriptor? userLocationIcon;
  BitmapDescriptor? defaultClusterIcon;
  final Map<String, BitmapDescriptor> _pointMarkerIcons = {};
  final Map<String, BitmapDescriptor> _clusterIcons = {};
  final Set<int> _pendingClusterIconCounts = {};
  String? _pendingFocusPointId;
  bool _pendingOpenDetail = false;
  CameraPosition? _lastCameraPosition;
  bool _isAdjustingCamera = false;
  StreamSubscription<Position>? _locationStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  @override
  void onClose() {
    _locationStreamSubscription?.cancel();
    _locationStreamSubscription = null;
    mapController?.dispose();
    super.onClose();
  }

  Future<void> _loadData() async {
    try {
      allPoints = await ChildrenParkMapData.loadAllPoints();
      placeDetails = await ChildrenParkMapData.loadPlaceDetails();
      placeDetailsByName = {
        for (final detail in placeDetails)
          normalizePlaceName(detail.name): detail,
        for (final detail in placeDetails)
          for (final alias in detail.aliases) normalizePlaceName(alias): detail,
      };
      await _prepareMarkerIcons();
      userLocationIcon = await _createUserLocationIcon();
      defaultClusterIcon = await _createClusterIcon('2');
      statusText.value = 'Google Maps 載入完成，共 ${allPoints.length} 個點位。';
      _fetchUserLocation();
      _applyPendingFocusIfReady();
    } catch (error) {
      statusText.value = '地圖資料載入失敗：$error';
    } finally {
      isLoading.value = false;
      _rebuildMarkers();
      if (visiblePoints.isNotEmpty) {
        activeCarouselPointId.value = visiblePoints.first.id;
      }
    }
  }

  Future<void> attachParkOverlay(ImageConfiguration configuration) async {
    try {
      final overlayImage = await AssetMapBitmap.create(
        configuration,
        ChildrenParkMapConstants.overlayAsset,
        bitmapScaling: MapBitmapScaling.none,
      );
      groundOverlays.value = {
        GroundOverlay.fromBounds(
          groundOverlayId: const GroundOverlayId('park_overlay'),
          image: overlayImage,
          bounds: ChildrenParkMapConstants.overlayBounds,
        ),
      };
    } catch (error) {
      statusText.value = '園區地圖疊圖載入失敗：$error';
    }
  }

  List<ChildrenParkMapPoint> get visiblePoints {
    final normalizedQuery = query.value.trim().toLowerCase();
    final recommendedHeightFilters = getRecommendedHeightFilters('');

    return allPoints.where((point) {
      if (getPointContentType(point) != selectedContentType.value) {
        return false;
      }
      if (selectedContentType.value == ChildrenParkMapContentType.facility &&
          !isRidePoint(point)) {
        return false;
      }

      if (selectedContentType.value == ChildrenParkMapContentType.facility) {
        final detail = placeDetailsByName[normalizePlaceName(point.name)];
        final filters = detail?.filters;
        final combinedSpecial = [
          ...?filters?.special,
          ...?filters?.environment,
        ];
        if (!matchesTextFilter(filters?.height, rideFilters.value.height)) {
          return false;
        }
        if (!matchesTextFilter(filters?.thrill, rideFilters.value.thrill)) {
          return false;
        }
        if (!matchesListFilter(
          filters?.environment,
          rideFilters.value.environment,
        )) {
          return false;
        }
        if (!matchesTextFilter(filters?.price, rideFilters.value.price)) {
          return false;
        }
        if (!matchesListFilter(combinedSpecial, rideFilters.value.special)) {
          return false;
        }
        if (recommendedHeightFilters.isNotEmpty &&
            !recommendedHeightFilters.any(
              (heightFilter) =>
                  filters?.height?.contains(heightFilter) ?? false,
            )) {
          // child height filter only when set - skip empty
        }
      }

      if (normalizedQuery.isNotEmpty &&
          !point.name.toLowerCase().contains(normalizedQuery) &&
          !point.category.toLowerCase().contains(normalizedQuery)) {
        return false;
      }
      return true;
    }).toList();
  }

  int get carouselIndex {
    final activeId = activeCarouselPointId.value;
    if (activeId == null) return 0;
    final index = visiblePoints.indexWhere((point) => point.id == activeId);
    return index == -1 ? 0 : index;
  }

  ChildrenParkMapPoint? get carouselPoint {
    final points = visiblePoints;
    if (points.isEmpty) return null;
    return points[carouselIndex.clamp(0, points.length - 1)];
  }

  void selectContentType(ChildrenParkMapContentType type) {
    selectedContentType.value = type;
    selectedPoint.value = null;
    filterPanelOpen.value = false;
    _rebuildMarkers();
    final points = visiblePoints;
    activeCarouselPointId.value = points.isNotEmpty ? points.first.id : null;
  }

  void toggleRideFilter(String key, String value) {
    final current = rideFilters.value;
    List<String> singleSelect(List<String> list) {
      if (list.contains(value)) {
        return <String>[];
      }
      return <String>[value];
    }

    rideFilters.value = switch (key) {
      'height' => current.copyWith(height: singleSelect(current.height)),
      'thrill' => current.copyWith(thrill: singleSelect(current.thrill)),
      'environment' =>
        current.copyWith(environment: singleSelect(current.environment)),
      'price' => current.copyWith(price: singleSelect(current.price)),
      'special' => current.copyWith(special: singleSelect(current.special)),
      _ => current,
    };
    _rebuildMarkers();
  }

  void clearRideFilters() {
    rideFilters.value = const ChildrenParkRideFilters();
    query.value = '';
    _rebuildMarkers();
  }

  void applyRideFilters(ChildrenParkRideFilters filters) {
    rideFilters.value = filters;
    _rebuildMarkers();
  }

  void onQueryChanged(String value) {
    query.value = value;
    _rebuildMarkers();
    final points = visiblePoints;
    if (points.isEmpty) {
      activeCarouselPointId.value = null;
    } else if (activeCarouselPointId.value == null ||
        !points.any((p) => p.id == activeCarouselPointId.value)) {
      activeCarouselPointId.value = points.first.id;
    }
  }

  void onMapCreated(
    GoogleMapController controller,
    ImageConfiguration imageConfiguration,
  ) {
    mapController = controller;
    _lastCameraPosition = const CameraPosition(
      target: ChildrenParkMapConstants.parkCenter,
      zoom: ChildrenParkMapConstants.initialZoom,
    );
    attachParkOverlay(imageConfiguration);
    _fitVisibleBounds();
    _applyPendingFocusIfReady();
  }

  void handleNavigationArgs(dynamic arguments) {
    if (arguments is! Map) {
      return;
    }
    final focusPointId = arguments['focusPointId']?.toString();
    final openDetail = arguments['openDetail'] == true;
    if (focusPointId == null || focusPointId.isEmpty) {
      return;
    }
    _pendingFocusPointId = focusPointId;
    _pendingOpenDetail = openDetail;
    _applyPendingFocusIfReady();
  }

  void onCameraMove(CameraPosition position) {
    _lastCameraPosition = position;
  }

  Future<void> onCameraIdle() async {
    await _enforceMapBounds();
    _rebuildMarkers();
  }

  void focusPoint(
    ChildrenParkMapPoint point, {
    bool animate = true,
    bool clearDetailSelection = true,
  }) {
    activeCarouselPointId.value = point.id;
    if (clearDetailSelection) {
      selectedPoint.value = null;
    }
    _rebuildMarkers();
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(point.lat, point.lng),
          zoom: ChildrenParkMapConstants.facilityFocusZoom,
        ),
      ),
    );
  }

  void showPointDetail(ChildrenParkMapPoint point) {
    selectedPoint.value = point;
    activeCarouselPointId.value = point.id;
    focusPoint(point, clearDetailSelection: false);
  }

  void closePointDetail() {
    selectedPoint.value = null;
    _rebuildMarkers();
  }

  void scrollCarouselBy(int delta) {
    final points = visiblePoints;
    if (points.isEmpty) return;
    final next = (carouselIndex + delta).clamp(0, points.length - 1);
    focusPoint(points[next]);
  }

  void onMarkerTapped(ChildrenParkMapPoint point) {
    // Direct marker tap should only change active item state.
    // Camera zoom/pan is controlled by carousel interactions.
    activeCarouselPointId.value = point.id;
    selectedPoint.value = null;
    _rebuildMarkers();
  }

  ChildrenParkPlaceDetail? detailForPoint(ChildrenParkMapPoint point) {
    return placeDetailsByName[normalizePlaceName(point.name)];
  }

  void _applyPendingFocusIfReady() {
    final pointId = _pendingFocusPointId;
    if (pointId == null || allPoints.isEmpty) {
      return;
    }
    ChildrenParkMapPoint? point;
    for (final item in allPoints) {
      if (item.id == pointId) {
        point = item;
        break;
      }
    }
    if (point == null) {
      _pendingFocusPointId = null;
      _pendingOpenDetail = false;
      return;
    }

    final pointType = getPointContentType(point);
    if (selectedContentType.value != pointType) {
      selectedContentType.value = pointType;
    }

    final openDetail = _pendingOpenDetail;
    _pendingFocusPointId = null;
    _pendingOpenDetail = false;

    if (openDetail) {
      showPointDetail(point);
    } else {
      focusPoint(point);
    }
  }

  void recenterPark() {
    final currentPosition = userPosition.value;
    if (currentPosition != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentPosition,
            zoom: ChildrenParkMapConstants.facilityFocusZoom,
          ),
        ),
      );
      return;
    }
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: ChildrenParkMapConstants.parkCenter,
          zoom: ChildrenParkMapConstants.initialZoom,
        ),
      ),
    );
  }

  void _rebuildMarkers() {
    final highlightId = selectedPoint.value?.id ?? activeCarouselPointId.value;
    final points = visiblePoints;
    final nextMarkers = <Marker>{};
    final zoom =
        _lastCameraPosition?.zoom ?? ChildrenParkMapConstants.initialZoom;
    final shouldCluster = zoom <= ChildrenParkMapConstants.clusterMaxZoom;

    if (shouldCluster) {
      final groupedPoints = _buildPointClusters(points, zoom);
      var clusterIndex = 0;
      for (final group in groupedPoints) {
        if (group.points.length == 1) {
          final point = group.points.first;
          final isSelected = point.id == highlightId;
          nextMarkers.add(_buildPointMarker(point, isSelected));
          continue;
        }

        final count = group.points.length;
        final icon = _clusterIcons['$count'] ?? defaultClusterIcon;
        if (!_clusterIcons.containsKey('$count')) {
          _warmClusterIcon(count);
        }
        nextMarkers.add(
          Marker(
            markerId: MarkerId('cluster_${clusterIndex++}_$count'),
            position: LatLng(group.centerLat, group.centerLng),
            icon: icon ?? BitmapDescriptor.defaultMarker,
            zIndexInt: 1000,
            onTap: () => _zoomIntoCluster(
              LatLng(group.centerLat, group.centerLng),
              zoom,
            ),
          ),
        );
      }
    } else {
      for (final point in points) {
        final isSelected = point.id == highlightId;
        nextMarkers.add(_buildPointMarker(point, isSelected));
      }
    }

    final currentPosition = userPosition.value;
    if (currentPosition != null) {
      nextMarkers.add(
        Marker(
          markerId: const MarkerId('current_user_location'),
          position: currentPosition,
          icon: userLocationIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          anchor: const Offset(0.5, 0.5),
          flat: true,
          rotation: userHeading.value,
          zIndexInt: 5000,
        ),
      );
    }

    markers.value = nextMarkers;
  }

  void _fitVisibleBounds() {
    final points = visiblePoints;
    final controller = mapController;
    if (controller == null) return;

    if (points.isEmpty) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: ChildrenParkMapConstants.parkCenter,
            zoom: ChildrenParkMapConstants.initialZoom,
          ),
        ),
      );
      return;
    }

    if (points.length == 1) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(points.first.lat, points.first.lng),
            zoom: ChildrenParkMapConstants.initialZoom,
          ),
        ),
      );
      return;
    }

    var south = points.first.lat;
    var north = points.first.lat;
    var west = points.first.lng;
    var east = points.first.lng;
    for (final point in points) {
      south = south < point.lat ? south : point.lat;
      north = north > point.lat ? north : point.lat;
      west = west < point.lng ? west : point.lng;
      east = east > point.lng ? east : point.lng;
    }

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(south, west),
          northeast: LatLng(north, east),
        ),
        48,
      ),
    );
  }

  Marker _buildPointMarker(ChildrenParkMapPoint point, bool isSelected) {
    return Marker(
      markerId: MarkerId(point.id),
      position: LatLng(point.lat, point.lng),
      icon: _resolvePointIcon(point, isSelected),
      zIndexInt: isSelected ? 2 : 1,
      onTap: () => onMarkerTapped(point),
    );
  }

  void _zoomIntoCluster(LatLng center, double currentZoom) {
    selectedPoint.value = null;
    activeCarouselPointId.value = null;
    _rebuildMarkers();

    final targetZoom = math
        .max(
          currentZoom + ChildrenParkMapConstants.clusterZoomInStep,
          ChildrenParkMapConstants.clusterMaxZoom + 0.8,
        )
        .toDouble();
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: targetZoom),
      ),
    );
  }

  List<_PointCluster> _buildPointClusters(
    List<ChildrenParkMapPoint> points,
    double zoom,
  ) {
    if (points.length <= 1) {
      return points
          .map(
            (point) => _PointCluster(
              points: [point],
              centerLat: point.lat,
              centerLng: point.lng,
              collisionRadiusPx: _pointIconCollisionRadiusPx,
            ),
          )
          .toList();
    }

    final nodes = points.map((point) {
      final projected = _projectToWorldPixel(point.lat, point.lng, zoom);
      return _ClusterNode(
        points: [point],
        centerLat: point.lat,
        centerLng: point.lng,
        worldX: projected.dx,
        worldY: projected.dy,
        radiusPx: _pointIconCollisionRadiusPx,
      );
    }).toList();

    while (true) {
      var bestI = -1;
      var bestJ = -1;
      var bestOverlap = 0.0;

      for (var i = 0; i < nodes.length; i++) {
        for (var j = i + 1; j < nodes.length; j++) {
          final overlap = _overlapRatio(nodes[i], nodes[j]);
          if (overlap >= _mergeOverlapThreshold && overlap > bestOverlap) {
            bestOverlap = overlap;
            bestI = i;
            bestJ = j;
          }
        }
      }

      if (bestI == -1 || bestJ == -1) {
        break;
      }

      final merged = _mergeNodes(nodes[bestI], nodes[bestJ], zoom);
      nodes.removeAt(bestJ);
      nodes.removeAt(bestI);
      nodes.add(merged);
    }

    return nodes
        .map(
          (node) => _PointCluster(
            points: node.points,
            centerLat: node.centerLat,
            centerLng: node.centerLng,
            collisionRadiusPx: node.radiusPx,
          ),
        )
        .toList();
  }

  _ClusterNode _mergeNodes(_ClusterNode a, _ClusterNode b, double zoom) {
    final totalCount = a.points.length + b.points.length;
    final mergedX =
        (a.worldX * a.points.length + b.worldX * b.points.length) / totalCount;
    final mergedY =
        (a.worldY * a.points.length + b.worldY * b.points.length) / totalCount;
    final latLng = _unprojectFromWorldPixel(mergedX, mergedY, zoom);

    return _ClusterNode(
      points: [...a.points, ...b.points],
      centerLat: latLng.latitude,
      centerLng: latLng.longitude,
      worldX: mergedX,
      worldY: mergedY,
      radiusPx: _clusterIconCollisionRadiusPx,
    );
  }

  double _overlapRatio(_ClusterNode a, _ClusterNode b) {
    final dx = a.worldX - b.worldX;
    final dy = a.worldY - b.worldY;
    final distance = math.sqrt(dx * dx + dy * dy);
    final intersection = _circleIntersectionArea(
      a.radiusPx,
      b.radiusPx,
      distance,
    );
    if (intersection <= 0) {
      return 0;
    }
    final minRadius = math.min(a.radiusPx, b.radiusPx);
    final minArea = math.pi * minRadius * minRadius;
    if (minArea == 0) {
      return 0;
    }
    return intersection / minArea;
  }

  double _circleIntersectionArea(double r1, double r2, double distance) {
    if (distance >= r1 + r2) {
      return 0;
    }
    if (distance <= (r1 - r2).abs()) {
      final radius = math.min(r1, r2);
      return math.pi * radius * radius;
    }

    final r1Sq = r1 * r1;
    final r2Sq = r2 * r2;
    final alpha =
        math.acos(((distance * distance) + r1Sq - r2Sq) / (2 * distance * r1));
    final beta =
        math.acos(((distance * distance) + r2Sq - r1Sq) / (2 * distance * r2));
    final area1 = r1Sq * alpha;
    final area2 = r2Sq * beta;
    final area3 = 0.5 *
        math.sqrt(
          (-distance + r1 + r2) *
              (distance + r1 - r2) *
              (distance - r1 + r2) *
              (distance + r1 + r2),
        );
    return area1 + area2 - area3;
  }

  Offset _projectToWorldPixel(double lat, double lng, double zoom) {
    final scale = 256.0 * math.pow(2.0, zoom);
    final x = (lng + 180.0) / 360.0 * scale;
    final sinLat = math.sin(lat * math.pi / 180.0).clamp(-0.9999, 0.9999);
    final y =
        (0.5 - math.log((1 + sinLat) / (1 - sinLat)) / (4 * math.pi)) * scale;
    return Offset(x, y);
  }

  LatLng _unprojectFromWorldPixel(double x, double y, double zoom) {
    final scale = 256.0 * math.pow(2.0, zoom);
    final lng = x / scale * 360.0 - 180.0;
    final n = math.pi - (2.0 * math.pi * y / scale);
    final lat = 180.0 / math.pi * math.atan(0.5 * (math.exp(n) - math.exp(-n)));
    return LatLng(lat, lng);
  }

  void _drawScaledSymbol(Canvas canvas, void Function() draw) {
    canvas.save();
    canvas.translate(34, 34);
    canvas.scale(0.82, 0.82);
    canvas.translate(-34, -34);
    draw();
    canvas.restore();
  }

  Future<void> _fetchUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      userPosition.value = LatLng(position.latitude, position.longitude);
      final heading = position.heading;
      if (!heading.isNaN && heading >= 0 && heading <= 360) {
        userHeading.value = heading;
      }
      _locationStreamSubscription?.cancel();
      _locationStreamSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
        ),
      ).listen((position) {
        userPosition.value = LatLng(position.latitude, position.longitude);
        final heading = position.heading;
        if (!heading.isNaN && heading >= 0 && heading <= 360) {
          userHeading.value = heading;
        }
        _rebuildMarkers();
      });
      _rebuildMarkers();
    } catch (_) {
      // Ignore location failures and keep map usable.
    }
  }

  Future<void> _enforceMapBounds() async {
    final controller = mapController;
    final camera = _lastCameraPosition;
    if (controller == null || camera == null || _isAdjustingCamera) return;

    final bounds = ChildrenParkMapConstants.parkBounds;
    final southwest = bounds.southwest;
    final northeast = bounds.northeast;

    final clampedLat = camera.target.latitude.clamp(
      southwest.latitude,
      northeast.latitude,
    );
    final clampedLng = camera.target.longitude.clamp(
      southwest.longitude,
      northeast.longitude,
    );
    final clampedZoom = math.max(
      camera.zoom,
      ChildrenParkMapConstants.minZoom,
    );

    final latChanged = (clampedLat - camera.target.latitude).abs() > 0.000001;
    final lngChanged = (clampedLng - camera.target.longitude).abs() > 0.000001;
    final zoomChanged = (clampedZoom - camera.zoom).abs() > 0.001;
    if (!latChanged && !lngChanged && !zoomChanged) {
      return;
    }

    _isAdjustingCamera = true;
    try {
      final nextCamera = CameraPosition(
        target: LatLng(clampedLat, clampedLng),
        zoom: clampedZoom,
      );
      _lastCameraPosition = nextCamera;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(nextCamera),
      );
    } finally {
      _isAdjustingCamera = false;
    }
  }

  Future<BitmapDescriptor> _createUserLocationIcon() async {
    const double size = 64;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(size / 2, size / 2);

    final haloPaint = Paint()..color = const Color(0x553B82F6);
    final whiteRingPaint = Paint()..color = Colors.white;
    final corePaint = Paint()..color = const Color(0xFF2563EB);
    final pointerPaint = Paint()..color = const Color(0xFF2563EB);

    canvas.drawCircle(center, 20, haloPaint);
    final pointerPath = Path()
      ..moveTo(center.dx, 8)
      ..lineTo(center.dx - 7, 21)
      ..lineTo(center.dx + 7, 21)
      ..close();
    canvas.drawPath(pointerPath, pointerPaint);
    canvas.drawCircle(center, 11, whiteRingPaint);
    canvas.drawCircle(center, 7.5, corePaint);

    final image = await recorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();
    if (bytes == null || bytes.isEmpty) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
    return BitmapDescriptor.bytes(bytes);
  }

  Future<void> _prepareMarkerIcons() async {
    _pointMarkerIcons['ferrisWheel_normal'] = await _createPointMarkerIcon(
      kind: 'ferrisWheel',
      selected: false,
    );
    _pointMarkerIcons['ferrisWheel_selected'] = await _createPointMarkerIcon(
      kind: 'ferrisWheel',
      selected: true,
    );
    _pointMarkerIcons['restaurant_normal'] = await _createPointMarkerIcon(
      kind: 'restaurant',
      selected: false,
    );
    _pointMarkerIcons['restaurant_selected'] = await _createPointMarkerIcon(
      kind: 'restaurant',
      selected: true,
    );
    _pointMarkerIcons['shop_normal'] = await _createPointMarkerIcon(
      kind: 'shop',
      selected: false,
    );
    _pointMarkerIcons['shop_selected'] = await _createPointMarkerIcon(
      kind: 'shop',
      selected: true,
    );
    defaultMarkerIcon = _pointMarkerIcons['ferrisWheel_normal'];
    selectedMarkerIcon = _pointMarkerIcons['ferrisWheel_selected'];
  }

  BitmapDescriptor _resolvePointIcon(
      ChildrenParkMapPoint point, bool selected) {
    final kind = _getMarkerKind(point);
    final key = '${kind}_${selected ? 'selected' : 'normal'}';
    return _pointMarkerIcons[key] ??
        (selected
            ? (selectedMarkerIcon ?? BitmapDescriptor.defaultMarker)
            : (defaultMarkerIcon ?? BitmapDescriptor.defaultMarker));
  }

  String _getMarkerKind(ChildrenParkMapPoint point) {
    final text = '${point.name}${point.category}'.toLowerCase();
    if (text.contains('商店') ||
        text.contains('超商') ||
        text.contains('拍貼') ||
        text.contains('化石')) {
      return 'shop';
    }
    if (point.pointType == ChildrenParkMapPointType.restaurant ||
        text.contains('餐') ||
        text.contains('食')) {
      return 'restaurant';
    }
    return 'ferrisWheel';
  }

  Future<void> _warmClusterIcon(int count) async {
    if (_pendingClusterIconCounts.contains(count)) return;
    _pendingClusterIconCounts.add(count);
    try {
      final label = count > 99 ? '99+' : '$count';
      _clusterIcons['$count'] = await _createClusterIcon(label);
      _rebuildMarkers();
    } finally {
      _pendingClusterIconCounts.remove(count);
    }
  }

  Future<BitmapDescriptor> _createPointMarkerIcon({
    required String kind,
    required bool selected,
  }) async {
    const width = 68.0;
    const height = 68.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final shadowPaint = Paint()
      ..color = const Color(0x330B0D0E)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    final bodyPaint = Paint()
      ..color = selected ? const Color(0xFFF36F7F) : Colors.white;
    final symbolPaint = Paint()
      ..color = selected ? Colors.white : const Color(0xFF9AAEC8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final bodyRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(12, 12, 44, 44),
      const Radius.circular(11),
    );

    canvas.drawRRect(bodyRect.shift(const Offset(0, 2)), shadowPaint);
    canvas.drawRRect(bodyRect, bodyPaint);

    _drawScaledSymbol(canvas, () {
      switch (kind) {
        case 'restaurant':
          _drawRestaurantSymbol(canvas, symbolPaint);
          break;
        case 'shop':
          _drawShopSymbol(canvas, symbolPaint);
          break;
        case 'ferrisWheel':
        default:
          _drawFerrisWheelSymbol(canvas, symbolPaint);
          break;
      }
    });

    final image =
        await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();
    if (bytes == null || bytes.isEmpty) {
      return BitmapDescriptor.defaultMarker;
    }
    return BitmapDescriptor.bytes(bytes);
  }

  void _drawFerrisWheelSymbol(Canvas canvas, Paint paint) {
    const center = Offset(34, 34);
    canvas.drawCircle(center, 11, paint);
    canvas.drawCircle(center, 1.8, paint);
    canvas.drawLine(const Offset(34, 23), const Offset(34, 45), paint);
    canvas.drawLine(const Offset(23, 34), const Offset(45, 34), paint);
    canvas.drawLine(const Offset(27, 27), const Offset(41, 41), paint);
    canvas.drawLine(const Offset(41, 27), const Offset(27, 41), paint);
    canvas.drawLine(const Offset(24, 46), const Offset(44, 46), paint);
    canvas.drawLine(const Offset(29, 46), const Offset(34, 37), paint);
    canvas.drawLine(const Offset(39, 46), const Offset(34, 37), paint);
  }

  void _drawRestaurantSymbol(Canvas canvas, Paint paint) {
    final knifePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawLine(const Offset(28, 22), const Offset(28, 45), paint);
    canvas.drawLine(const Offset(24, 22), const Offset(24, 30), paint);
    canvas.drawLine(const Offset(28, 22), const Offset(28, 30), paint);
    canvas.drawLine(const Offset(32, 22), const Offset(32, 30), paint);

    final knifePath = Path()
      ..moveTo(40, 22)
      ..lineTo(40, 45)
      ..moveTo(40, 22)
      ..quadraticBezierTo(46, 25, 43, 35);
    canvas.drawPath(knifePath, knifePaint);
  }

  void _drawShopSymbol(Canvas canvas, Paint paint) {
    final bagRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(23, 28, 22, 17),
      const Radius.circular(3),
    );
    canvas.drawRRect(bagRect, paint);
    final handlePath = Path()
      ..moveTo(28, 28)
      ..quadraticBezierTo(34, 19, 40, 28);
    canvas.drawPath(handlePath, paint);
  }

  Future<BitmapDescriptor> _createClusterIcon(String label) async {
    const size = 58.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const center = Offset(size / 2, size / 2);

    final ringPaint = Paint()..color = Colors.white;
    final fillPaint = Paint()..color = const Color(0xFF006876);

    canvas.drawCircle(center, 23, ringPaint);
    canvas.drawCircle(center, 19.5, fillPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );

    final image =
        await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData?.buffer.asUint8List();
    if (bytes == null || bytes.isEmpty) {
      return BitmapDescriptor.defaultMarker;
    }
    return BitmapDescriptor.bytes(bytes);
  }
}

class _PointCluster {
  final List<ChildrenParkMapPoint> points;
  final double centerLat;
  final double centerLng;
  final double collisionRadiusPx;

  const _PointCluster({
    required this.points,
    required this.centerLat,
    required this.centerLng,
    required this.collisionRadiusPx,
  });
}

class _ClusterNode {
  final List<ChildrenParkMapPoint> points;
  final double centerLat;
  final double centerLng;
  final double worldX;
  final double worldY;
  final double radiusPx;

  const _ClusterNode({
    required this.points,
    required this.centerLat,
    required this.centerLng,
    required this.worldX,
    required this.worldY,
    required this.radiusPx,
  });
}
