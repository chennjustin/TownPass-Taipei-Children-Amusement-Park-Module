import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/map/children_park_map_controller.dart';
import 'package:town_pass/page/children_park/pages/map_page.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkMapView extends StatefulWidget {
  const ChildrenParkMapView({super.key});

  @override
  State<ChildrenParkMapView> createState() => _ChildrenParkMapViewState();
}

class _ChildrenParkMapViewState extends State<ChildrenParkMapView> {
  late final ChildrenParkMapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ChildrenParkMapController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.handleNavigationArgs(Get.arguments);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: '園區地圖',
      currentRoute: TPRoute.childrenParkMap,
      body: ChildrenParkMapPage(),
    );
  }
}
