import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/util/tp_colors.dart';

class ChildrenParkMapPage extends GetView<ChildrenParkController> {
  const ChildrenParkMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedAttraction = controller.attractions.first;
    return Stack(
      children: [
        _MapCanvas(controller: controller),
        Positioned(
          left: 12,
          right: 12,
          top: 10,
          child: _TopControls(controller: controller),
        ),
        Positioned(
          right: 12,
          bottom: 226,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () {},
            child: Ink(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: TPColors.white,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.gps_fixed, color: TPColors.grayscale700),
            ),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 8,
          child: _AttractionBottomSheet(attraction: selectedAttraction),
        ),
      ],
    );
  }
}

class _MapCanvas extends StatelessWidget {
  final ChildrenParkController controller;

  const _MapCanvas({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE9F8FF), Color(0xFFF6FBFF)],
        ),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Stack(
            children: [
              ...List.generate(
                8,
                (index) => Positioned(
                  left: 20 + (index * 48),
                  top: 95 + (index % 3) * 42,
                  child: Container(
                    width: 36,
                    height: 10,
                    decoration: BoxDecoration(
                      color: TPColors.white.withValues(alpha: 0.52),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
              ...controller.attractions.take(8).toList().asMap().entries.map(
                    (entry) => Positioned(
                      left: constraints.maxWidth * entry.value.mapX - 22,
                      top: constraints.maxHeight * entry.value.mapY - 35,
                      child: _MapMarker(
                        waitLabel: entry.value.waitLabel,
                        icon:
                            entry.key == 0 ? Icons.rocket_launch : Icons.place,
                        isPrimary: entry.key == 0,
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final String waitLabel;
  final IconData icon;
  final bool isPrimary;

  const _MapMarker({
    required this.waitLabel,
    required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPrimary ? TPColors.primary700 : TPColors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isPrimary ? TPColors.primary700 : TPColors.grayscale100,
            ),
          ),
          child: Text(
            waitLabel,
            style: TextStyle(
              color: isPrimary ? TPColors.white : TPColors.grayscale700,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: isPrimary ? 36 : 30,
          height: isPrimary ? 36 : 30,
          decoration: BoxDecoration(
            color: TPColors.primary700,
            shape: BoxShape.circle,
            border: Border.all(color: TPColors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: TPColors.white,
            size: isPrimary ? 18 : 14,
          ),
        ),
      ],
    );
  }
}

class _TopControls extends StatelessWidget {
  final ChildrenParkController controller;

  const _TopControls({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: TPColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: TPColors.grayscale100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, size: 18, color: TPColors.grayscale700),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '搜尋設施或表演...',
                        style: TextStyle(color: TPColors.grayscale700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TPColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TPColors.grayscale100),
              ),
              child: const Icon(Icons.tune, color: TPColors.primary700),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 34,
          child: Obx(
            () => ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final selected =
                    controller.selectedCategoryIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectedCategoryIndex.value = index,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? TPColors.primary700 : TPColors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: selected
                            ? TPColors.primary700
                            : TPColors.grayscale100,
                      ),
                    ),
                    child: Text(
                      controller.mapCategories[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            selected ? TPColors.white : TPColors.grayscale700,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: controller.mapCategories.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _AttractionBottomSheet extends StatelessWidget {
  final ParkAttraction attraction;

  const _AttractionBottomSheet({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
      decoration: const BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 14,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              width: 34,
              child: Divider(
                thickness: 4,
                color: TPColors.grayscale100,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        _MiniTag(text: '冒險區'),
                        SizedBox(width: 6),
                        Text(
                          '已開放',
                          style: TextStyle(
                            fontSize: 11,
                            color: TPColors.grayscale700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      attraction.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${attraction.waitMinutes ?? '--'}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: TPColors.primary700,
                      height: 1,
                    ),
                  ),
                  const Text(
                    '分鐘等候',
                    style:
                        TextStyle(fontSize: 11, color: TPColors.grayscale700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.height,
                  title: '身高限制',
                  value: '110cm 以上',
                  iconColor: TPColors.primary700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoCard(
                  icon: Icons.confirmation_num_outlined,
                  title: '通行證',
                  value: '適用快通',
                  iconColor: const Color(0xFF9C6200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.navigation_outlined),
                  label: const Text('立即前往'),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 48,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.bookmark_border),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TPColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: TPColors.grayscale100),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: TPColors.grayscale700,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String text;

  const _MiniTag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: TPColors.primary700,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
