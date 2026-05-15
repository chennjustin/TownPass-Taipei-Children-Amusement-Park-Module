import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/gen/assets.gen.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            _topAppBar(),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNavigation
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _tabIndexByRoute(currentRoute),
              backgroundColor: TPColors.white,
              selectedItemColor: TPColors.primary700,
              unselectedItemColor: TPColors.grayscale700,
              selectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
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
                  label: '設施列表',
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

  Widget _topAppBar() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: TPColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Assets.svg.logoS.svg(width: 20, height: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '台北迪士尼',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: TPColors.primary700,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                color: TPColors.grayscale700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
