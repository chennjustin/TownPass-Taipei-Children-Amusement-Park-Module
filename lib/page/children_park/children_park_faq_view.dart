import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkFaqView extends StatelessWidget {
  const ChildrenParkFaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: 'FAQ',
      currentRoute: TPRoute.childrenParkFaq,
      description: 'FAQ 路由骨架已建立，後續會搬遷常見問題與客服資訊。',
    );
  }
}
