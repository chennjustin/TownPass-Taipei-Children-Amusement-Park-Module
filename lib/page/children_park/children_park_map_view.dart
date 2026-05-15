import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkMapView extends StatelessWidget {
  const ChildrenParkMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: '園區地圖',
      currentRoute: TPRoute.childrenParkMap,
      description: '地圖路由骨架已建立，後續會搬遷即時地圖與設施定位功能。',
    );
  }
}
