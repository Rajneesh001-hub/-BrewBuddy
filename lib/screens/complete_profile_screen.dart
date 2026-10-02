// ─── Complete Profile Screen ──────────────────────────────────────────────────
// Step 3 of 3: New users fill in their profile details.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/auth/primary_button.dart';
import '../widgets/auth/step_chip.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key, required this.phone});

  final String phone;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDob;
  bool _whatsappUpdates = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final maxDate = DateTime(now.year - 10, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1920),
      lastDate: maxDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.freshGreen,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.darkText,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDob = picked);
    }
  }

  void _onSkip() {
    final authProvider = context.read<AuthProvider>();
    // Save a minimal profile with Guest name so session is persisted
    authProvider.saveProfile(name: 'Guest user').then((_) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BrewBuddyShell()),
        (route) => false,
      );
    });
  }

  Future<void> _onGetStarted() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    await authProvider.saveProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      dateOfBirth: _selectedDob,
      whatsappUpdates: _whatsappUpdates,
    );

    if (!mounted) return;

    // Sync UserProvider with the saved auth profile
    final savedUser = authProvider.currentUser;
    if (savedUser != null) {
      userProvider.updateFromAuth(savedUser);
    }

    // Award welcome stars
    userProvider.addStars(20);

    setState(() => _isSaving = false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const BrewBuddyShell()),
      (route) => false,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} / '
        '${date.month.toString().padLeft(2, '0')} / '
        '${date.year}';
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
        title: const Text('Complete Profile'),
        actions: [
          TextButton(
            onPressed: _onSkip,
            child: Text(
              'Skip for now',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Step chip ─────────────────────────────────────────────────
              const StepChip(text: 'Step 3 of 3'),

              const SizedBox(height: AppDimensions.paddingL),

              // ── Welcome gift card ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: AppDecorations.deepGreenGradient,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🎁', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You're 1 step away from your first Stars!",
                            style: AppTextStyles.h5.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Complete your details to unlock a Free Welcome Beverage + 20 Bonus Stars on your first sip.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.85),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingL),

              // ── Form fields ───────────────────────────────────────────────
              Text('Full Name *', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                controller: _nameController,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkText,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full name is required.';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: AppDimensions.paddingM),

              Text('Date of Birth', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                readOnly: true,
                onTap: _pickDate,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkText,
                ),
                decoration: InputDecoration(
                  hintText: 'DD / MM / YYYY',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                  helperText: 'For your birthday reward',
                  helperStyle: AppTextStyles.bodySmall,
                  prefixIcon: const Icon(Icons.cake_outlined),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
                ),
                controller: TextEditingController(
                  text: _selectedDob != null ? _formatDate(_selectedDob!) : '',
                ),
              ),

              const SizedBox(height: AppDimensions.paddingM),

              Text(
                'Email Address (optional)',
                style: AppTextStyles.labelLarge,
              ),
              const SizedBox(height: AppDimensions.paddingS),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkText,
                ),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.mediumGrey,
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: _validateEmail,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: AppDimensions.paddingM),

              // ── WhatsApp toggle ───────────────────────────────────────────
              Container(
                decoration: AppDecorations.card,
                child: SwitchListTile(
                  value: _whatsappUpdates,
                  onChanged: (value) =>
                      setState(() => _whatsappUpdates = value),
                  activeThumbColor: AppColors.freshGreen,
                  title: Text(
                    'WhatsApp Updates',
                    style: AppTextStyles.labelLarge,
                  ),
                  subtitle: Text(
                    'Get order updates and offers on WhatsApp',
                    style: AppTextStyles.bodySmall,
                  ),
                  secondary: const Text('📱', style: TextStyle(fontSize: 22)),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingL),

              // ── Privacy note ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: AppColors.mediumGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Encrypted & Protected by BrewBuddy Privacy',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingL),

              // ── Get Started button ─────────────────────────────────────────
              PrimaryButton(
                label: 'Get Started',
                onPressed: _onGetStarted,
                isLoading: _isSaving,
              ),

              const SizedBox(height: AppDimensions.paddingXL),
            ],
          ),
        ),
      ),
    );
  }
}
