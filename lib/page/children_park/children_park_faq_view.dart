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
  String _selectedCategory = '全部';
  final Set<String> _expandedIds = {'faq-01'};

  static const List<_FaqItem> _faqItems = [
    _FaqItem(
      id: 'faq-01',
      category: '聯絡與營運',
      question: '如何與兒童新樂園聯絡？',
      answers: [
        '服務專線：02-2833-3823 轉 105 或 106。',
        '24 小時客服專線：02-2536-3001 轉 9。'
      ],
    ),
    _FaqItem(
      id: 'faq-02',
      category: '聯絡與營運',
      question: '兒童新樂園是全年無休嗎？',
      answers: [
        '週二至週五營運時間為 09:00-17:00。',
        '週一（例行保養）與農曆除夕休園；若週一遇寒暑假或連假則照常營運。',
        '週末與連假收假日延長至 18:00，寒暑假與多數連假可延長至 20:00。',
      ],
    ),
    _FaqItem(
      id: 'faq-03',
      category: '交通與入園',
      question: '如何抵達兒童新樂園？',
      answers: [
        '可搭捷運到劍潭站、士林站或芝山站，再轉乘公車（紅 30、兒樂 1/2 號線等）。',
        '可使用 YouBike，或由劍潭、士林站步行前往。',
        '開車可由國道一號或國道三號銜接承德路、基河路。',
      ],
    ),
    _FaqItem(
      id: 'faq-04',
      category: '交通與入園',
      question: '園區有自行車專用停車場嗎？',
      answers: ['園區周邊有 2 處自行車停車場，分別約 64 格與 76 格。'],
    ),
    _FaqItem(
      id: 'faq-05',
      category: '設施與安全',
      question: '寵物可以入園嗎？',
      answers: [
        '寵物不得落地，需置於寵物箱/推車內且包裝完整，每位購票遊客限攜帶 1 件。',
        '導盲犬、導聾犬、肢體輔助犬不受一般限制。',
      ],
    ),
    _FaqItem(
      id: 'faq-06',
      category: '票務與支付',
      question: '可以使用悠遊卡入園嗎？',
      answers: ['可以。悠遊卡可用於驗票入園、搭乘設施與部分商店消費。'],
    ),
    _FaqItem(
      id: 'faq-07',
      category: '票務與支付',
      question: '購票可以刷卡或用其他支付方式嗎？',
      answers: [
        '可使用信用卡（VISA/Mastercard/JCB）、NFC 感應支付、電子票證與多種電子支付。',
        '支援 LINE Pay、悠遊付、街口、全支付等。',
      ],
    ),
    _FaqItem(
      id: 'faq-08',
      category: '票務與支付',
      question: '一張悠遊卡可以多人共用嗎？',
      answers: ['可共用。入園需同身分票別；搭乘設施扣款時依人數與次數計費。'],
    ),
    _FaqItem(
      id: 'faq-09',
      category: '票務與支付',
      question: '有提供團體預約購票與導覽嗎？',
      answers: ['30 人（含）以上團體可於官網申請團體預約與導覽。'],
    ),
    _FaqItem(
      id: 'faq-10',
      category: '票務與支付',
      question: '是「一票玩到底」嗎？',
      answers: ['不是。採門票入園、設施逐項收費。'],
    ),
    _FaqItem(
      id: 'faq-11',
      category: '設施與安全',
      question: '搭乘設施有年齡、身高或其他限制嗎？',
      answers: ['有。各設施依安全規範訂有身高與身體狀況限制。'],
    ),
    _FaqItem(
      id: 'faq-12',
      category: '票務與支付',
      question: '身高 85 公分以下幼童搭乘設施要收費嗎？',
      answers: [
        '部分可搭乘設施可免費，需在親友陪同下搭乘。',
        '身高超過 85 公分但未滿 2 歲者，出示證明文件後亦可免費。',
      ],
    ),
    _FaqItem(
      id: 'faq-13',
      category: '設施與安全',
      question: '孕婦可以搭乘遊樂設施嗎？',
      answers: ['海洋總動員可由孕婦自行評估後搭乘，其餘多數設施不提供搭乘。'],
    ),
    _FaqItem(
      id: 'faq-14',
      category: '設施與安全',
      question: '有行動不便人士優先搭乘設施的機制嗎？',
      answers: ['目前設施搭乘以排隊順序為主，未規劃不同排隊動線。'],
    ),
    _FaqItem(
      id: 'faq-15',
      category: '園區服務',
      question: '園區有哪些無障礙服務？',
      answers: [
        '提供快速入園通道與驗票協助。',
        '提供輪椅/娃娃車借用、無障礙廁所、電梯與部分設施輪椅支援。',
      ],
    ),
    _FaqItem(
      id: 'faq-16',
      category: '園區服務',
      question: '園區有提供餐飲服務嗎？',
      answers: ['有。園區內有美食街、速食餐廳與便利商店。'],
    ),
    _FaqItem(
      id: 'faq-17',
      category: '園區服務',
      question: '有提供素食嗎？',
      answers: ['有，提供素食的店家前方會有標示。'],
    ),
    _FaqItem(
      id: 'faq-18',
      category: '園區服務',
      question: '沒有訂餐可以使用販賣店周邊座位嗎？',
      answers: ['可以使用，但座位有限，請避免長時間佔用。'],
    ),
    _FaqItem(
      id: 'faq-19',
      category: '園區服務',
      question: '有提供輪椅與娃娃車出借嗎？',
      answers: ['可憑身分證明文件至 1 樓遊客服務中心填表借用。'],
    ),
    _FaqItem(
      id: 'faq-20',
      category: '園區服務',
      question: '有提供手機充電服務嗎？',
      answers: ['遊客服務中心提供充電插座，需自備充電設備。'],
    ),
    _FaqItem(
      id: 'faq-21',
      category: '園區服務',
      question: '園區有哺集乳室嗎？',
      answers: ['遊客服務中心旁設有 4 間哺集乳室，並可協助母乳冷藏。'],
    ),
    _FaqItem(
      id: 'faq-22',
      category: '園區服務',
      question: '在園區拾獲物品怎麼辦？',
      answers: ['可交由遊客服務中心處理，或送交警察機關公告招領。'],
    ),
    _FaqItem(
      id: 'faq-23',
      category: '園區服務',
      question: '園區有遺失物協尋服務嗎？',
      answers: ['有。可於營運時間至服務中心認領；官網提供 16 天遺失物資料查詢。'],
    ),
    _FaqItem(
      id: 'faq-24',
      category: '園區服務',
      question: '園區有飲用水服務嗎？',
      answers: ['各樓層有冰溫飲水機；熱水可至遊客服務中心、哺集乳室或救護站裝取。'],
    ),
    _FaqItem(
      id: 'faq-25',
      category: '園區服務',
      question: '園區有置物櫃嗎？位置在哪？',
      answers: [
        '置物櫃位於 1 樓歡樂市集旁通廊，採每小時計費。',
        '小櫃 10 元/時，大櫃 20 元/時。',
      ],
    ),
    _FaqItem(
      id: 'faq-26',
      category: '園區服務',
      question: '園區哪裡有提款機？',
      answers: ['位於 1 樓遊客服務中心旁與 2 樓便利商店內。'],
    ),
    _FaqItem(
      id: 'faq-27',
      category: '設施與安全',
      question: '銀河號與幸福碰碰車為何預約後不會立即扣款入場？',
      answers: ['採 10 分鐘分場次運轉，現場會依報到與排隊狀況補位。'],
    ),
    _FaqItem(
      id: 'faq-28',
      category: '交通與入園',
      question: '離園後可以再入園嗎？',
      answers: ['可於當日營業時間內，憑再入園手章進出園區。'],
    ),
    _FaqItem(
      id: 'faq-29',
      category: '設施與安全',
      question: '園區全面禁菸嗎？',
      answers: ['是，園區內全面禁菸。'],
    ),
    _FaqItem(
      id: 'faq-30',
      category: '票務與支付',
      question: '原兒育中心的券或代幣還能使用嗎？',
      answers: ['舊兒育中心紙票不可直接使用，可至售票處或服務中心辦理加值或兌現。'],
    ),
    _FaqItem(
      id: 'faq-31',
      category: '票務與支付',
      question: '園區多元支付適用方式有哪些？',
      answers: ['包含信用卡、NFC 感應支付、電子票證、電子支付與敬老點數等方式。'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = [
      '全部',
      ...{..._faqItems.map((e) => e.category)}
    ];
    final filtered = _faqItems.where((item) {
      final categoryMatched =
          _selectedCategory == '全部' || item.category == _selectedCategory;
      final textMatched = _query.isEmpty ||
          item.category.contains(_query) ||
          item.question.contains(_query) ||
          item.answers.any((line) => line.contains(_query));
      return categoryMatched && textMatched;
    }).toList();

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
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) {
                final category = categories[index];
                final selected = category == _selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemCount: categories.length,
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
                key: ValueKey(item.id),
                initiallyExpanded: _expandedIds.contains(item.id),
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      _expandedIds.add(item.id);
                    } else {
                      _expandedIds.remove(item.id);
                    }
                  });
                },
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                title: Text(item.question),
                subtitle: Text(item.category),
                children: [
                  ...item.answers.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          line,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
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
  final String id;
  final String category;
  final String question;
  final List<String> answers;

  const _FaqItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answers,
  });
}
