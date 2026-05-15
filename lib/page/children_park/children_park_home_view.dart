import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/data/children_park_faq_data.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkHomeView extends StatefulWidget {
  const ChildrenParkHomeView({super.key});

  @override
  State<ChildrenParkHomeView> createState() => _ChildrenParkHomeViewState();
}

class _ChildrenParkHomeViewState extends State<ChildrenParkHomeView> {
  int _activeBanner = 0;
  final Set<String> _expandedFaqIds = {'faq-02'};

  static const List<_BannerItem> _bannerItems = [
    _BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1513151233558-d860c5398176',
      title: '夏季嘉年華：星光遊行',
      subtitle: '每日 19:00 準時開始',
    ),
    _BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1514302240736-b1fee5985889',
      title: '週末煙火秀',
      subtitle: '每週六、日 20:00 登場',
    ),
    _BannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5',
      title: '美食街 85 折優惠',
      subtitle: '會員出示 App 即享折扣',
    ),
  ];

  static const List<_HomeActivityCard> _activityCards = [
    _HomeActivityCard(
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5',
      title: '美食街 85 折優惠',
      description: '出示 App 會員即享優惠',
      date: '即日起',
    ),
    _HomeActivityCard(
      imageUrl:
          'https://images.unsplash.com/photo-1514302240736-b1fee5985889',
      title: '週末煙火秀',
      description: '每週六、日晚上 8 點',
      date: '週末限定',
    ),
  ];

  static const List<({String name, String time})> _shortestWaits = [
    (name: '雲霄飛車', time: '10 min'),
    (name: '旋轉木馬', time: '5 min'),
    (name: '激流泛舟', time: '15 min'),
  ];

  @override
  Widget build(BuildContext context) {
    return ChildrenParkShell(
      title: '兒童新樂園',
      currentRoute: TPRoute.childrenParkHome,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          _bannerSection(),
          const SizedBox(height: 20),
          _sectionHeader(
            title: '交通方式',
            icon: Icons.directions_bus_outlined,
            trailing: _tealLink(
              label: '查看更多',
              onTap: () => Get.toNamed(TPRoute.childrenParkTransport),
            ),
          ),
          const SizedBox(height: 12),
          _transportSection(),
          const SizedBox(height: 20),
          _sectionHeader(
            title: '即時資訊',
            icon: Icons.info_outline,
            trailing: const Text(
              '查看更多',
              style: TextStyle(
                color: TPColors.primary700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _crowdCard(),
          const SizedBox(height: 12),
          _shortestWaitCard(),
          const SizedBox(height: 20),
          _sectionHeader(
            title: '常見問題',
            icon: Icons.help_outline,
            trailing: _tealLink(
              label: '查看完整 FAQ',
              onTap: () => Get.toNamed(TPRoute.childrenParkFaq),
            ),
          ),
          const SizedBox(height: 8),
          ...ChildrenParkFaqData.homePreviewItems.map(_faqPreviewTile),
          const SizedBox(height: 20),
          _sectionHeader(
            title: '活動訊息',
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 268,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _activityCards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, index) => _activityCard(_activityCards[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerSection() {
    final item = _bannerItems[_activeBanner];
    return SizedBox(
      height: 176,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: TPColors.grayscale700),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x26000000), Color(0xB3000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: TPColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: Color(0xE6FFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _roundButton(
                icon: Icons.chevron_left,
                onTap: () => setState(() {
                  _activeBanner = (_activeBanner - 1 + _bannerItems.length) %
                      _bannerItems.length;
                }),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _roundButton(
                icon: Icons.chevron_right,
                onTap: () => setState(() {
                  _activeBanner = (_activeBanner + 1) % _bannerItems.length;
                }),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerItems.length,
                (index) => GestureDetector(
                  onTap: () => setState(() => _activeBanner = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _activeBanner == index ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _activeBanner == index
                          ? TPColors.white
                          : TPColors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _transportSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: TPColors.grayscale100),
          bottom: BorderSide(color: TPColors.grayscale100),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.place_outlined,
                size: 16, color: TPColors.primary700),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '兒童新樂園',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: TPColors.grayscale900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '台北市士林區承德路五段 55 號（近劍潭／士林站）',
                  style: TextStyle(
                    fontSize: 14,
                    color: TPColors.grayscale700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () =>
                      Get.toNamed(TPRoute.childrenParkTransport),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TPColors.primary700,
                    side: const BorderSide(color: TPColors.primary700),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon(Icons.navigation_outlined, size: 14),
                  label: const Text('從目前位置導航'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crowdCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TPColors.grayscale100),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '今日入園狀態',
                  style: TextStyle(fontSize: 12, color: TPColors.grayscale500),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '舒適',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: TPColors.primary700,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        '預估 3,500 人',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: TPColors.grayscale500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F3FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(Icons.people_alt_outlined,
                color: TPColors.primary700),
          ),
        ],
      ),
    );
  }

  Widget _shortestWaitCard() {
    return Container(
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TPColors.grayscale100),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFE6F3FF),
              border: Border(
                bottom: BorderSide(color: TPColors.grayscale100),
              ),
            ),
            child: const Text(
              '最短排隊設施',
              style: TextStyle(
                color: TPColors.primary700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          ..._shortestWaits.map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: TPColors.grayscale100),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: TPColors.primary700,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: TPColors.grayscale900,
                      ),
                    ),
                  ),
                  Text(
                    item.time,
                    style: const TextStyle(
                      color: TPColors.primary700,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _faqPreviewTile(ChildrenParkFaqItem faq) {
    final expanded = _expandedFaqIds.contains(faq.id);
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: TPColors.grayscale200),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (expanded) {
                  _expandedFaqIds.remove(faq.id);
                } else {
                  _expandedFaqIds.add(faq.id);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: TPColors.primary700,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            faq.category,
                            style: const TextStyle(
                              fontSize: 10,
                              color: TPColors.primary700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          faq.question,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: TPColors.grayscale900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: TPColors.grayscale500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: TPColors.grayscale100),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: faq.answers
                    .take(2)
                    .map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          line,
                          style: const TextStyle(
                            fontSize: 14,
                            color: TPColors.grayscale600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _activityCard(_HomeActivityCard activity) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.86,
      decoration: BoxDecoration(
        color: TPColors.white,
        border: Border.all(color: TPColors.grayscale100),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 176,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  activity.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: TPColors.grayscale700),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x33000000), Color(0xA6000000)],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: TPColors.white.withValues(alpha: 0.9),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 12, color: TPColors.primary700),
                        const SizedBox(width: 4),
                        Text(
                          activity.date,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: TPColors.grayscale700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: TPColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    activity.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: TPColors.grayscale600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => Get.toNamed(TPRoute.childrenParkEvents),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TPColors.primary700,
                    side: const BorderSide(color: TPColors.primary700),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('立即查看'),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required IconData icon,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: TPColors.grayscale900,
          ),
        ),
        const SizedBox(width: 4),
        Icon(icon, size: 16, color: TPColors.primary700),
        const Spacer(),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _tealLink({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: TPColors.primary700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.arrow_forward, size: 16, color: TPColors.primary700),
        ],
      ),
    );
  }

  Widget _roundButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: TPColors.white, size: 18),
      ),
    );
  }
}

class _BannerItem {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _BannerItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}

class _HomeActivityCard {
  final String imageUrl;
  final String title;
  final String description;
  final String date;

  const _HomeActivityCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.date,
  });
}
