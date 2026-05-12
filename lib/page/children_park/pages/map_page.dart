import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/page/children_park/widgets/children_park_widgets.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_text.dart';

class ChildrenParkMapPage extends GetView<ChildrenParkController> {
  const ChildrenParkMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              const ParkSearchBar(hint: 'Search attractions...'),
              const SizedBox(height: 10),
              _CategoryChips(controller: controller),
              const SizedBox(height: 10),
              Expanded(
                child: Stack(
                  children: [
                    _MockParkMap(controller: controller),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _NearbyPopularSheet(controller: controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final ChildrenParkController controller;

  const _CategoryChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final bool selected =
                controller.selectedCategoryIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectedCategoryIndex.value = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? TPColors.primary700 : TPColors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color:
                        selected ? TPColors.primary700 : TPColors.grayscale100,
                  ),
                ),
                child: TPText(
                  controller.mapCategories[index],
                  style: TPTextStyles.bodySemiBold,
                  color: selected ? TPColors.white : TPColors.grayscale700,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: controller.mapCategories.length,
        ),
      ),
    );
  }
}

class _MockParkMap extends StatelessWidget {
  final ChildrenParkController controller;

  const _MockParkMap({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDFF5FF), Color(0xFFF4FBFF)],
          ),
        ),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Stack(
              children: [
                ...List.generate(
                  5,
                  (index) => Positioned(
                    left: 20 + (index * 72),
                    top: 34 + (index % 2) * 34,
                    child: Container(
                      width: 52,
                      height: 14,
                      decoration: BoxDecoration(
                        color: TPColors.white.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                ...controller.attractions.take(8).map(
                      (attraction) => Positioned(
                        left: constraints.maxWidth * attraction.mapX - 40,
                        top: constraints.maxHeight * attraction.mapY - 26,
                        child: _MapMarker(attraction: attraction),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final ParkAttraction attraction;

  const _MapMarker({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WaitBadge(label: attraction.waitLabel, level: attraction.waitLevel),
        const SizedBox(height: 4),
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: TPColors.primary700,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.place_rounded,
            color: TPColors.white,
            size: 14,
          ),
        ),
      ],
    );
  }
}

class _NearbyPopularSheet extends StatelessWidget {
  final ChildrenParkController controller;

  const _NearbyPopularSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: const BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              width: 38,
              child: Divider(
                thickness: 4,
                color: TPColors.grayscale100,
              ),
            ),
          ),
          const ParkSectionTitle(
            title: '附近的熱門設施',
            subtitle: '根據您的目前位置推薦',
          ),
          const SizedBox(height: 10),
          ...controller.nearbyPopular.map(
            (attraction) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AttractionListCard(attraction: attraction),
            ),
          ),
        ],
      ),
    );
  }
}
