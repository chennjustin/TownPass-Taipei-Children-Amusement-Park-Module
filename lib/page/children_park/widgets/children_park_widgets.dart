import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:town_pass/page/children_park/model/children_park_models.dart';
import 'package:town_pass/util/tp_colors.dart';
import 'package:town_pass/util/tp_text.dart';

class ParkSearchBar extends StatelessWidget {
  final String hint;

  const ParkSearchBar({
    super.key,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: TPColors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: TPColors.primary600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TPText(
                  hint,
                  style: TPTextStyles.bodySemiBold,
                  color: TPColors.grayscale600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const CircleAvatar(
                radius: 15,
                backgroundColor: TPColors.primary200,
                child: TPText(
                  'TP',
                  style: TPTextStyles.caption,
                  color: TPColors.primary800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParkSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const ParkSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TPText(
                title,
                style: TPTextStyles.h2SemiBold.copyWith(fontSize: 28),
                color: TPColors.grayscale900,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                TPText(
                  subtitle,
                  style: TPTextStyles.caption,
                  color: TPColors.grayscale600,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class WaitBadge extends StatelessWidget {
  final String label;
  final WaitLevel level;

  const WaitBadge({
    super.key,
    required this.label,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bgColor, Color fgColor) = switch (level) {
      WaitLevel.low => (const Color(0xFFE6F8EE), const Color(0xFF2E7D32)),
      WaitLevel.medium => (const Color(0xFFFFF4DF), const Color(0xFF9A6700)),
      WaitLevel.high => (const Color(0xFFFFE5EE), const Color(0xFFB4235D)),
      WaitLevel.info => (const Color(0xFFE6F3FF), const Color(0xFF175CD3)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TPText(
        label,
        style: TPTextStyles.caption,
        color: fgColor,
      ),
    );
  }
}

class AttractionListCard extends StatelessWidget {
  final ParkAttraction attraction;
  final bool showArrow;

  const AttractionListCard({
    super.key,
    required this.attraction,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TPColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              attraction.imageUrl,
              width: 74,
              height: 74,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TPText(
                  attraction.name,
                  style: TPTextStyles.h3SemiBold,
                  color: TPColors.grayscale900,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                TPText(
                  '${attraction.waitLabel} ・ ${attraction.distanceText}',
                  style: TPTextStyles.bodyRegular,
                  color: TPColors.grayscale700,
                ),
                const SizedBox(height: 4),
                TPText(
                  '★ ${attraction.rating.toStringAsFixed(1)}',
                  style: TPTextStyles.caption,
                  color: TPColors.orange600,
                ),
              ],
            ),
          ),
          if (showArrow)
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: TPColors.primary100,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(
                Icons.arrow_forward,
                size: 18,
                color: TPColors.primary700,
              ),
            ),
        ],
      ),
    );
  }
}
