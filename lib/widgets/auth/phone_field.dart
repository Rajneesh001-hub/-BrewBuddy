// ─── Phone Field ─────────────────────────────────────────────────────────────
// A Row with a +91 flag prefix container (non-tappable, white card style)
// and a TextFormField for the 10-digit phone number.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // +91 prefix container
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
                border: Border.all(color: AppColors.lightGrey, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indian flag emoji
                  const Text(
                    '🇮🇳',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '+91',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Phone number input
            Expanded(
              child: TextFormField(
                controller: controller,
                onChanged: onChanged,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: '98765 43210',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
                    borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
                    borderSide: const BorderSide(color: AppColors.lightGrey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
                    borderSide: const BorderSide(color: AppColors.freshGreen, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
                    borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
                    borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorRed,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
