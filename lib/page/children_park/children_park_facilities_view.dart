import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/mock/children_park_mock_data.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkFacilitiesView extends StatefulWidget {
  const ChildrenParkFacilitiesView({super.key});

  @override
  State<ChildrenParkFacilitiesView> createState() =>
      _ChildrenParkFacilitiesViewState();
}

class _ChildrenParkFacilitiesViewState
    extends State<ChildrenParkFacilitiesView> {
  final TextEditingController _searchController = TextEditingController();
  bool _filterPanelOpen = false;

  String _query = '';
  String _sort = 'none';
  String _height = '';
  String _thrill = '';
  String _environment = '';
  String _price = '';
  String _special = '';

  static const List<String> _heightOptions = [
    '',
    '無限制',
    '110cm',
    '120cm',
    '140cm'
  ];
  static const List<String> _thrillOptions = ['', '親子友善', '中等刺激', '刺激挑戰'];
  static const List<String> _environmentOptions = ['', '室內', '戶外'];
  static const List<String> _priceOptions = ['', '免費', '20元', '30元'];
  static const List<String> _specialOptions = ['', '幼童友善', '雨天可玩', '快速通行'];

  @override
  Widget build(BuildContext context) {
    final attractions = _filteredAttractions();
    final hasActiveFilters = _query.isNotEmpty ||
        _sort != 'none' ||
        _height.isNotEmpty ||
        _thrill.isNotEmpty ||
        _environment.isNotEmpty ||
        _price.isNotEmpty ||
        _special.isNotEmpty;

    return ChildrenParkShell(
      title: '設施資訊',
      currentRoute: TPRoute.childrenParkFacilities,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            decoration: const BoxDecoration(
              color: TPColors.white,
              border: Border(
                bottom: BorderSide(color: TPColors.grayscale100),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _query = value.trim()),
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.search, size: 20),
                          hintText: '搜尋設施或表演...',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: TPColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: TPColors.grayscale100),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: TPColors.grayscale100),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _filterPanelOpen || hasActiveFilters
                            ? TPColors.primary700
                            : TPColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _filterPanelOpen || hasActiveFilters
                              ? TPColors.primary700
                              : TPColors.grayscale100,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _filterPanelOpen = !_filterPanelOpen;
                          });
                        },
                        icon: Icon(
                          Icons.tune,
                          color: _filterPanelOpen || hasActiveFilters
                              ? TPColors.white
                              : TPColors.primary700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_filterPanelOpen) ...[
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterDropdown(
                          label: '等待時間',
                          value: _sort,
                          options: const ['', 'none', 'asc', 'desc'],
                          displayText: (value) => switch (value) {
                            '' || 'none' => '等待時間',
                            'asc' => '等待時間（最短）',
                            'desc' => '等待時間（最長）',
                            _ => value,
                          },
                          onChanged: (value) => setState(() => _sort = value),
                        ),
                        _filterDropdown(
                          label: '身高限制',
                          value: _height,
                          options: _heightOptions,
                          onChanged: (value) => setState(() => _height = value),
                        ),
                        _filterDropdown(
                          label: '尖叫指數',
                          value: _thrill,
                          options: _thrillOptions,
                          onChanged: (value) => setState(() => _thrill = value),
                        ),
                        _filterDropdown(
                          label: '室內外',
                          value: _environment,
                          options: _environmentOptions,
                          onChanged: (value) =>
                              setState(() => _environment = value),
                        ),
                        _filterDropdown(
                          label: '票價/類型',
                          value: _price,
                          options: _priceOptions,
                          onChanged: (value) => setState(() => _price = value),
                        ),
                        _filterDropdown(
                          label: '特殊族群',
                          value: _special,
                          options: _specialOptions,
                          onChanged: (value) =>
                              setState(() => _special = value),
                        ),
                        const SizedBox(width: 6),
                        OutlinedButton(
                          onPressed: hasActiveFilters
                              ? () {
                                  setState(() {
                                    _query = '';
                                    _searchController.clear();
                                    _sort = 'none';
                                    _height = '';
                                    _thrill = '';
                                    _environment = '';
                                    _price = '';
                                    _special = '';
                                  });
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(86, 40),
                            side:
                                const BorderSide(color: TPColors.grayscale100),
                          ),
                          child: const Text('清除篩選'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              itemBuilder: (_, index) => _facilityCard(attractions[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: attractions.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
    String Function(String value)? displayText,
  }) {
    final isActive = value.isNotEmpty && value != 'none';
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isActive ? TPColors.primary700 : TPColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? TPColors.primary700 : TPColors.grayscale100,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.expand_more,
            size: 18,
            color: isActive ? TPColors.white : TPColors.grayscale700,
          ),
          style: TextStyle(
            color: isActive ? TPColors.white : TPColors.grayscale700,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: TPColors.white,
          onChanged: (selected) {
            if (selected != null) {
              onChanged(selected);
            }
          },
          items: options
              .map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(displayText?.call(option) ??
                      (option.isEmpty ? label : option)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _facilityCard(ParkAttraction attraction) {
    final waitLabel = attraction.waitMinutes == null
        ? attraction.status
        : '${attraction.waitMinutes} 分鐘';
    return Container(
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TPColors.grayscale100),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(11)),
                child: Image.network(
                  attraction.imageUrl,
                  width: 118,
                  height: 148,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 118,
                    height: 148,
                    color: TPColors.grayscale100,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: TPColors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: TPColors.grayscale100),
                  ),
                  child: Icon(
                    _iconByCategory(attraction.category),
                    size: 14,
                    color: TPColors.primary700,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          attraction.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: TPColors.grayscale900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            waitLabel,
                            style: const TextStyle(
                              color: TPColors.primary700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            '預估排隊',
                            style: TextStyle(
                              fontSize: 10,
                              color: TPColors.grayscale700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _tag(_categoryText(attraction.category),
                          bg: const Color(0xFFE6F3FF), fg: TPColors.primary700),
                      _tag('身高限制 ${_restrictionText(attraction)}',
                          bg: const Color(0xFFF3F4F6),
                          fg: TPColors.grayscale700),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined,
                          size: 14, color: TPColors.grayscale700),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${_areaText(attraction)} · ${_distanceText(attraction)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: TPColors.grayscale700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: TPColors.primary700,
                          minimumSize: const Size(40, 26),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '查看詳情',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, {required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  IconData _iconByCategory(ParkCategory category) {
    return switch (category) {
      ParkCategory.attraction => Icons.rocket_launch_outlined,
      ParkCategory.food => Icons.restaurant_outlined,
      ParkCategory.souvenir => Icons.shopping_bag_outlined,
      ParkCategory.restroom => Icons.wc_outlined,
      ParkCategory.family => Icons.child_care_outlined,
      ParkCategory.transport => Icons.support_agent_outlined,
      ParkCategory.show => Icons.theaters_outlined,
    };
  }

  String _categoryText(ParkCategory category) {
    return switch (category) {
      ParkCategory.attraction => '遊樂設施',
      ParkCategory.food => '美食餐飲',
      ParkCategory.souvenir => '紀念品店',
      ParkCategory.restroom => '廁所',
      ParkCategory.family => '親子服務',
      ParkCategory.transport => '交通服務',
      ParkCategory.show => '表演活動',
    };
  }

  String _restrictionText(ParkAttraction attraction) {
    if (attraction.waitMinutes != null && attraction.waitMinutes! > 40) {
      return '120cm';
    }
    if (attraction.waitMinutes != null && attraction.waitMinutes! > 20) {
      return '110cm';
    }
    return '無限制';
  }

  String _areaText(ParkAttraction attraction) {
    return attraction.category == ParkCategory.show ? '表演區' : '園區設施';
  }

  String _distanceText(ParkAttraction attraction) {
    return attraction.distanceText.replaceAll('距離 ', '');
  }

  List<ParkAttraction> _filteredAttractions() {
    Iterable<ParkAttraction> list =
        ChildrenParkMockData.attractions.where((item) {
      if (_query.isEmpty) {
        return true;
      }
      return item.name.contains(_query) ||
          item.status.contains(_query) ||
          item.description.contains(_query);
    });

    if (_sort == 'asc') {
      list = list.toList()
        ..sort(
            (a, b) => (a.waitMinutes ?? 999).compareTo(b.waitMinutes ?? 999));
    } else if (_sort == 'desc') {
      list = list.toList()
        ..sort((a, b) => (b.waitMinutes ?? -1).compareTo(a.waitMinutes ?? -1));
    }

    return list.toList();
  }
}
