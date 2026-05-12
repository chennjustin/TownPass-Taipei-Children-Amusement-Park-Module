import 'package:get/get.dart';
import 'package:town_pass/page/children_park/mock/children_park_mock_data.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';

class ChildrenParkController extends GetxController {
  final RxInt currentTabIndex = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxInt selectedDateIndex = 0.obs;

  List<ParkAttraction> get attractions => ChildrenParkMockData.attractions;
  List<ParkEvent> get events => ChildrenParkMockData.events;
  ParkUserProfile get userProfile => ChildrenParkMockData.userProfile;

  List<String> get mapCategories => const [
        '遊樂設施',
        '美食餐飲',
        '紀念品店',
        '廁所',
        '親子服務',
        '交通',
        '表演活動',
      ];

  List<String> get dateTabs => const ['今天 11/24', '明天 11/25', '週二 11/26'];

  List<ParkAttraction> get nearbyPopular => attractions.take(3).toList();

  List<ParkAttraction> get shortestWait {
    final List<ParkAttraction> list = List.of(attractions)
      ..sort(
        (a, b) => (a.waitMinutes ?? 999).compareTo(b.waitMinutes ?? 999),
      );
    return list.take(3).toList();
  }

  List<ParkAttraction> get hotToday => attractions.take(4).toList();

  List<ParkEvent> eventsByPeriod(String period) {
    return events.where((event) => event.period == period).toList();
  }
}
