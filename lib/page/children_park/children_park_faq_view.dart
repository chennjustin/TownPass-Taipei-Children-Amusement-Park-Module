import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/data/children_park_faq_data.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/page/children_park/widgets/children_park_sub_page_header.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkFaqView extends StatefulWidget {
  const ChildrenParkFaqView({super.key});

  @override
  State<ChildrenParkFaqView> createState() => _ChildrenParkFaqViewState();
}

class _ChildrenParkFaqViewState extends State<ChildrenParkFaqView> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _categoryScrollController = ScrollController();
  String _query = '';
  String _selectedCategory = '全部';
  final Set<String> _expandedIds = {'faq-01'};

  @override
  void dispose() {
    _queryController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  List<ChildrenParkFaqItem> get _filteredItems {
    final keyword = _query.trim().toLowerCase();
    return ChildrenParkFaqData.items.where((item) {
      final categoryMatched =
          _selectedCategory == '全部' || item.category == _selectedCategory;
      if (!categoryMatched) return false;
      if (keyword.isEmpty) return true;
      final text =
          '${item.question} ${item.answers.join(' ')} ${item.category}'
              .toLowerCase();
      return text.contains(keyword);
    }).toList();
  }

  List<({String category, List<ChildrenParkFaqItem> items})> get _groupedItems {
    final filtered = _filteredItems;
    if (_selectedCategory != '全部') {
      return [(category: _selectedCategory, items: filtered)];
    }

    final groups = <({String category, List<ChildrenParkFaqItem> items})>[];
    for (final category in ChildrenParkFaqData.categories.skip(1)) {
      final items =
          filtered.where((item) => item.category == category).toList();
      if (items.isNotEmpty) {
        groups.add((category: category, items: items));
      }
    }
    return groups;
  }

  void _scrollCategories(double offset) {
    _categoryScrollController.animateTo(
      (_categoryScrollController.offset + offset)
          .clamp(0.0, _categoryScrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedItems;
    final total = ChildrenParkFaqData.items.length;
    final filteredCount = _filteredItems.length;

    return ChildrenParkShell(
      title: '常見問題',
      currentRoute: TPRoute.childrenParkFaq,
      showBottomNavigation: false,
      body: Column(
        children: [
          const ChildrenParkSubPageHeader(title: '常見問題'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TPColors.grayscale100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      size: 18, color: TPColors.grayscale500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      onChanged: (value) =>
                          setState(() => _query = value.trim()),
                      decoration: const InputDecoration(
                        hintText: '搜尋關鍵字',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: TPColors.grayscale400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    '$filteredCount/$total',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0097A7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                ListView(
                  controller: _categoryScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  children: ChildrenParkFaqData.categories.map((category) {
                    final active = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: active
                                  ? const Color(0xFF0097A7)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: active
                                ? const Color(0xFF0097A7)
                                : TPColors.grayscale500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: _categoryScrollButton(
                    label: '<',
                    onTap: () => _scrollCategories(-140),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: _categoryScrollButton(
                    label: '>',
                    onTap: () => _scrollCategories(140),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: TPColors.grayscale100),
          Expanded(
            child: grouped.isEmpty
                ? const Center(
                    child: Text(
                      '找不到符合條件的問題',
                      style: TextStyle(
                        fontSize: 14,
                        color: TPColors.grayscale500,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: grouped.length,
                    itemBuilder: (_, groupIndex) {
                      final group = grouped[groupIndex];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: groupIndex == grouped.length - 1 ? 0 : 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.category,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF007A87),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: TPColors.grayscale100,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: List.generate(
                                  group.items.length,
                                  (index) {
                                    final item = group.items[index];
                                    final expanded =
                                        _expandedIds.contains(item.id);
                                    return Column(
                                      children: [
                                        if (index > 0)
                                          const Divider(
                                            height: 1,
                                            color: TPColors.grayscale100,
                                          ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (expanded) {
                                                _expandedIds.remove(item.id);
                                              } else {
                                                _expandedIds.add(item.id);
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.question,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: TPColors
                                                          .grayscale900,
                                                    ),
                                                  ),
                                                ),
                                                AnimatedRotation(
                                                  turns: expanded ? 0.5 : 0,
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  child: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 20,
                                                    color:
                                                        TPColors.grayscale500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (expanded)
                                          Container(
                                            width: double.infinity,
                                            color: TPColors.grayscale50,
                                            padding: const EdgeInsets.fromLTRB(
                                              12,
                                              0,
                                              12,
                                              12,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: item.answers
                                                  .map(
                                                    (line) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        bottom: 4,
                                                      ),
                                                      child: Text(
                                                        line,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          height: 1.5,
                                                          color: TPColors
                                                              .grayscale700,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _categoryScrollButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: TPColors.white.withValues(alpha: 0.95),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 28,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: TPColors.grayscale500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
