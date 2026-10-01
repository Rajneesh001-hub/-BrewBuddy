// ─── Login Screen ─────────────────────────────────────────────────────────────
// Welcome / Login screen — mobile number + OTP flow entry point.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth/phone_field.dart';
import '../widgets/auth/primary_button.dart';
import '../widgets/auth/social_button.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _phoneError;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final phone = _phoneController.text.trim();
    if (!AuthService.isValidIndianMobile(phone)) {
      setState(() {
        _phoneError = 'Enter a valid 10-digit Indian mobile number.';
      });
      return;
    }

    setState(() {
      _phoneError = null;
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(phone);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OtpScreen(phone: phone)),
      );
    } else {
      setState(() {
        _phoneError =
            authProvider.error ?? 'Failed to send OTP. Please try again.';
      });
    }
  }

  void _onSocialLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo only: please use mobile number login'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onGuestLogin() {
    final authProvider = context.read<AuthProvider>();
    authProvider.loginAsGuest();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BrewBuddyShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppDimensions.paddingM),

                // ── Top row: small logo (left) + close (right) ──────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Small logo
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.freshGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('☕', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    // Close button
                    GestureDetector(
                      onTap: _onGuestLogin,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.lightGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingL),

                // ── Large circular logo ─────────────────────────────────────
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.freshGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.freshGreen.withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('☕', style: TextStyle(fontSize: 42)),
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingL),

                // ── Headline ────────────────────────────────────────────────
                Text(
                  'Welcome to BrewBuddy',
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.paddingS),
                Text(
                  'Sign in to order ahead, personalize your brew, and earn Stars.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.paddingM),

                // ── Feature chips ───────────────────────────────────────────
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FeatureChip(label: 'FREE DRINK ON 150★'),
                    SizedBox(width: 8),
                    _FeatureChip(label: 'FAST COUNTER PICKUP'),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingL),

                // ── White card with phone input ─────────────────────────────
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: AppDecorations.card,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobile Number',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.deepGreen,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      PhoneField(
                        controller: _phoneController,
                        errorText: _phoneError,
                        onChanged: (_) {
                          if (_phoneError != null) {
                            setState(() => _phoneError = null);
                          }
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'We will send a 6-digit verification code',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      PrimaryButton(
                        label: 'Continue →',
                        onPressed: _onContinue,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingL),

                // ── Divider with 'or continue with' ─────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or continue with',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingM),

                // ── Social buttons ──────────────────────────────────────────
                SocialButton(
                  label: 'Continue with Google',
                  icon: Icons.g_mobiledata_rounded,
                  backgroundColor: AppColors.white,
                  textColor: AppColors.darkText,
                  onPressed: () => _onSocialLogin(context),
                ),
                const SizedBox(height: AppDimensions.paddingS),
                SocialButton(
                  label: 'Continue with Apple',
                  icon: Icons.apple_rounded,
                  backgroundColor: AppColors.darkText,
                  textColor: AppColors.white,
                  onPressed: () => _onSocialLogin(context),
                ),

                const SizedBox(height: AppDimensions.paddingM),

                // ── Guest link ──────────────────────────────────────────────
                TextButton(
                  onPressed: _onGuestLogin,
                  child: Text(
                    'Browse Cafe Menu as Guest',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.freshGreen,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.freshGreen,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingM),

                // ── Terms / Privacy ─────────────────────────────────────────
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.bodySmall,
                    children: [
                      const TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: AppTextStyles.bodySmall.copyWith(
                          decoration: TextDecoration.underline,
                          color: AppColors.freshGreen,
                          decorationColor: AppColors.freshGreen,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: AppTextStyles.bodySmall.copyWith(
                          decoration: TextDecoration.underline,
                          color: AppColors.freshGreen,
                          decorationColor: AppColors.freshGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Feature Chip ─────────────────────────────────────────────────────────────

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.successGreenLight,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
        border: Border.all(
          color: AppColors.freshGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.freshGreen,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
