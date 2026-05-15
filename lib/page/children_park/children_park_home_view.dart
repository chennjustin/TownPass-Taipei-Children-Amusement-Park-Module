import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/widgets/children_park_widgets.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkHomeView extends GetView<ChildrenParkController> {
  const ChildrenParkHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChildrenParkShell(
      title: '兒童新樂園',
      currentRoute: TPRoute.childrenParkHome,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          const ParkSearchBar(hint: '探索園區活動與服務'),
          const SizedBox(height: 14),
          _quickLinkCard(
            title: '交通方式',
            subtitle: '捷運、公車、停車資訊一次看',
            icon: Icons.directions_bus_outlined,
            onTap: () => Get.toNamed(TPRoute.childrenParkTransport),
          ),
          const SizedBox(height: 10),
          _quickLinkCard(
            title: '常見問題',
            subtitle: '票價、營業時間、遊園須知',
            icon: Icons.help_outline,
            onTap: () => Get.toNamed(TPRoute.childrenParkFaq),
          ),
          const SizedBox(height: 18),
          const Text(
            '即時資訊',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _metricCard(label: '今日人潮', value: '舒適'),
              _metricCard(label: '平均等待', value: '22 分鐘'),
              _metricCard(label: '推薦設施', value: '旋轉木馬'),
              _metricCard(label: '營業時間', value: '09:00 - 21:00'),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            '熱門設施',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...controller.hotToday.take(3).map(
                (attraction) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AttractionListCard(attraction: attraction),
                ),
              ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(TPRoute.childrenParkEvents),
            icon: const Icon(Icons.event_note_outlined),
            label: const Text('查看今日活動行程'),
          ),
        ],
      ),
    );
  }

  Widget _quickLinkCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1565C0)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF4B5563)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _metricCard({required String label, required String value}) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
