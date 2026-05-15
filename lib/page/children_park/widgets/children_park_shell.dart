import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/util/tp_app_bar.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkShell extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget body;
  final bool showBottomNavigation;

  const ChildrenParkShell({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.showBottomNavigation = true,
  });

  int _tabIndexByRoute(String routeName) {
    return switch (routeName) {
      TPRoute.childrenParkHome => 0,
      TPRoute.childrenParkFacilities => 1,
      TPRoute.childrenParkMap => 2,
      TPRoute.childrenParkEvents => 3,
      _ => 0,
    };
  }

  void _navigate(String routeName) {
    if (currentRoute == routeName) {
      return;
    }
    Get.toNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TPColors.white,
      appBar: TPAppBar(title: title),
      body: SafeArea(child: body),
      bottomNavigationBar: showBottomNavigation
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _tabIndexByRoute(currentRoute),
              selectedItemColor: TPColors.primary700,
              unselectedItemColor: TPColors.grayscale700,
              onTap: (index) {
                final routeName = switch (index) {
                  0 => TPRoute.childrenParkHome,
                  1 => TPRoute.childrenParkFacilities,
                  2 => TPRoute.childrenParkMap,
                  3 => TPRoute.childrenParkEvents,
                  _ => TPRoute.childrenParkHome,
                };
                _navigate(routeName);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: '首頁'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attractions_outlined),
                  label: '設施',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.map_outlined), label: '地圖'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.event_note_outlined), label: '活動'),
              ],
            )
          : null,
    );
  }
}
