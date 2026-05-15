import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/page/children_park/children_park_controller.dart';
import 'package:town_pass/page/children_park/widgets/children_park_widgets.dart';
import 'package:town_pass/page/children_park/widgets/children_park_shell.dart';
import 'package:town_pass/util/tp_route.dart';

class ChildrenParkFacilitiesView extends GetView<ChildrenParkController> {
  const ChildrenParkFacilitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChildrenParkShell(
      title: '設施資訊',
      currentRoute: TPRoute.childrenParkFacilities,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        children: [
          const ParkSearchBar(hint: '搜尋設施、排隊時間、區域'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.mapCategories
                .take(5)
                .map(
                  (category) => Chip(
                    label: Text(category),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    backgroundColor: Colors.white,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          ...controller.attractions.map(
            (attraction) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AttractionListCard(attraction: attraction),
            ),
          ),
        ],
      ),
    );
  }
}
