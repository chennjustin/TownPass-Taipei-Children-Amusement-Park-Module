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
                    onTap: () => controller.filterPanelOpen.value =
                        !controller.filterPanelOpen.value,
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
          if (controller.filterPanelOpen.value &&
              controller.selectedContentType.value ==
                  ChildrenParkMapContentType.facility)
            _FilterPanel(controller: controller),
        ],
      ),
    );
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

class _FilterPanel extends StatelessWidget {
  final ChildrenParkMapController controller;

  const _FilterPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TPColors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TPColors.grayscale100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0B0D0E),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filterGroup(
              '身高限制',
              'height',
              ChildrenParkMapConstants.heightFilterOptions,
            ),
            const SizedBox(height: 10),
            _filterGroup(
              '尖叫指數',
              'thrill',
              ChildrenParkMapConstants.thrillFilterOptions,
            ),
            const SizedBox(height: 10),
            _filterGroup(
              '室內外',
              'environment',
              ChildrenParkMapConstants.environmentFilterOptions,
            ),
            const SizedBox(height: 10),
            _filterGroup(
              '票價 / 類型',
              'price',
              ChildrenParkMapConstants.priceFilterOptions,
            ),
            const SizedBox(height: 10),
            _filterGroup(
              '特殊族群',
              'special',
              ChildrenParkMapConstants.specialFilterOptions,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.rideFilters.value.activeCount > 0
                        ? '已套用 ${controller.rideFilters.value.activeCount} 個篩選'
                        : '尚未套用篩選',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: TPColors.grayscale500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: controller.clearRideFilters,
                  child: const Text(
                    '清除篩選',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: TPColors.primary700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterGroup(String label, String key, List<String> options) {
    final filters = controller.rideFilters.value;
    final selectedValues = switch (key) {
      'height' => filters.height,
      'thrill' => filters.thrill,
      'environment' => filters.environment,
      'price' => filters.price,
      'special' => filters.special,
      _ => <String>[],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: TPColors.grayscale500,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final selected = selectedValues.contains(option);
            return FilterChip(
              label: Text(option, style: const TextStyle(fontSize: 12)),
              selected: selected,
              onSelected: (_) => controller.toggleRideFilter(key, option),
              selectedColor: TPColors.primary700,
              checkmarkColor: TPColors.white,
              labelStyle: TextStyle(
                color: selected ? TPColors.white : TPColors.grayscale700,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: selected ? TPColors.primary700 : TPColors.grayscale100,
              ),
              backgroundColor: TPColors.white,
            );
          }).toList(),
        ),
      ],
    );
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
              child: GestureDetector(
                onTap: () => controller.showPointDetail(point),
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
                  ],
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
  final ChildrenParkMapPoint point;
  final VoidCallback onClose;

  const _DetailCard({required this.point, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final wait = point.pointType == ChildrenParkMapPointType.facility
        ? getFacilityWaitMinutes(point)
        : null;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: TPColors.primary700,
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: TPColors.grayscale900,
            ),
          ),
          if (wait != null) ...[
            const SizedBox(height: 6),
            Text(
              '等待 $wait 分鐘',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: TPColors.primary700,
              ),
            ),
          ],
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
