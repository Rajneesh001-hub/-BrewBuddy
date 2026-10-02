// ─── Stars Chip ───────────────────────────────────────────────────────────────
// Small pill showing the user's current star balance. Used in the app bar area.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StarsChip extends StatelessWidget {
  final int stars;
  final bool light; // light version for dark backgrounds

  const StarsChip({
    super.key,
    required this.stars,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: light
            ? Colors.white.withValues(alpha: 0.15)
            : AppColors.deepGreen.withValues(alpha: 0.08),
        borderRadius:
            BorderRadius.circular(AppDimensions.cornerRadiusPill),
        border: Border.all(
          color: light
              ? Colors.white.withValues(alpha: 0.3)
              : AppColors.caramelGold.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 16,
            color: light ? AppColors.caramelGold : AppColors.caramelGold,
          ),
          const SizedBox(width: 5),
          Text(
            '$stars Stars',
            style: AppTextStyles.starBalance,
          ),
        ],
      ),
    );
  }
}
