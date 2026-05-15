import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/map/children_park_map_constants.dart';
import 'package:town_pass/page/children_park/map/children_park_map_data.dart';
import 'package:town_pass/page/children_park/map/children_park_map_helpers.dart';
import 'package:town_pass/page/children_park/map/children_park_map_models.dart';
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
  bool _loading = true;
  bool _filterPanelOpen = false;
  List<_FacilityListItem> _allItems = [];
  String _query = '';
  String _sort = '';
  String _height = '';
  String _thrill = '';
  String _environment = '';
  String _price = '';
  String _special = '';

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  Future<void> _loadFacilities() async {
    try {
      final points = await ChildrenParkMapData.loadAllPoints();
      final details = await ChildrenParkMapData.loadPlaceDetails();
      final detailMap = <String, ChildrenParkPlaceDetail>{};
      for (final detail in details) {
        detailMap[normalizePlaceName(detail.name)] = detail;
        for (final alias in detail.aliases) {
          detailMap[normalizePlaceName(alias)] = detail;
        }
      }

      final facilityItems = points
          .where((point) =>
              getPointContentType(point) == ChildrenParkMapContentType.facility)
          .where(isRidePoint)
          .map((point) {
        final detail = detailMap[normalizePlaceName(point.name)];
        final waitMinutes = getFacilityWaitMinutes(point);
        return _FacilityListItem(
          point: point,
          detail: detail,
          waitMinutes: waitMinutes,
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        _allItems = facilityItems;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final attractions = _filteredAttractions();
    final hasActiveFilters = _query.isNotEmpty ||
        _sort.isNotEmpty ||
        _height.isNotEmpty ||
        _thrill.isNotEmpty ||
        _environment.isNotEmpty ||
        _price.isNotEmpty ||
        _special.isNotEmpty;

    return ChildrenParkShell(
      title: '設施資訊',
      currentRoute: TPRoute.childrenParkFacilities,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: TPColors.primary700),
            )
          : Column(
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
                                  borderSide: const BorderSide(
                                      color: TPColors.grayscale100),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: TPColors.grayscale100),
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
                              _filterPicker(
                                label: '等待時間',
                                value: _sort,
                                displayText: (value) => switch (value) {
                                  '' => '等待時間',
                                  'asc' => '最短',
                                  'desc' => '最長',
                                  _ => value,
                                },
                                onTap: () => _pickFilterOption(
                                  label: '等待時間',
                                  currentValue: _sort,
                                  options: const ['', 'asc', 'desc'],
                                  displayText: (value) => switch (value) {
                                    '' => '等待時間',
                                    'asc' => '等待時間（最短）',
                                    'desc' => '等待時間（最長）',
                                    _ => value,
                                  },
                                  onChanged: (value) =>
                                      setState(() => _sort = value),
                                ),
                              ),
                              _filterPicker(
                                label: '身高限制',
                                value: _height,
                                onTap: () => _pickFilterOption(
                                  label: '身高限制',
                                  currentValue: _height,
                                  options: const [
                                    '',
                                    ...ChildrenParkMapConstants.heightFilterOptions,
                                  ],
                                  onChanged: (value) =>
                                      setState(() => _height = value),
                                ),
                              ),
                              _filterPicker(
                                label: '尖叫指數',
                                value: _thrill,
                                onTap: () => _pickFilterOption(
                                  label: '尖叫指數',
                                  currentValue: _thrill,
                                  options: const [
                                    '',
                                    ...ChildrenParkMapConstants.thrillFilterOptions,
                                  ],
                                  onChanged: (value) =>
                                      setState(() => _thrill = value),
                                ),
                              ),
                              _filterPicker(
                                label: '室內外',
                                value: _environment,
                                onTap: () => _pickFilterOption(
                                  label: '室內外',
                                  currentValue: _environment,
                                  options: const [
                                    '',
                                    ...ChildrenParkMapConstants.environmentFilterOptions,
                                  ],
                                  onChanged: (value) =>
                                      setState(() => _environment = value),
                                ),
                              ),
                              _filterPicker(
                                label: '票價/類型',
                                value: _price,
                                onTap: () => _pickFilterOption(
                                  label: '票價/類型',
                                  currentValue: _price,
                                  options: const [
                                    '',
                                    ...ChildrenParkMapConstants.priceFilterOptions,
                                  ],
                                  onChanged: (value) =>
                                      setState(() => _price = value),
                                ),
                              ),
                              _filterPicker(
                                label: '特殊族群',
                                value: _special,
                                onTap: () => _pickFilterOption(
                                  label: '特殊族群',
                                  currentValue: _special,
                                  options: const [
                                    '',
                                    ...ChildrenParkMapConstants.specialFilterOptions,
                                  ],
                                  onChanged: (value) =>
                                      setState(() => _special = value),
                                ),
                              ),
                              const SizedBox(width: 6),
                              OutlinedButton(
                                onPressed: hasActiveFilters
                                    ? () {
                                        setState(() {
                                          _query = '';
                                          _searchController.clear();
                                          _sort = '';
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
                                  side: const BorderSide(
                                      color: TPColors.grayscale100),
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
                    itemBuilder: (_, index) =>
                        _facilityCard(attractions[index]),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: attractions.length,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _filterPicker({
    required String label,
    required String value,
    required VoidCallback onTap,
    String Function(String value)? displayText,
  }) {
    final isActive = value.isNotEmpty;
    final selectedTextColor =
        isActive ? TPColors.white : TPColors.grayscale700;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      constraints: const BoxConstraints(minWidth: 92, maxWidth: 132),
      child: Material(
        color: isActive ? TPColors.primary700 : TPColors.white,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isActive ? TPColors.primary700 : TPColors.grayscale100,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText?.call(value) ?? (value.isEmpty ? label : value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selectedTextColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.expand_more,
                  size: 18,
                  color: selectedTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFilterOption({
    required String label,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onChanged,
    String Function(String value)? displayText,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: TPColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: TPColors.grayscale900,
                      ),
                    ),
                  ],
                ),
              ),
              ...options.map((option) {
                final optionText =
                    displayText?.call(option) ?? (option.isEmpty ? label : option);
                return RadioListTile<String>(
                  value: option,
                  groupValue: currentValue,
                  title: Text(optionText),
                  onChanged: (value) => Navigator.of(sheetContext).pop(value),
                  activeColor: TPColors.primary700,
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      onChanged(selected);
    }
  }

  Widget _facilityCard(_FacilityListItem item) {
    final point = item.point;
    final detail = item.detail;
    final waitLabel = '${item.waitMinutes} 分鐘';
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
                child: _facilityImage(point.name),
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
                  child: const Icon(
                    Icons.rocket_launch_outlined,
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
                          point.name,
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
                      _tag(
                          detail?.category.isNotEmpty == true
                              ? detail!.category
                              : '大型遊樂設施',
                          bg: const Color(0xFFE6F3FF),
                          fg: TPColors.primary700),
                      _tag('身高限制 ${detail?.filters?.height ?? '未限制'}',
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
                          '${point.floor ?? 3} 樓 · ${_distanceText(point)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: TPColors.grayscale700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(
                          TPRoute.childrenParkMap,
                          arguments: {
                            'focusPointId': point.id,
                            'openDetail': true,
                          },
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: TPColors.primary700,
                          minimumSize: const Size(40, 26),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '查看位置',
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

  Widget _facilityImage(String name) {
    final imageUrl = _imageByName[name];
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        width: 118,
        height: 148,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(),
      );
    }
    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return Container(
      width: 118,
      height: 148,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB9E8F8), Color(0xFF7DBFD7)],
        ),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.attractions_outlined,
        color: Colors.white,
        size: 34,
      ),
    );
  }

  String _distanceText(ChildrenParkMapPoint point) {
    final hash = point.id.codeUnits.fold<int>(0, (sum, code) => sum + code);
    return '${90 + (hash % 90)}m';
  }

  List<_FacilityListItem> _filteredAttractions() {
    Iterable<_FacilityListItem> list = _allItems.where((item) {
      if (_query.isEmpty) {
        return true;
      }
      return item.point.name.contains(_query) ||
          (item.detail?.category.contains(_query) ?? false) ||
          (item.detail?.description.contains(_query) ?? false);
    });

    if (_height.isNotEmpty ||
        _thrill.isNotEmpty ||
        _environment.isNotEmpty ||
        _price.isNotEmpty ||
        _special.isNotEmpty) {
      list = list.where((item) {
        final filters = item.detail?.filters;
        final combinedSpecial = [
          ...?filters?.special,
          ...?filters?.environment
        ];
        if (!matchesTextFilter(
          filters?.height,
          _height.isEmpty ? const [] : [_height],
        )) {
          return false;
        }
        if (!matchesTextFilter(
          filters?.thrill,
          _thrill.isEmpty ? const [] : [_thrill],
        )) {
          return false;
        }
        if (!matchesListFilter(
          filters?.environment,
          _environment.isEmpty ? const [] : [_environment],
        )) {
          return false;
        }
        if (!matchesTextFilter(
          filters?.price,
          _price.isEmpty ? const [] : [_price],
        )) {
          return false;
        }
        if (!matchesListFilter(
          combinedSpecial,
          _special.isEmpty ? const [] : [_special],
        )) {
          return false;
        }
        return true;
      });
    }

    if (_sort == 'asc') {
      list = list.toList()
        ..sort((a, b) => a.waitMinutes.compareTo(b.waitMinutes));
    } else if (_sort == 'desc') {
      list = list.toList()
        ..sort((a, b) => b.waitMinutes.compareTo(a.waitMinutes));
    }

    return list.toList();
  }
}

class _FacilityListItem {
  final ChildrenParkMapPoint point;
  final ChildrenParkPlaceDetail? detail;
  final int waitMinutes;

  const _FacilityListItem({
    required this.point,
    required this.detail,
    required this.waitMinutes,
  });
}

const Map<String, String> _imageByName = {
  'K2鋼鐵碰碰車': 'https://images.unsplash.com/photo-1519340241574-2cec6aef0c01',
  '幸福碰碰車': 'https://images.unsplash.com/photo-1548950936-904e6f7dc365',
  '巡弋飛椅': 'https://images.unsplash.com/photo-1533142266415-ac591a4deae9',
  '轉轉咖啡杯': 'https://images.unsplash.com/photo-1519999482648-25049ddd37b1',
  'A2戰火金剛': 'https://images.unsplash.com/photo-1464037866556-6812c9d1c72e',
  'A10迷你卡丁車': 'https://images.unsplash.com/photo-1516627145497-ae6968895b74',
  '摩天輪': 'https://images.unsplash.com/photo-1533142266415-ac591a4deae9',
  'K1冰雪奇航': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac',
};
