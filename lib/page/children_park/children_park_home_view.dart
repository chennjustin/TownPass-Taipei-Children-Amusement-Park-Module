import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkHomeView extends StatelessWidget {
  const ChildrenParkHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: '兒童新樂園',
      currentRoute: TPRoute.childrenParkHome,
      description: '首頁骨架已建立，後續會搬遷公告、快捷服務與推薦內容。',
      showSecondaryLinks: true,
    );
  }
}
