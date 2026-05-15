import 'package:town_pass/page/children_park/map/children_park_map_models.dart';

String normalizePlaceName(String name) {
  return name
      .replaceAll(RegExp(r'\s+'), '')
      .replaceAll(RegExp(r'[()（）]'), '')
      .toLowerCase();
}

String getPointLabel(ChildrenParkMapPointType pointType) {
  return pointType == ChildrenParkMapPointType.facility ? '設施' : '餐飲';
}

ChildrenParkMapContentType getPointContentType(ChildrenParkMapPoint point) {
  if (point.pointType == ChildrenParkMapPointType.facility) {
    return ChildrenParkMapContentType.facility;
  }
  final text = '${point.name}${point.category}'.toLowerCase();
  if (text.contains('商店') ||
      text.contains('超商') ||
      text.contains('拍貼') ||
      text.contains('化石')) {
    return ChildrenParkMapContentType.shop;
  }
  if (text.contains('餐') || text.contains('食')) {
    return ChildrenParkMapContentType.restaurant;
  }
  return ChildrenParkMapContentType.restaurant;
}

bool isRidePoint(ChildrenParkMapPoint point) {
  return point.pointType == ChildrenParkMapPointType.facility &&
      const {'大型遊樂設施', 'K系列', 'A系列'}.contains(point.category);
}

List<String> getRecommendedHeightFilters(String childHeight) {
  final height = double.tryParse(childHeight.trim());
  if (height == null || height <= 0) return [];
  if (height < 90) return ['幼童友善'];
  if (height < 110) return ['幼童友善', '小學門檻'];
  return ['幼童友善', '小學門檻', '刺激挑戰'];
}

bool matchesTextFilter(String? value, List<String> filters) {
  if (filters.isEmpty) return true;
  if (value == null || value.isEmpty) return false;
  return filters.any(
    (filter) =>
        value.contains(filter) ||
        (filter.contains('幼童友善') && value.contains('幼童友善')) ||
        (filter.contains('小學門檻') && value.contains('小學門檻')) ||
        (filter.contains('刺激挑戰') && value.contains('刺激挑戰')),
  );
}

bool matchesListFilter(List<String>? values, List<String> filters) {
  if (filters.isEmpty) return true;
  if (values == null || values.isEmpty) return false;
  return values.any(
    (value) => filters.any((filter) => value.contains(filter)),
  );
}

const _facilityWaitSamples = [15, 25, 35, 45, 5];

int getFacilityWaitMinutes(ChildrenParkMapPoint point) {
  final hash = point.id.codeUnits.fold<int>(0, (sum, code) => sum + code);
  return _facilityWaitSamples[hash % _facilityWaitSamples.length];
}
