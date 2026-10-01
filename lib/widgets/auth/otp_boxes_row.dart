// ─── OTP Boxes Row ────────────────────────────────────────────────────────────
// A Row of 6 individual digit containers.
// Active box gets a green border; error state triggers a shake animation.
// Controlled entirely by parent (no TextFields inside).

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class OtpBoxesRow extends StatefulWidget {
  const OtpBoxesRow({
    super.key,
    required this.value,
    required this.activeIndex,
    this.hasError = false,
  });

  /// The current OTP string, 0–6 characters.
  final String value;

  /// Which box is currently active (0-based).
  final int activeIndex;

  /// When true, all boxes turn red and a shake animation plays.
  final bool hasError;

  @override
  State<OtpBoxesRow> createState() => _OtpBoxesRowState();
}

class _OtpBoxesRowState extends State<OtpBoxesRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.05, 0),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: const Offset(-0.05, 0),
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(-0.05, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_shakeController);
  }

  @override
  void didUpdateWidget(OtpBoxesRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasError && !oldWidget.hasError) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _shakeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) => _buildBox(index)),
      ),
    );
  }

  Widget _buildBox(int index) {
    final bool isFilled = index < widget.value.length;
    final bool isActive = index == widget.activeIndex;
    final String digit = isFilled ? widget.value[index] : '';

    Color borderColor;
    double borderWidth;

    if (widget.hasError) {
      borderColor = AppColors.errorRed;
      borderWidth = 2.0;
    } else if (isActive) {
      borderColor = AppColors.freshGreen;
      borderWidth = 2.0;
    } else if (isFilled) {
      borderColor = AppColors.freshGreen.withValues(alpha: 0.5);
      borderWidth = 1.5;
    } else {
      borderColor = AppColors.lightGrey;
      borderWidth = 1.5;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: AppColors.freshGreen.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Center(
        child: Text(
          digit,
          style: AppTextStyles.h3.copyWith(
            color: widget.hasError ? AppColors.errorRed : AppColors.deepGreen,
          ),
        ),
      ),
    );
  }
}
