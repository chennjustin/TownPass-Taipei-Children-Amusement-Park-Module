import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkTransportView extends StatelessWidget {
  const ChildrenParkTransportView({super.key});

  static const List<String> _metroBusRoutes = [
    '捷運劍潭站出口 3 轉乘：41、紅 30、兒樂 2 號線、529、市民小巴 8',
    '捷運士林站出口 1 轉乘：255 區、紅 30、兒樂 1 號線',
    '捷運芝山站出口 1 轉乘：兒樂 1 號線（平日停駛）',
  ];

  static const List<String> _drivingRoutes = [
    '國道一號圓山交流道 -> 民族東路 -> 承德路 -> 文林路 587 巷',
    '國道一號重慶北交流道 -> 百齡橋 -> 承德路 -> 文林路 587 巷',
    '國道三號木柵交流道 -> 國 3 甲 -> 建國高架 -> 重慶北交流道',
  ];

  @override
  Widget build(BuildContext context) {
    return ChildrenParkShell(
      title: '交通資訊',
      currentRoute: TPRoute.childrenParkTransport,
      showBottomNavigation: false,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          _headerAction(
            icon: Icons.arrow_back_ios_new,
            title: '回首頁',
            onTap: () => Get.offNamed(TPRoute.childrenParkHome),
          ),
          const SizedBox(height: 14),
          _sectionTitle('一、大眾運輸', Icons.directions_bus_outlined),
          const SizedBox(height: 8),
          ..._metroBusRoutes.map((route) => _bullet(route)),
          const SizedBox(height: 16),
          _sectionTitle('二、開車資訊', Icons.directions_car_outlined),
          const SizedBox(height: 8),
          ..._drivingRoutes.map((route) => _bullet(route)),
          const SizedBox(height: 16),
          _sectionTitle('三、停車場資訊', Icons.local_parking_outlined),
          const SizedBox(height: 8),
          _bullet('汽車車格：442 位；機車車格：393 位；限高 2.1m'),
          _bullet('平日 30 元/時、假日 40 元/時，夜間 10 元/時'),
          _bullet('地址：台北市士林區承德路五段 55 號'),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => Get.toNamed(TPRoute.childrenParkMap),
            icon: const Icon(Icons.map_outlined),
            label: const Text('查看園區地圖'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.circle, size: 6, color: Color(0xFF6B7280)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.45, color: Color(0xFF374151)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(title),
      ),
    );
  }
}
