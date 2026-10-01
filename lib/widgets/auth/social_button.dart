// ─── Social Button ────────────────────────────────────────────────────────────
// Full-width pill button for Google (white bg, border) and Apple (dark bg).
// Used for non-functional social login buttons.

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDark = backgroundColor.computeLuminance() < 0.5;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
          ),
          side: isDark
              ? BorderSide.none
              : const BorderSide(color: AppColors.lightGrey, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        icon: Icon(icon, color: textColor, size: 20),
        label: Text(
          label,
          style: AppTextStyles.buttonText.copyWith(color: textColor),
        ),
      ),
    );
  }
}
