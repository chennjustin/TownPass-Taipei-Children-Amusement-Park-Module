import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:town_pass/util/tp_colors.dart';

class ChildrenParkSubPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const ChildrenParkSubPageHeader({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      decoration: const BoxDecoration(
        color: TPColors.white,
        border: Border(
          bottom: BorderSide(color: TPColors.grayscale100),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: TPColors.grayscale700),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: TPColors.grayscale900,
            ),
          ),
        ],
      ),
    );
  }
}
