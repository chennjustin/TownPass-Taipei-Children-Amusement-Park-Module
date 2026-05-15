import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/page/children_park/widgets/children_park_sub_page_header.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkTransportView extends StatelessWidget {
  const ChildrenParkTransportView({super.key});

  static const List<String> _metroBusRoutes = [
    '捷運劍潭站出口 3 -> 公車轉乘站 -> 41、紅 30、兒樂 2 號線、529（例假日停駛）、市民小巴 8 -> 兒童新樂園',
    '捷運士林站出口 1 -> 公車轉乘站 -> 255 區、紅 30、兒樂 1 號線（平日停駛） -> 兒童新樂園',
    '捷運芝山站出口 1 -> 公車轉乘站 -> 兒樂 1 號線（平日停駛） -> 兒童新樂園',
    '捷運士林站出口 1 -> 公車轉乘站 -> 紅 12、557 -> 國立科教館站下車，步行至兒童新樂園（約 4 分鐘）',
    '捷運士林站出口 1 -> 公車轉乘站 -> 北環幹線（原 620） -> 士林監理站下車，步行至兒童新樂園（約 3 分鐘）',
  ];

  static const List<String> _bikeRoutes = [
    '捷運劍潭站出口 2 YouBike 租賃站 -> 兒童新樂園大門公車候車亭 YouBike 租賃站',
    '捷運士林站出口 2 YouBike 租賃站 -> 兒童新樂園大門公車候車亭 YouBike 租賃站',
  ];

  static const List<String> _walkingRoutes = [
    '捷運劍潭站出口 1 -> 直行基河路（約 2 公里） -> 兒童新樂園',
    '捷運士林站出口 1 -> 直行中正路，右轉基河路（約 1.5 公里） -> 兒童新樂園',
  ];

  static const List<String> _drivingRoutes = [
    '國道一號：圓山（松江路）交流道 -> 民族東路 -> 民族西路 -> 承德路 -> 文林路 587 巷 -> 兒童新樂園',
    '國道一號：臺北（重慶北路）交流道 -> 百齡橋 -> 承德路 -> 文林路 587 巷 -> 兒童新樂園',
    '國道三號：木柵交流道 -> 國道 3 甲 -> 辛亥路 -> 建國高架道路 -> 國道 1 號（往桃園方向）-> 臺北（重慶北路）交流道 -> 百齡橋 -> 承德路 -> 文林路 587 巷 -> 兒童新樂園',
  ];

  @override
  Widget build(BuildContext context) {
    return ChildrenParkShell(
      title: '交通資訊',
      currentRoute: TPRoute.childrenParkTransport,
      showBottomNavigation: false,
      body: Column(
        children: [
          const ChildrenParkSubPageHeader(title: '交通資訊'),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _sectionIconTitle(
                  icon: Icons.directions_bus_outlined,
                  title: '一、大眾運輸',
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TPColors.grayscale50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '捷運轉乘公車',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: TPColors.grayscale900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._metroBusRoutes.map(_bulletText),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '捷運轉乘公共自行車（YouBike）',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TPColors.grayscale900,
                  ),
                ),
                const SizedBox(height: 8),
                ..._bikeRoutes.map(_bulletText),
                const SizedBox(height: 12),
                const Text(
                  '步行',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TPColors.grayscale900,
                  ),
                ),
                const SizedBox(height: 8),
                ..._walkingRoutes.map(_bulletText),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TPColors.grayscale100),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '高鐵、臺鐵',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: TPColors.grayscale900,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '• 搭乘至臺北車站，轉捷運淡水信義線至劍潭站、士林站或芝山站，再轉乘公車。',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: TPColors.grayscale700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: TPColors.grayscale100, height: 1),
                const SizedBox(height: 20),
                _sectionIconTitle(
                  icon: Icons.directions_car_outlined,
                  title: '二、開車資訊',
                ),
                const SizedBox(height: 12),
                ..._drivingRoutes.map(_bulletText),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TPColors.grayscale100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.navigation_outlined,
                          size: 16, color: TPColors.primary700),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'GPS 座標：東經 121°30\'54.5"、北緯 25°05\'48"',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: TPColors.grayscale800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: TPColors.grayscale100, height: 1),
                const SizedBox(height: 20),
                _sectionIconTitle(
                  icon: Icons.local_parking_outlined,
                  title: '三、停車場資訊',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _parkingStatCard('汽車車格', '442'),
                    const SizedBox(width: 8),
                    _parkingStatCard('機車車格', '393'),
                    const SizedBox(width: 8),
                    _parkingStatCard('限高', '2.1m'),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '位置：請由園區北側文林路 587 巷出入口進入。',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: TPColors.grayscale700,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  '收費標準',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TPColors.grayscale900,
                  ),
                ),
                const SizedBox(height: 8),
                _bulletText(
                  '汽車：平日 30 元/時、假日 40 元/時（8:00-20:00）；夜間 10 元/時（20:00-翌日 8:00）。',
                ),
                _bulletText('機車：20 元/次，隔日另計。'),
                _bulletText('收費以 30 分鐘為單位，未滿 30 分鐘以 30 分鐘計。'),
                _bulletText('支援悠遊卡與多項多元支付。'),
                _bulletText(
                  '身心障礙停車優惠：汽車免費 4 小時，超過後半價；機車依費率半價（請持證件正本至管理室辦理）。',
                ),
                _bulletText('夜間（閉園至翌日 6 時）不開放臨停入場。'),
                const SizedBox(height: 14),
                const Text(
                  '月票資訊',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: TPColors.grayscale900,
                  ),
                ),
                const SizedBox(height: 8),
                _bulletText('提供汽車限時夜間月票與機車全時月票；里民優惠依現場公告。'),
                _bulletText('申請請備妥身分與車輛證件正本至汽車管理室辦理。'),
                _bulletText('月票時間：汽車 17:30-翌日 9:00；機車 24 小時。'),
                _bulletText('不提供固定或保留車位，滿位時需排隊。'),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TPColors.grayscale50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '停車場管理室 / 24 小時客服：(02) 2834-5378',
                    style: TextStyle(
                      fontSize: 14,
                      color: TPColors.grayscale700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Get.toNamed(TPRoute.childrenParkMap),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '查看園區地圖',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: TPColors.primary700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                          size: 16, color: TPColors.primary700),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.place_outlined,
                        size: 14, color: TPColors.grayscale500),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '地址：台北市士林區承德路五段 55 號',
                        style: TextStyle(
                          fontSize: 12,
                          color: TPColors.grayscale500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sectionIconTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: TPColors.primary700),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: TPColors.grayscale900,
          ),
        ),
      ],
    );
  }

  static Widget _bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '• $text',
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: TPColors.grayscale700,
        ),
      ),
    );
  }

  static Widget _parkingStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: TPColors.grayscale100),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: TPColors.grayscale500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TPColors.grayscale900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
