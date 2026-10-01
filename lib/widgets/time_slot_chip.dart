// ─── Time Slot Chip ───────────────────────────────────────────────────────────
// Selectable chip for pickup time slots. Past slots are disabled.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TimeSlotChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const TimeSlotChip({
    super.key,
    required this.time,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isDisabled) {
      bgColor = AppColors.lightGrey;
      textColor = AppColors.mediumGrey;
      borderColor = AppColors.lightGrey;
    } else if (isSelected) {
      bgColor = AppColors.deepGreen;
      textColor = AppColors.white;
      borderColor = AppColors.deepGreen;
    } else {
      bgColor = AppColors.white;
      textColor = AppColors.deepGreen;
      borderColor = AppColors.deepGreen.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:
              BorderRadius.circular(AppDimensions.cornerRadiusPill),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          time,
          style: AppTextStyles.labelMedium.copyWith(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
