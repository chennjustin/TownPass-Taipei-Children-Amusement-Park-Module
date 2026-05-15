import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/util/tp_app_bar.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkShell extends StatelessWidget {
  final String title;
  final String currentRoute;
  final String description;
  final bool showSecondaryLinks;

  const ChildrenParkShell({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.description,
    this.showSecondaryLinks = false,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: TPColors.grayscale900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '此頁面為路由骨架，內容將在後續版本補齊。',
                style: TextStyle(
                  fontSize: 14,
                  color: TPColors.grayscale700,
                ),
              ),
              if (showSecondaryLinks) ...[
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => _navigate(TPRoute.childrenParkTransport),
                      child: const Text('前往交通資訊'),
                    ),
                    OutlinedButton(
                      onPressed: () => _navigate(TPRoute.childrenParkFaq),
                      child: const Text('前往 FAQ'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '首頁'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attractions_outlined),
            label: '設施',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '地圖'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined), label: '活動'),
        ],
      ),
    );
  }
}
