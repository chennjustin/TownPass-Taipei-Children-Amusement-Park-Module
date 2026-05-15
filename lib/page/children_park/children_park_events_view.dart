import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/pages/schedule_page.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkEventsView extends StatelessWidget {
  const ChildrenParkEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: '活動行程',
      currentRoute: TPRoute.childrenParkEvents,
      body: ChildrenParkSchedulePage(),
    );
  }
}
