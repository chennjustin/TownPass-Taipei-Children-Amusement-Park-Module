import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/pages/discover_page.dart';
import 'package:town_pass/page/children_park/pages/map_page.dart';
import 'package:town_pass/page/children_park/pages/profile_page.dart';
import 'package:town_pass/page/children_park/pages/schedule_page.dart';
import 'package:town_pass/util/tp_colors.dart';

class ChildrenParkView extends GetView<ChildrenParkController> {
  const ChildrenParkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentTabIndex.value,
          children: const [
            ChildrenParkMapPage(),
            ChildrenParkDiscoverPage(),
            ChildrenParkSchedulePage(),
            ChildrenParkProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentTabIndex.value,
          selectedItemColor: TPColors.primary700,
          unselectedItemColor: TPColors.grayscale700,
          selectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          onTap: (index) => controller.currentTabIndex.value = index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined), label: 'Map'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined), label: 'Discover'),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_note_outlined), label: 'Schedule'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
