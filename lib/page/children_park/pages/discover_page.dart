import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/page/children_park/widgets/children_park_widgets.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_text.dart';

class ChildrenParkDiscoverPage extends GetView<ChildrenParkController> {
  const ChildrenParkDiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const ParkSearchBar(hint: '探索遊樂園'),
            const SizedBox(height: 16),
            ParkSectionTitle(
              title: '今日熱門 (Hot Today)',
              trailing: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: TPColors.primary50,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(Icons.local_fire_department_rounded,
                    color: TPColors.primary700),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 252,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) => _HotAttractionCard(
                  attraction: controller.hotToday[index],
                  isPrimary: index == 0,
                ),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: controller.hotToday.length,
              ),
            ),
            const SizedBox(height: 14),
            const _MetricsCards(),
            const SizedBox(height: 18),
            const ParkSectionTitle(
              title: '等最少 (Shortest Wait)',
              subtitle: '現在最適合前往',
            ),
            const SizedBox(height: 10),
            ...controller.shortestWait.map(
              (attraction) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AttractionListCard(attraction: attraction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HotAttractionCard extends StatelessWidget {
  final ParkAttraction attraction;
  final bool isPrimary;

  const _HotAttractionCard({
    required this.attraction,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPrimary ? TPColors.primary200 : TPColors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: Stack(
              children: [
                Image.network(
                  attraction.imageUrl,
                  height: 142,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: WaitBadge(
                      label: attraction.waitLabel, level: attraction.waitLevel),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TPText(
                  attraction.name,
                  style: TPTextStyles.h3SemiBold.copyWith(fontSize: 22),
                  color: TPColors.grayscale900,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    _Tag(
                      text: isPrimary ? '必玩設施' : '經典',
                      textColor: TPColors.red700,
                      bgColor: TPColors.red50,
                    ),
                    _Tag(
                      text: attraction.status,
                      textColor: TPColors.primary700,
                      bgColor: TPColors.primary50,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TPText(
                  attraction.description,
                  style: TPTextStyles.bodyRegular,
                  color: TPColors.grayscale700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsCards extends StatelessWidget {
  const _MetricsCards();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _MetricCard(label: '目前園區人潮', value: '中等'),
        _MetricCard(label: '平均等待時間', value: '22 分鐘'),
        _MetricCard(label: '推薦路線', value: '親子輕鬆路線'),
        _MetricCard(label: '今日天氣', value: '晴'),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.sizeOf(context).width - 42) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TPColors.grayscale100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TPText(
            label,
            style: TPTextStyles.caption,
            color: TPColors.grayscale600,
          ),
          const SizedBox(height: 6),
          TPText(
            value,
            style: TPTextStyles.bodySemiBold,
            color: TPColors.grayscale900,
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color bgColor;

  const _Tag({
    required this.text,
    required this.textColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TPText(
        text,
        style: TPTextStyles.caption,
        color: textColor,
      ),
    );
  }
}
