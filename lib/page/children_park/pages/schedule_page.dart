import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/page/children_park/widgets/children_park_widgets.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_text.dart';

class ChildrenParkSchedulePage extends GetView<ChildrenParkController> {
  const ChildrenParkSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const ParkSearchBar(hint: '本日演出行程'),
            const SizedBox(height: 14),
            _DateTabs(controller: controller),
            const SizedBox(height: 18),
            _TimelineSection(
              title: '早晨時段',
              color: const Color(0xFFBFEAFF),
              events: controller.eventsByPeriod('早晨時段'),
            ),
            const SizedBox(height: 16),
            _TimelineSection(
              title: '下午時段',
              color: const Color(0xFFFFD7D7),
              events: controller.eventsByPeriod('下午時段'),
            ),
            const SizedBox(height: 16),
            _TimelineSection(
              title: '晚上時段',
              color: const Color(0xFFD9E7FF),
              events: controller.eventsByPeriod('晚上時段'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTabs extends StatelessWidget {
  final ChildrenParkController controller;

  const _DateTabs({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final bool selected = controller.selectedDateIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectedDateIndex.value = index,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? TPColors.primary700 : TPColors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color:
                        selected ? TPColors.primary700 : TPColors.grayscale100,
                  ),
                ),
                child: TPText(
                  controller.dateTabs[index],
                  style: TPTextStyles.h3SemiBold,
                  color: selected ? TPColors.white : TPColors.grayscale700,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemCount: controller.dateTabs.length,
        ),
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<ParkEvent> events;

  const _TimelineSection({
    required this.title,
    required this.color,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(Icons.wb_sunny_outlined,
                    size: 16, color: TPColors.primary800),
              ),
              const SizedBox(width: 8),
              TPText(
                title,
                style: TPTextStyles.h2SemiBold.copyWith(fontSize: 30),
                color: TPColors.primary800,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _EventCard(event: event),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final ParkEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FCFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TPColors.primary100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            child: Stack(
              children: [
                Image.network(
                  event.imageUrl,
                  width: double.infinity,
                  height: 132,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: TPColors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: TPText(
                      event.status,
                      style: TPTextStyles.caption,
                      color: TPColors.primary800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TPText(
                        event.timeText,
                        style: TPTextStyles.titleSemiBold,
                        color: TPColors.primary700,
                      ),
                      const SizedBox(height: 3),
                      TPText(
                        event.name,
                        style: TPTextStyles.h3SemiBold.copyWith(fontSize: 26),
                        color: TPColors.grayscale900,
                      ),
                      const SizedBox(height: 2),
                      TPText(
                        event.location,
                        style: TPTextStyles.bodyRegular,
                        color: TPColors.grayscale700,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: TPColors.primary50,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.notifications_none_rounded,
                      color: TPColors.primary700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
