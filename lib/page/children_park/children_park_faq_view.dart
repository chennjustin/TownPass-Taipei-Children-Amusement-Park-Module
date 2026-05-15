import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkFaqView extends StatefulWidget {
  const ChildrenParkFaqView({super.key});

  @override
  State<ChildrenParkFaqView> createState() => _ChildrenParkFaqViewState();
}

class _ChildrenParkFaqViewState extends State<ChildrenParkFaqView> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';

  static const List<_FaqItem> _faqItems = [
    _FaqItem(
      category: '票務',
      question: '兒童新樂園要怎麼購票？',
      answer: '可現場購票，或使用台北通／合作平台先購票，入園再依設施計次或套票使用。',
    ),
    _FaqItem(
      category: '營業時間',
      question: '營業時間是幾點到幾點？',
      answer: '一般為 09:00-21:00，實際時間會依季節、活動與天候調整。',
    ),
    _FaqItem(
      category: '交通',
      question: '最方便的大眾運輸方式是什麼？',
      answer: '建議搭捷運到劍潭站或士林站，再轉乘公車至兒童新樂園站。',
    ),
    _FaqItem(
      category: '設施',
      question: '可以先查排隊時間嗎？',
      answer: '可以，請到設施或地圖頁查看目前等待時間與熱門設施推薦。',
    ),
    _FaqItem(
      category: '安全',
      question: '設施有身高限制嗎？',
      answer: '每個設施限制不同，請在設施詳情頁或現場告示確認。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _faqItems
        .where(
          (item) =>
              _query.isEmpty ||
              item.category.contains(_query) ||
              item.question.contains(_query) ||
              item.answer.contains(_query),
        )
        .toList();

    return ChildrenParkShell(
      title: 'FAQ',
      currentRoute: TPRoute.childrenParkFaq,
      showBottomNavigation: false,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          TextButton.icon(
            onPressed: () => Get.offNamed(TPRoute.childrenParkHome),
            icon: const Icon(Icons.arrow_back_ios_new, size: 16),
            label: const Text('回首頁'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _queryController,
            onChanged: (value) => setState(() => _query = value.trim()),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '搜尋關鍵字',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '共 ${filtered.length} 筆結果',
            style: const TextStyle(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 12),
          ...filtered.map(
            (item) => Card(
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                title: Text(item.question),
                subtitle: Text(item.category),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.answer,
                      style: const TextStyle(height: 1.5),
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
}

class _FaqItem {
  final String category;
  final String question;
  final String answer;

  const _FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}
