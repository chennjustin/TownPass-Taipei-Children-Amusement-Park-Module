import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkFacilitiesView extends StatelessWidget {
  const ChildrenParkFacilitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChildrenParkShell(
      title: '設施資訊',
      currentRoute: TPRoute.childrenParkFacilities,
      description: '設施列表路由已就緒，後續會搬遷分類、排隊時間與設施詳情。',
    );
  }
}
