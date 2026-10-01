// ─── Customization Row ────────────────────────────────────────────────────────
// Reusable row for stepper-style customization options (shots, pumps).

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomizationStepper extends StatelessWidget {
  final String label;
  final String? subtitle;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const CustomizationStepper({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Label
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelLarge),
              if (subtitle != null)
                Text(subtitle!, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        // Stepper controls
        Row(
          children: [
            _stepBtn(
              icon: Icons.remove,
              onTap: value > min ? () => onChanged(value - 1) : null,
            ),
            Container(
              width: 36,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: AppTextStyles.h4,
              ),
            ),
            _stepBtn(
              icon: Icons.add,
              onTap: value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepBtn({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.deepGreen
              : AppColors.lightGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.white : AppColors.mediumGrey,
        ),
      ),
    );
  }
}

/// Option selector row using horizontal chip-style buttons
class CustomizationOptionRow extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final Map<String, String>? subtitles; // option → extra price label

  const CustomizationOptionRow({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.subtitles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = opt == selected;
            return GestureDetector(
              onTap: () => onChanged(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.deepGreen
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(
                      AppDimensions.cornerRadius),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.deepGreen
                        : AppColors.lightGrey,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      opt,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.darkText,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    if (subtitles != null && subtitles![opt] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitles![opt]!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : AppColors.mediumGrey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
