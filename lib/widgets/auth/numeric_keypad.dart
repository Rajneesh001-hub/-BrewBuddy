// ─── Numeric Keypad ───────────────────────────────────────────────────────────
// A 3-column grid of 12 keys: 1-9, (empty), 0, backspace.
// Replaces the system keyboard on the OTP screen.

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 8),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 8),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 8),
        _buildRow(['', '0', '<']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key.isEmpty) {
          return const SizedBox(width: 64, height: 64);
        }
        if (key == '<') {
          return _KeyButton(
            onTap: onBackspace,
            child: const Icon(
              Icons.backspace_outlined,
              color: AppColors.darkText,
              size: 22,
            ),
          );
        }
        return _KeyButton(
          onTap: () => onDigitPressed(key),
          child: Text(
            key,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          splashColor: AppColors.freshGreen.withValues(alpha: 0.12),
          child: Center(child: child),
        ),
      ),
    );
  }
}
