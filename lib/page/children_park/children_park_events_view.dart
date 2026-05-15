import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkEventsView extends StatelessWidget {
  const ChildrenParkEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: '活動行程',
      currentRoute: TPRoute.childrenParkEvents,
      description: '活動路由骨架已建立，後續會搬遷活動時間表與提醒流程。',
    );
  }
}
