import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkTransportView extends StatelessWidget {
  const ChildrenParkTransportView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: '交通資訊',
      currentRoute: TPRoute.childrenParkTransport,
      description: '交通路由骨架已建立，後續會搬遷大眾運輸與停車指引內容。',
    );
  }
}
