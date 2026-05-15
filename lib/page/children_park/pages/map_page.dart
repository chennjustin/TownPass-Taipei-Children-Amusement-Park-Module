import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:town_pass/page/children_park/map/children_park_map_constants.dart';
import 'package:town_pass/page/children_park/map/children_park_map_controller.dart';
import 'package:town_pass/page/children_park/map/children_park_map_helpers.dart';
import 'package:town_pass/page/children_park/map/children_park_map_models.dart';
import 'package:town_pass/util/tp_colors.dart';

class ChildrenParkMapPage extends GetView<ChildrenParkMapController> {
  const ChildrenParkMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: TPColors.primary700),
        );
      }

      return Stack(
        children: [
          Obx(
            () => GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: ChildrenParkMapConstants.parkCenter,
                zoom: ChildrenParkMapConstants.initialZoom,
              ),
              minMaxZoomPreference: const MinMaxZoomPreference(
                ChildrenParkMapConstants.minZoom,
                null,
              ),
              cameraTargetBounds: CameraTargetBounds(
                ChildrenParkMapConstants.parkBounds,
              ),
              onMapCreated: (mapController) => controller.onMapCreated(
                mapController,
                createLocalImageConfiguration(context),
              ),
              markers: controller.markers.value,
              groundOverlays: controller.groundOverlays.value,
              onCameraMove: controller.onCameraMove,
              onCameraIdle: controller.onCameraIdle,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            top: 8,
            child: _TopControls(controller: controller),
          ),
          Positioned(
            right: 12,
            bottom: 210,
            child: _GpsButton(onTap: controller.recenterPark),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 8,
            child: _BottomCarousel(controller: controller),
          ),
        ],
      );
    });
  }
}

class _TopControls extends StatelessWidget {
  final ChildrenParkMapController controller;

