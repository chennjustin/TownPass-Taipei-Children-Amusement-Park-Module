import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/mock/children_park_mock_data.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkHomeView extends StatefulWidget {
  const ChildrenParkHomeView({super.key});

  @override
  State<ChildrenParkHomeView> createState() => _ChildrenParkHomeViewState();
}

class _ChildrenParkHomeViewState extends State<ChildrenParkHomeView> {
  final PageController _bannerController = PageController();
  int _activeBanner = 0;

  static const List<_FaqPreview> _quickFaqs = [
    _FaqPreview(
      category: '票務與支付',
      question: '可以使用悠遊卡入園嗎？',
      answers: ['可以。悠遊卡可用於驗票入園、搭乘設施與部分商店消費。'],
    ),
    _FaqPreview(
      category: '交通與入園',
      question: '如何抵達兒童新樂園？',
      answers: ['可搭捷運到劍潭站、士林站或芝山站，再轉乘公車。'],
    ),
    _FaqPreview(
      category: '設施與安全',
      question: '園區全面禁菸嗎？',
      answers: ['是，園區內全面禁菸。'],
    ),
  ];

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const events = ChildrenParkMockData.events;
    final bannerItems = [
      _BannerItem(
        imageUrl: events[0].imageUrl,
        title: '夏季嘉年華：星光遊行',
        subtitle: '每日 19:00 準時開始',
      ),
      _BannerItem(
        imageUrl: events[3].imageUrl,
        title: '週末煙火秀',
        subtitle: '每週六、日 20:00 登場',
      ),
      _BannerItem(
        imageUrl: ChildrenParkMockData.attractions[6].imageUrl,
        title: '美食街 85 折優惠',
        subtitle: '會員出示 App 即享折扣',
      ),
    ];

    return ChildrenParkShell(
      title: '兒童新樂園',
      currentRoute: TPRoute.childrenParkHome,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        children: [
          SizedBox(
            height: 176,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _bannerController,
                  onPageChanged: (index) =>
                      setState(() => _activeBanner = index),
                  itemCount: bannerItems.length,
                  itemBuilder: (_, index) => _bannerCard(bannerItems[index]),
                ),
                Positioned(
                  left: 6,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _roundButton(
                      icon: Icons.chevron_left,
                      onTap: () {
                        final target =
                            (_activeBanner - 1 + bannerItems.length) %
                                bannerItems.length;
                        _bannerController.animateToPage(
                          target,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: _roundButton(
                      icon: Icons.chevron_right,
                      onTap: () {
                        final target = (_activeBanner + 1) % bannerItems.length;
                        _bannerController.animateToPage(
                          target,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      bannerItems.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _activeBanner == index ? 16 : 6,
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
              ],
            ),
          ),
          const SizedBox(height: 14),
          _sectionHeader(
            title: '交通方式',
            icon: Icons.directions_bus_outlined,
            trailing: TextButton.icon(
              onPressed: () => Get.toNamed(TPRoute.childrenParkTransport),
              icon: const Text('查看更多'),
              label: const Icon(Icons.arrow_forward, size: 16),
            ),
          ),
          _transportCard(),
          const SizedBox(height: 10),
          _sectionHeader(
            title: '即時資訊',
            icon: Icons.info_outline,
            trailing: const Text(
              '查看更多',
              style: TextStyle(
                color: TPColors.primary700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _crowdCard(),
          const SizedBox(height: 8),
          _shortestWaitCard(),
          const SizedBox(height: 14),
          _sectionHeader(
            title: '常見問題',
            icon: Icons.help_outline,
            trailing: TextButton.icon(
              onPressed: () => Get.toNamed(TPRoute.childrenParkFaq),
              icon: const Text('查看完整 FAQ'),
              label: const Icon(Icons.arrow_forward, size: 16),
            ),
          ),
          const SizedBox(height: 8),
          ..._quickFaqs.map((faq) => _faqPreviewTile(faq)),
          const SizedBox(height: 14),
          _sectionHeader(
            title: '活動訊息',
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => _activityCard(events[index]),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: events.length.clamp(0, 3),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(TPRoute.childrenParkEvents),
            icon: const Icon(Icons.event_note_outlined),
            label: const Text('查看全部活動'),
          ),
        ],
      ),
    );
  }

  Widget _bannerCard(_BannerItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: TPColors.grayscale700,
      ),
      clipBehavior: Clip.antiAlias,
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
                colors: [Color(0x20000000), Color(0xB0000000)],
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: TPColors.white,
                    fontWeight: FontWeight.w700,
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
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: TPColors.white, size: 18),
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
            fontSize: 20,
            fontWeight: FontWeight.w700,
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

  Widget _transportCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TPColors.grayscale100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place_outlined, size: 16, color: TPColors.primary700),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '兒童新樂園',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '台北市士林區承德路五段 55 號（近劍潭／士林站）',
                      style: TextStyle(
                        fontSize: 12,
                        color: TPColors.grayscale700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(TPRoute.childrenParkTransport),
            icon: const Icon(Icons.navigation_outlined),
            label: const Text('從目前位置導航'),
          ),
        ],
      ),
    );
  }

  Widget _crowdCard() {
    return Container(
      padding: const EdgeInsets.all(14),
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
                  style: TextStyle(fontSize: 12, color: TPColors.grayscale700),
                ),
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '舒適',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
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
                          color: TPColors.grayscale700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
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
    final list = ChildrenParkMockData.attractions
        .where((a) => a.waitMinutes != null)
        .toList()
      ..sort((a, b) => a.waitMinutes!.compareTo(b.waitMinutes!));
    return Container(
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TPColors.grayscale100),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFE6F3FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: const Row(
              children: [
                Text(
                  '最短排隊設施',
                  style: TextStyle(
                    color: TPColors.primary700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ...list.take(3).map(
                (item) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '${item.waitMinutes} 分鐘',
                        style: const TextStyle(
                          color: TPColors.primary700,
                          fontWeight: FontWeight.w700,
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

  Widget _faqPreviewTile(_FaqPreview faq) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: TPColors.grayscale100),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: TPColors.primary700, width: 2),
                ),
              ),
              child: Text(
                faq.category,
                style: const TextStyle(
                  fontSize: 11,
                  color: TPColors.primary700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              faq.question,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: TPColors.grayscale900,
              ),
            ),
          ],
        ),
        children: faq.answers
            .map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    line,
                    style: const TextStyle(
                      fontSize: 13,
                      color: TPColors.grayscale700,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _activityCard(ParkEvent event) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TPColors.grayscale100),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 160,
                child: Image.network(event.imageUrl, fit: BoxFit.cover),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: TPColors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    event.timeText,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: TPColors.grayscale900,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 13,
                          color: TPColors.grayscale700,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Get.toNamed(TPRoute.childrenParkEvents),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(84, 34),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      child: const Text('立即查看'),
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

class _FaqPreview {
  final String category;
  final String question;
  final List<String> answers;

  const _FaqPreview({
    required this.category,
    required this.question,
    required this.answers,
  });
}
