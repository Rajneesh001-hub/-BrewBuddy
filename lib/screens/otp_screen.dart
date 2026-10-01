// ─── OTP Verification Screen ──────────────────────────────────────────────────
// Step 2 of 3: Enter 6-digit OTP sent to the phone number.
// Uses a custom numeric keypad (no system keyboard).

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/auth/numeric_keypad.dart';
import '../widgets/auth/otp_boxes_row.dart';
import '../widgets/auth/primary_button.dart';
import '../widgets/auth/step_chip.dart';
import 'complete_profile_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = '';
  int _activeIndex = 0;
  bool _hasError = false;
  bool _isVerifying = false;
  bool _isAutoDetecting = true;

  // Resend countdown
  Timer? _resendTimer;
  int _resendSeconds = 30;
  bool _resendEnabled = false;

  // Auto-fill timer
  Timer? _autoFillTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _startAutoDetect();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendSeconds = 30;
    _resendEnabled = false;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _resendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  void _startAutoDetect() {
    _autoFillTimer?.cancel();
    _autoFillTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _isAutoDetecting = false;
        _otp = '123456';
        _activeIndex = 6;
        _hasError = false;
      });
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _autoFillTimer?.cancel();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_otp.length < 6) {
      setState(() {
        _otp = _otp + digit;
        _activeIndex = _otp.length;
        _hasError = false;
      });
    }
  }

  void _onBackspace() {
    if (_otp.isNotEmpty) {
      setState(() {
        _otp = _otp.substring(0, _otp.length - 1);
        _activeIndex = _otp.length;
        _hasError = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit code.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(widget.phone, _otp);

    if (!mounted) return;

    setState(() => _isVerifying = false);

    if (!success) {
      setState(() {
        _hasError = true;
        _otp = '';
        _activeIndex = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code. Try again.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorRed,
        ),
      );
      // Reset error state after shake animation completes
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _hasError = false);
      });
      return;
    }

    // Success — route based on new/returning user
    if (authProvider.isNewUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CompleteProfileScreen(phone: widget.phone),
        ),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BrewBuddyShell()),
        (route) => false,
      );
    }
  }

  void _onResend() {
    if (!_resendEnabled) return;
    setState(() {
      _otp = '';
      _activeIndex = 0;
      _hasError = false;
      _isAutoDetecting = false;
    });
    _startResendTimer();
  }

  String _formattedSeconds() {
    return '00:${_resendSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        foregroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Verify OTP'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded, size: 14),
                const SizedBox(width: 4),
                Text(
                  '256-Bit SSL',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Step chip ─────────────────────────────────────────────
                  const StepChip(text: 'Step 2 of 3 • Brewing Account'),

                  const SizedBox(height: AppDimensions.paddingL),

                  // ── Heading ───────────────────────────────────────────────
                  Text('Verify your number', style: AppTextStyles.h2),
                  const SizedBox(height: AppDimensions.paddingS),
                  Wrap(
                    children: [
                      Text(
                        'Enter the 6-digit code sent to +91 ${widget.phone}  ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.mediumGrey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successGreenLight,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.cornerRadiusPill,
                            ),
                          ),
                          child: Text(
                            'Edit',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.freshGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.paddingM),

                  // ── Auto-detecting card ───────────────────────────────────
                  if (_isAutoDetecting)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: AppDimensions.paddingM,
                      ),
                      decoration: AppDecorations.card,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.freshGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Auto-detecting SMS OTP…',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ── OTP boxes ─────────────────────────────────────────────
                  OtpBoxesRow(
                    value: _otp,
                    activeIndex: _activeIndex,
                    hasError: _hasError,
                  ),

                  const SizedBox(height: AppDimensions.paddingM),

                  // ── Resend row ─────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!_resendEnabled)
                        Text(
                          'Resend code in ${_formattedSeconds()}',
                          style: AppTextStyles.bodySmall,
                        ),
                      if (_resendEnabled)
                        const SizedBox.shrink(),
                      TextButton(
                        onPressed: _resendEnabled ? _onResend : null,
                        child: Text(
                          'Resend OTP',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _resendEnabled
                                ? AppColors.freshGreen
                                : AppColors.mediumGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppDimensions.paddingS),

                  // ── 50 Bonus Stars banner ─────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.successGreenLight,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.cornerRadius,
                      ),
                      border: Border.all(
                        color: AppColors.freshGreen.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '50 Bonus Stars will be unlocked directly to your profile upon verification.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.freshGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimensions.paddingM),

                  // ── Verify button ─────────────────────────────────────────
                  PrimaryButton(
                    label: 'Verify & Continue →',
                    onPressed: _verifyOtp,
                    isLoading: _isVerifying,
                  ),

                  const SizedBox(height: AppDimensions.paddingM),

                  // ── Debug hint ────────────────────────────────────────────
                  if (kDebugMode)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Text(
                          '🔑 Demo code: 123456',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: AppDimensions.paddingS),

                  // ── Didn't receive SMS ────────────────────────────────────
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Contacting Roastery Care… (demo)',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        "Didn't receive SMS? Contact Roastery Care",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.freshGreen,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.freshGreen,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.paddingL),
                ],
              ),
            ),
          ),

          // ── Numeric keypad (pinned to bottom) ──────────────────────────────
          Container(
            color: AppColors.cream,
            padding: const EdgeInsets.only(
              left: AppDimensions.paddingL,
              right: AppDimensions.paddingL,
              top: AppDimensions.paddingS,
              bottom: AppDimensions.paddingM,
            ),
            child: NumericKeypad(
              onDigitPressed: _onDigitPressed,
              onBackspace: _onBackspace,
            ),
          ),
        ],
      ),
    );
  }
}