  const _TopControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: TPColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TPColors.grayscale100),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x140B0D0E),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _contentTypeTab(
                  label: '遊樂設施',
                  icon: Icons.attractions_outlined,
                  type: ChildrenParkMapContentType.facility,
                ),
                _contentTypeTab(
                  label: '餐廳',
                  icon: Icons.restaurant_outlined,
                  type: ChildrenParkMapContentType.restaurant,
                ),
                _contentTypeTab(
                  label: '商店',
                  icon: Icons.shopping_bag_outlined,
                  type: ChildrenParkMapContentType.shop,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: TPColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TPColors.grayscale100),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x140B0D0E),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: controller.onQueryChanged,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 18),
                      hintText: '搜尋設施、餐廳或類型',
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              if (controller.selectedContentType.value ==
                  ChildrenParkMapContentType.facility) ...[
                const SizedBox(width: 8),
                Material(
                  color: controller.filterPanelOpen.value ||
                          controller.rideFilters.value.activeCount > 0
                      ? TPColors.primary700
                      : TPColors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _openFilterSheet(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.filterPanelOpen.value ||
                                  controller.rideFilters.value.activeCount > 0
                              ? TPColors.primary700
                              : TPColors.grayscale100,
                        ),
                      ),
                      child: Icon(
                        Icons.tune,
                        color: controller.filterPanelOpen.value ||
                                controller.rideFilters.value.activeCount > 0
                            ? TPColors.white
                            : TPColors.primary700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterSheet(BuildContext context) async {
    if (controller.selectedContentType.value !=
        ChildrenParkMapContentType.facility) {
      return;
    }
    if (controller.filterPanelOpen.value) return;
    controller.filterPanelOpen.value = true;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _FilterBottomSheet(controller: controller),
    );
    controller.filterPanelOpen.value = false;
  }

  Widget _contentTypeTab({
    required String label,
    required IconData icon,
    required ChildrenParkMapContentType type,
  }) {
    final selected = controller.selectedContentType.value == type;
    return Expanded(
      child: Material(
        color: selected ? TPColors.primary700 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => controller.selectContentType(type),
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected ? TPColors.white : TPColors.grayscale600,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? TPColors.white : TPColors.grayscale600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final ChildrenParkMapController controller;

  const _FilterBottomSheet({required this.controller});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late ChildrenParkRideFilters _draftFilters;

  @override
  void initState() {
    super.initState();
    final current = widget.controller.rideFilters.value;
    _draftFilters = current.copyWith(
      height: [...current.height],
      thrill: [...current.thrill],
      environment: [...current.environment],
      price: [...current.price],
      special: [...current.special],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.72,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: TPColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x260B0D0E),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '地圖篩選',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: TPColors.grayscale900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    _filterGroup(
                      '身高限制',
                      'height',
                      ChildrenParkMapConstants.heightFilterOptions,
                    ),
                    const SizedBox(height: 8),
                    _filterGroup(
                      '尖叫指數',
                      'thrill',
                      ChildrenParkMapConstants.thrillFilterOptions,
                    ),
                    const SizedBox(height: 8),
                    _filterGroup(
                      '室內外',
                      'environment',
                      ChildrenParkMapConstants.environmentFilterOptions,
                    ),
                    const SizedBox(height: 8),
                    _filterGroup(
                      '票價 / 類型',
                      'price',
                      ChildrenParkMapConstants.priceFilterOptions,
                    ),
                    const SizedBox(height: 8),
                    _filterGroup(
                      '特殊族群',
                      'special',
                      ChildrenParkMapConstants.specialFilterOptions,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _draftFilters.activeCount > 0
                          ? '已選擇 ${_draftFilters.activeCount} 個篩選'
                          : '尚未選擇篩選',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: TPColors.grayscale500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _draftFilters = const ChildrenParkRideFilters();
                      });
                    },
                    child: const Text(
                      '清除',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: TPColors.primary700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      widget.controller.applyRideFilters(_draftFilters);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TPColors.primary700,
                      foregroundColor: TPColors.white,
                      elevation: 0,
                      minimumSize: const Size(84, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '確認',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterGroup(String label, String key, List<String> options) {
    final filters = _draftFilters;
    final selectedValues = switch (key) {
      'height' => filters.height,
      'thrill' => filters.thrill,
      'environment' => filters.environment,
      'price' => filters.price,
      'special' => filters.special,
      _ => <String>[],
    };

    return Container(
      decoration: BoxDecoration(
        color: TPColors.grayscale50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: TPColors.grayscale700,
            ),
          ),
          subtitle: Text(
            selectedValues.isEmpty ? '未選擇' : '${selectedValues.length} 項',
            style: const TextStyle(fontSize: 11, color: TPColors.grayscale500),
          ),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                final selected = selectedValues.contains(option);
                return FilterChip(
                  label: Text(option, style: const TextStyle(fontSize: 12)),
                  selected: selected,
                  onSelected: (_) => _toggleDraftFilter(key, option),
                  selectedColor: TPColors.primary700,
                  checkmarkColor: TPColors.white,
                  labelStyle: TextStyle(
                    color: selected ? TPColors.white : TPColors.grayscale700,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(
                    color:
                        selected ? TPColors.primary700 : TPColors.grayscale100,
                  ),
                  backgroundColor: TPColors.white,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDraftFilter(String key, String value) {
    List<String> singleSelect(List<String> list) {
      if (list.contains(value)) {
        return <String>[];
      }
      return <String>[value];
    }

    setState(() {
      _draftFilters = switch (key) {
        'height' =>
          _draftFilters.copyWith(height: singleSelect(_draftFilters.height)),
        'thrill' =>
          _draftFilters.copyWith(thrill: singleSelect(_draftFilters.thrill)),
        'environment' => _draftFilters.copyWith(
            environment: singleSelect(_draftFilters.environment),
          ),
        'price' =>
          _draftFilters.copyWith(price: singleSelect(_draftFilters.price)),
        'special' =>
          _draftFilters.copyWith(special: singleSelect(_draftFilters.special)),
        _ => _draftFilters,
      };
    });
  }
}

class _GpsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GpsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TPColors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 46,
          height: 46,
          child: Icon(Icons.gps_fixed, color: TPColors.grayscale700),
        ),
      ),
    );
  }
}

class _BottomCarousel extends StatelessWidget {
  final ChildrenParkMapController controller;

  const _BottomCarousel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedPoint.value;
      if (selected != null) {
        return _DetailCard(
          controller: controller,
          point: selected,
          onClose: controller.closePointDetail,
        );
      }

      final point = controller.carouselPoint;
      if (point == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration,
          child: Text(
            controller.statusText.value,
            style: const TextStyle(
              fontSize: 13,
              color: TPColors.grayscale600,
            ),
          ),
        );
      }

      final points = controller.visiblePoints;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        decoration: _cardDecoration,
        child: Row(
          children: [
            IconButton(
              onPressed: controller.carouselIndex <= 0
                  ? null
                  : () => controller.scrollCarouselBy(-1),
              icon:
                  const Icon(Icons.chevron_left, color: TPColors.grayscale400),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => controller.showPointDetail(point),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: point.pointType ==
                                        ChildrenParkMapPointType.facility
                                    ? TPColors.primary700
                                    : const Color(0xFFE53935),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              getPointLabel(point.pointType),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: TPColors.grayscale500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          point.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: TPColors.grayscale900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          point.pointType == ChildrenParkMapPointType.facility
                              ? '等待 ${getFacilityWaitMinutes(point)} 分鐘'
                              : point.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: TPColors.grayscale500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '點擊查看詳細資訊',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: TPColors.primary700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: controller.carouselIndex >= points.length - 1
                  ? null
                  : () => controller.scrollCarouselBy(1),
              icon:
                  const Icon(Icons.chevron_right, color: TPColors.grayscale400),
            ),
          ],
        ),
      );
    });
  }
}

