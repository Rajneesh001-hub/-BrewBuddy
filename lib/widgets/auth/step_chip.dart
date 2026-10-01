// ─── Step Chip ────────────────────────────────────────────────────────────────
// A small pill-shaped container showing step info.
// Example: 'Step 2 of 3 • Brewing Account'

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StepChip extends StatelessWidget {
  const StepChip({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.deepGreenLight,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.deepGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
