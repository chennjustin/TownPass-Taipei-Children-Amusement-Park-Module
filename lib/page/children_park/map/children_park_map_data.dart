import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:town_pass/page/children_park/map/children_park_map_models.dart';

abstract final class ChildrenParkMapData {
  static const _facilityGeoJsonAsset = 'assets/children_park/map/new_map.geojson';
  static const _restaurantGeoJsonAsset =
      'assets/children_park/map/restaurant2.geojson';
  static const _placeDetailsAsset =
      'assets/children_park/map/place-details.json';

  static Future<List<ChildrenParkMapPoint>> loadAllPoints() async {
    final results = await Future.wait([
      _loadPointsFromGeoJson(
        _facilityGeoJsonAsset,
        ChildrenParkMapPointType.facility,
      ),
      _loadPointsFromGeoJson(
        _restaurantGeoJsonAsset,
        ChildrenParkMapPointType.restaurant,
      ),
    ]);
    return [...results[0], ...results[1]];
  }

  static Future<List<ChildrenParkPlaceDetail>> loadPlaceDetails() async {
    final raw = await rootBundle.loadString(_placeDetailsAsset);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final places = json['places'] as List<dynamic>? ?? [];
    return places.map((item) {
      final map = item as Map<String, dynamic>;
      final filtersRaw = map['filters'] as Map<String, dynamic>?;
      ChildrenParkPlaceFilters? filters;
      if (filtersRaw != null) {
        filters = ChildrenParkPlaceFilters(
          height: filtersRaw['height'] as String?,
          thrill: filtersRaw['thrill'] as String?,
          environment: (filtersRaw['environment'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
          price: filtersRaw['price'] as String?,
          special: (filtersRaw['special'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              const [],
        );
      }
      return ChildrenParkPlaceDetail(
        name: map['name'] as String? ?? '',
        aliases: (map['aliases'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        category: map['category'] as String? ?? '',
        description: map['description'] as String? ?? '',
        filters: filters,
      );
    }).toList();
  }

  static Future<List<ChildrenParkMapPoint>> _loadPointsFromGeoJson(
    String assetPath,
    ChildrenParkMapPointType pointType,
  ) async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final features = json['features'] as List<dynamic>? ?? [];

    return features
        .whereType<Map<String, dynamic>>()
        .where((feature) => feature['geometry']?['type'] == 'Point')
        .toList()
        .asMap()
        .entries
        .map((entry) {
          final feature = entry.value;
          final index = entry.key;
          final geometry = feature['geometry'] as Map<String, dynamic>?;
          final coordinates = geometry?['coordinates'] as List<dynamic>?;
          final lng = (coordinates?.elementAt(0) as num?)?.toDouble() ?? 121.5151;
          final lat = (coordinates?.elementAt(1) as num?)?.toDouble() ?? 25.0974;
          final properties = feature['properties'] as Map<String, dynamic>? ?? {};
          final name = (properties['name'] as String?)?.trim();
          final rawCategory = (properties['type'] as String?)?.trim();
          final category = rawCategory != null && rawCategory.isNotEmpty
              ? rawCategory
              : pointType == ChildrenParkMapPointType.facility
                  ? '設施'
                  : '餐廳';
          final rawId = properties['id'] ?? properties['fid'] ?? index + 1;
          return ChildrenParkMapPoint(
            id: '${pointType.name}-$rawId',
            name: name != null && name.isNotEmpty
                ? name
                : '${pointType.name}-${index + 1}',
            floor: properties['floor'] as int?,
            category: category,
            lat: lat,
            lng: lng,
            pointType: pointType,
          );
        })
        .toList();
  }
}