class _DetailCard extends StatelessWidget {
  final ChildrenParkMapController controller;
  final ChildrenParkMapPoint point;
  final VoidCallback onClose;

  const _DetailCard({
    required this.controller,
    required this.point,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final detail = controller.detailForPoint(point);
    final wait = point.pointType == ChildrenParkMapPointType.facility
        ? getFacilityWaitMinutes(point)
        : null;
    final displayCategory = detail?.category.isNotEmpty == true
        ? detail!.category
        : point.category;
    final floorText = '${point.floor ?? 1} 樓';
    final tags = [
      detail?.filters?.height,
      detail?.filters?.thrill,
      ...?detail?.filters?.environment,
      detail?.filters?.price,
      ...?detail?.filters?.special,
    ].whereType<String>().toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.72,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
        decoration: _cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: TPColors.grayscale200,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Row(
              children: [
                _miniPill(
                  getPointLabel(point.pointType),
                  bg: const Color(0xFFE6F3FF),
                  fg: TPColors.primary700,
                ),
                const SizedBox(width: 6),
                _miniPill(
                  displayCategory,
                  bg: const Color(0xFFF3F4F6),
                  fg: TPColors.grayscale700,
                ),
                const Spacer(),
                Material(
                  color: TPColors.grayscale100,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onClose,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: TPColors.grayscale500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.name,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                        color: TPColors.grayscale900,
                        height: 1.04,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 15,
                          color: TPColors.primary700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          floorText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: TPColors.grayscale700,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: TPColors.primary700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          wait == null ? '現場資訊' : '等待 $wait 分鐘',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: TPColors.primary700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _infoBox(
                            icon: Icons.sell_outlined,
                            title: '分類',
                            value: displayCategory,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _infoBox(
                            icon: Icons.place_outlined,
                            title: '位置',
                            value: floorText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _statusCard(wait),
                    const SizedBox(height: 10),
                    _descriptionCard(detail?.description),
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: TPColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: TPColors.grayscale100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '篩選標籤',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: TPColors.grayscale500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: tags
                                  .map(
                                    (tag) => _miniPill(
                                      tag,
                                      bg: const Color(0xFFF1F4F6),
                                      fg: TPColors.grayscale700,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniPill(String text, {required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: TPColors.primary700),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: TPColors.grayscale500,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: TPColors.grayscale900,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(int? wait) {
    final isOpen = DateTime.now().hour >= 9 && DateTime.now().hour < 20;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FBFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.access_time, size: 16, color: TPColors.primary700),
              SizedBox(width: 6),
              Text(
                '營業狀態',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: TPColors.primary700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isOpen ? (wait == null ? '營業中' : '$wait 分鐘') : '非營業時間',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              height: 1,
              color: TPColors.grayscale900,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            '今日 09:00 - 20:00',
            style: TextStyle(
              fontSize: 12,
              color: TPColors.grayscale600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionCard(String? description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FBFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: TPColors.primary700),
              SizedBox(width: 6),
              Text(
                '設施介紹',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: TPColors.primary700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            description?.isNotEmpty == true ? description! : '目前沒有詳細介紹資料。',
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: TPColors.grayscale700,
            ),
          ),
        ],
      ),
    );
  }
}

const _cardDecoration = BoxDecoration(
  color: Color(0xF5FFFFFF),
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(BorderSide(color: TPColors.grayscale100)),
  boxShadow: [
    BoxShadow(
      color: Color(0x1A0B0D0E),
      blurRadius: 12,
      offset: Offset(0, -2),
    ),
  ],
);
