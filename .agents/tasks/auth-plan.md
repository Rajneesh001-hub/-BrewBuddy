# Implementation Plan — BrewBuddy Auth Flow

**Project:** `/Users/rajneesharya/Desktop/Flutter/brew_buddy`  
**Flutter:** 3.47 / Dart 3.13  
**Decomposed into:** 3 FEAT artifacts under `.agents/tasks/auth-login-flow/`

---

## Key Design Decisions

1. **AuthProvider is separate from UserProvider.** UserProvider already owns rewards/stars/tier state for the app. AuthProvider owns login state (phone, isLoggedIn, isGuest, isNewUser). After login, AuthProvider.saveProfile calls UserProvider.addStars() to credit welcome stars. No circular dependency — AuthProvider does not import UserProvider; only the CompleteProfileScreen calls both.

2. **shared_preferences for session persistence.** The mock service reads/writes a JSON blob keyed by `'auth_user'` in shared_preferences. On cold start, SplashScreen calls `authProvider.checkSession()` — if a session exists, the user lands on BrewBuddyShell directly.

3. **No named routes.** The existing app uses `Navigator.push` / `Navigator.pushReplacement` imperatively. The auth flow follows the same pattern: `Navigator.pushAndRemoveUntil(..., (route) => false)` to clear the stack when transitioning to BrewBuddyShell.

4. **AuthUser is a new model, not a modification to UserModel.** UserModel is tightly coupled to rewards/stars/tier; adding auth fields to it would break existing providers. AuthUser holds auth-specific fields (phone, isNewUser, whatsappUpdates). Name/email/dob live on AuthUser and are used to greet the user in HomeScreen.

5. **Numeric keypad prevents system keyboard on OTP screen.** `keyboardType: TextInputType.none` is set where needed; the custom NumericKeypad widget drives all input.

6. **Import cycle avoidance.** `auth_service.dart` (abstract) → no imports from lib. `mock_auth_service.dart` → imports auth_service + auth_models + shared_preferences. `auth_provider.dart` → imports auth_service + auth_models only. Screens import auth_provider. HomeScreen imports auth_provider but not auth_service directly.

---

## Implementation Plan

- [ ] 1. **Add shared_preferences dependency**  
      Add `shared_preferences: ^2.2.3` under `dependencies` in `pubspec.yaml` (after `intl: ^0.19.0`). Run `flutter pub get`.  
      Files: `pubspec.yaml`  
      Verify: `cd /Users/rajneesharya/Desktop/Flutter/brew_buddy && flutter pub get` — exits 0, no resolution errors.

- [ ] 2. **Create AuthUser model and AuthStatus enum**  
      Create `lib/models/auth_models.dart`. Define `AuthStatus` enum (`unauthenticated`, `loading`, `authenticated`, `guest`) and `AuthUser` class with fields: `String phone`, `String name`, `String email`, `DateTime? dateOfBirth`, `bool whatsappUpdates`, `int stars`, `bool isNewUser`. Add `const` constructor, `copyWith`, `toJson()` → `Map<String,dynamic>`, `AuthUser.fromJson(Map<String,dynamic>)` factory. No imports from other lib files.  
      Files: `lib/models/auth_models.dart`  
      Verify: `flutter analyze lib/models/auth_models.dart` — 0 errors.

- [ ] 3. **Create AuthService interface**  
      Create `lib/services/auth_service.dart`. Abstract class `AuthService` with: `Future<bool> sendOtp(String phone)`, `Future<AuthUser?> verifyOtp(String phone, String otp)`, `Future<AuthUser> saveProfile({required String phone, required String name, String? email, DateTime? dateOfBirth, bool whatsappUpdates = false})`, `Future<AuthUser?> getStoredSession()`, `Future<void> logout()`. Add `static bool isValidIndianMobile(String phone)` — returns `RegExp(r'^[6-9]\d{9}$').hasMatch(phone)`.  
      Files: `lib/services/auth_service.dart`  
      Verify: `flutter analyze lib/services/auth_service.dart` — 0 errors.

- [ ] 4. **Create MockAuthService**  
      Create `lib/services/mock_auth_service.dart` implementing `AuthService`. All async methods prefix with `await Future.delayed(const Duration(milliseconds: 900))`. Logic: `sendOtp` always returns `true` for valid numbers. `verifyOtp` returns `AuthUser` if `otp == '123456'`, else `null`; checks shared_preferences for existing user keyed `'auth_user_\$phone'` to set `isNewUser=false`. `getStoredSession` reads `SharedPreferences` key `'auth_user'`, deserializes with `AuthUser.fromJson`. `saveProfile` creates `AuthUser`, serializes, stores under `'auth_user'` AND `'auth_user_\$phone'`. `logout` removes `'auth_user'` key only.  
      Files: `lib/services/mock_auth_service.dart`  
      Verify: `flutter analyze lib/services/mock_auth_service.dart` — 0 errors.

- [ ] 5. **Create AuthProvider**  
      Create `lib/providers/auth_provider.dart` extending `ChangeNotifier`. Private fields: `final AuthService _authService` (defaults to `MockAuthService()`), `AuthUser? _currentUser`, `AuthStatus _status = AuthStatus.unauthenticated`, `String? _error`, `bool _isLoading = false`. Getters: `currentUser`, `status`, `isLoggedIn` (`_status == AuthStatus.authenticated && _status != AuthStatus.guest`), `isGuest` (`_status == AuthStatus.guest`), `isNewUser` (`_currentUser?.isNewUser ?? true`), `error`, `isLoading`. Methods: `Future<bool> sendOtp(String phone)`, `Future<bool> verifyOtp(String phone, String otp)` (sets `_currentUser`, updates status), `Future<void> saveProfile({...})`, `void loginAsGuest()` (sets `_status = AuthStatus.guest`), `Future<void> logout()`, `Future<void> checkSession()` (calls `_authService.getStoredSession()`, if non-null sets user + status=authenticated).  
      Files: `lib/providers/auth_provider.dart`  
      Verify: `flutter analyze lib/providers/auth_provider.dart` — 0 errors.

- [ ] 6. **Create PrimaryButton widget**  
      Create `lib/widgets/auth/primary_button.dart`. Full-width pill `ElevatedButton` using theme's elevated button style (already configured in `AppTheme`). When `isLoading=true`, replaces text with a white `CircularProgressIndicator(strokeWidth: 2.5)` and `onPressed=null`. Props: `String label`, `VoidCallback? onPressed`, `bool isLoading`.  
      Files: `lib/widgets/auth/primary_button.dart`  
      Verify: `flutter analyze lib/widgets/auth/primary_button.dart` — 0 errors.

- [ ] 7. **Create SocialButton widget**  
      Create `lib/widgets/auth/social_button.dart`. Full-width pill button with icon + label. Two factory constructors: `SocialButton.google(onPressed)` — white background, `AppColors.lightGrey` border, `AppColors.darkText` text, Google 'G' icon (use `Icons.g_mobiledata` or a text 'G' in bold); `SocialButton.apple(onPressed)` — `AppColors.deepGreen` background, white text, `Icons.apple` icon. `minimumSize: const Size(double.infinity, 52)`.  
      Files: `lib/widgets/auth/social_button.dart`  
      Verify: `flutter analyze lib/widgets/auth/social_button.dart` — 0 errors.

- [ ] 8. **Create PhoneField widget**  
      Create `lib/widgets/auth/phone_field.dart`. A `Row` with: (a) a fixed-width white container `(width: 72, height: 52)` with `🇮🇳 +91` text, `AppDecorations.card` style, `BorderRadius.circular(AppDimensions.cornerRadiusPill)`; (b) `Expanded` `TextFormField` with `keyboardType: TextInputType.phone`, `inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)]`, `hintText: '98765 43210'`, rounded border style matching `AppTheme.inputDecorationTheme`. Shows `errorText` below in `AppTextStyles.bodySmall.copyWith(color: AppColors.errorRed)` when non-null.  
      Files: `lib/widgets/auth/phone_field.dart`  
      Verify: `flutter analyze lib/widgets/auth/phone_field.dart` — 0 errors.

- [ ] 9. **Create OtpBoxesRow widget**  
      Create `lib/widgets/auth/otp_boxes_row.dart`. `StatefulWidget` (needs `AnimationController`). 6 boxes in a `Row`, each `width: 48, height: 56`, white background, `BorderRadius.circular(12)`. Active box: `Border.all(color: AppColors.freshGreen, width: 2)`. Error state: `Border.all(color: AppColors.errorRed, width: 2)` on all boxes. Filled box: shows digit in `AppTextStyles.h3`. Shake: `AnimationController(duration: Duration(milliseconds: 500))` + `Tween<Offset>(begin: Offset.zero, end: Offset(0.05, 0))` + `CurvedAnimation(curve: Curves.elasticIn)` applied to `SlideTransition` wrapping the entire Row. `hasError` prop triggers `_shakeController.forward().then((_) => _shakeController.reverse())`. `dispose()` disposes controller.  
      Files: `lib/widgets/auth/otp_boxes_row.dart`  
      Verify: `flutter analyze lib/widgets/auth/otp_boxes_row.dart` — 0 errors.

- [ ] 10. **Create NumericKeypad widget**  
       Create `lib/widgets/auth/numeric_keypad.dart`. A `Column` of 4 rows: `[1,2,3]`, `[4,5,6]`, `[7,8,9]`, `[null,0,backspace]`. Each key is a `GestureDetector` wrapping a `Container(width: 64, height: 64, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white), ...)`. Digit keys show the digit in `GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.deepGreen)`. Backspace key shows `Icon(Icons.backspace_outlined, color: AppColors.deepGreen, size: 24)`. Null cell renders `SizedBox(width: 64, height: 64)`. Props: `ValueChanged<String> onDigitPressed`, `VoidCallback onBackspace`.  
       Files: `lib/widgets/auth/numeric_keypad.dart`  
       Verify: `flutter analyze lib/widgets/auth/numeric_keypad.dart` — 0 errors.

- [ ] 11. **Create StepChip widget**  
       Create `lib/widgets/auth/step_chip.dart`. A pill-shaped `Container` with `AppColors.deepGreenLight` background (use `Color(0xFF1E3932).withOpacity(0.10)`), padding `horizontal:12, vertical:5`, `BorderRadius.circular(AppDimensions.cornerRadiusPill)`. Shows `text` in `AppTextStyles.labelSmall.copyWith(color: AppColors.deepGreen, fontWeight: FontWeight.w600)`. Props: `String text`.  
       Files: `lib/widgets/auth/step_chip.dart`  
       Verify: `flutter analyze lib/widgets/auth/step_chip.dart` — 0 errors.

- [ ] 12. **Create SplashScreen**  
       Create `lib/screens/splash_screen.dart`. `StatefulWidget`. `initState`: use `WidgetsBinding.instance.addPostFrameCallback((_) async { await Future.delayed(const Duration(seconds: 2)); if (!mounted) return; final auth = context.read<AuthProvider>(); await auth.checkSession(); if (!mounted) return; Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => auth.isLoggedIn ? const BrewBuddyShell() : const LoginScreen())); })`. Import `BrewBuddyShell` from `'../main.dart'`. Build: `Scaffold(backgroundColor: AppColors.cream)` with centered `Column`: (a) green circle avatar 120x120 with ☕ text `fontSize:56`, (b) `SizedBox(height:16)`, (c) `'BrewBuddy'` in `AppTextStyles.h1.copyWith(color: AppColors.deepGreen)`, (d) `'Your daily brew, perfected'` in `AppTextStyles.bodySmall`, (e) `SizedBox(height:32)`, (f) `CircularProgressIndicator(color: AppColors.freshGreen, strokeWidth: 2)`.  
       Files: `lib/screens/splash_screen.dart`  
       Verify: `flutter analyze lib/screens/splash_screen.dart` — 0 errors.

- [ ] 13. **Create LoginScreen**  
       Create `lib/screens/login_screen.dart`. `StatefulWidget` with `_phoneController`, `_formKey`, `_isLoading`, `_phoneError`. Full layout per spec: close button + small logo row → large logo → headline/subtitle → two feature chips → white card (PhoneField + helper + PrimaryButton) → divider+label → two SocialButtons → Guest TextButton → Terms RichText. Phone validation on Continue: `AuthService.isValidIndianMobile(phone)` — if false, set `_phoneError` inline (do NOT use form validator snackbar, show it under the PhoneField). On valid: call `authProvider.sendOtp(phone)` then `Navigator.push(..., OtpScreen(phone: phone))`. Social buttons show SnackBar `'Demo only: please use mobile number login'`. Guest button calls `authProvider.loginAsGuest()` then `Navigator.pushAndRemoveUntil(...BrewBuddyShell..., (r) => false)`. Dispose `_phoneController`.  
       Files: `lib/screens/login_screen.dart`  
       Verify: `flutter analyze lib/screens/login_screen.dart` — 0 errors.

- [ ] 14. **Create OtpScreen**  
       Create `lib/screens/otp_screen.dart`. `StatefulWidget`, constructor `const OtpScreen({super.key, required this.phone})`. State: `String _otp = ''`, `bool _hasError = false`, `Timer? _resendTimer`, `int _resendSeconds = 30`, `bool _autoDetecting = true`, `bool _isVerifying = false`. `initState`: (a) start periodic timer decrementing `_resendSeconds` to 0; (b) `Future.delayed(Duration(seconds: 3), () { if (mounted) setState(() { _otp = '123456'; _autoDetecting = false; }); })`. `dispose`: cancel timer + dispose `_shakeController` (held by OtpBoxesRow internally via `hasError` prop). Full build layout — no `Scaffold.resizeToAvoidBottomInset` (keyboard doesn't appear): AppBar with back + title, StepChip + '256-Bit SSL' row, heading + phone+Edit row, auto-detect card (visible while `_autoDetecting`), OtpBoxesRow, resend row, bonus stars banner (`Container` with `AppColors.successGreenLight` bg), PrimaryButton 'Verify & Continue →', debug hint (`if (kDebugMode)` show `'Demo code: 123456'`), `Spacer()`, NumericKeypad. Keypad digit handler: `if (_otp.length < 6) setState(() { _otp += digit; })`. Backspace: `if (_otp.isNotEmpty) setState(() { _otp = _otp.substring(0, _otp.length - 1); })`. `_verifyOtp()`: sets `_isVerifying=true`, calls `authProvider.verifyOtp(widget.phone, _otp)`. On null: set `_hasError=true`, clear `_otp` after frame, show snackbar. On success: if `authProvider.isNewUser` → push `CompleteProfileScreen(phone: widget.phone)`, else → `pushAndRemoveUntil(BrewBuddyShell)`.  
       Files: `lib/screens/otp_screen.dart`  
       Verify: `flutter analyze lib/screens/otp_screen.dart` — 0 errors.

- [ ] 15. **Create CompleteProfileScreen**  
       Create `lib/screens/complete_profile_screen.dart`. Constructor `const CompleteProfileScreen({super.key, required this.phone})`. State: controllers for name, email; `_selectedDob`, `_whatsappUpdates = true`, `_isSaving = false`, `_formKey`. Skip button: `Navigator.pushAndRemoveUntil` to `BrewBuddyShell`, then after frame calls `authProvider.saveProfile(phone: widget.phone, name: 'Guest user')`. Build: AppBar with back + 'Step 3 of 3' + 'Skip for now' action. Body: ScrollView → welcome gift card (green gradient, 🎁 emoji, text per spec) → Form with three fields: Full Name (`validator`: non-empty), Date of Birth (read-only tap → `showDatePicker(lastDate: now minus 10 years)`), Email (optional, validates format if non-empty via `RegExp(r'^\\S+@\\S+\\.\\S+$')`). SwitchListTile for WhatsApp. Privacy row. PrimaryButton 'Get Started': validates form, sets `_isSaving=true`, calls `await authProvider.saveProfile(...)`, calls `context.read<UserProvider>().addStars(20)`, then `pushAndRemoveUntil(BrewBuddyShell)`. Dispose controllers.  
       Files: `lib/screens/complete_profile_screen.dart`  
       Verify: `flutter analyze lib/screens/complete_profile_screen.dart` — 0 errors.

- [ ] 16. **Wire main.dart — add AuthProvider and SplashScreen**  
       Edit `lib/main.dart`: add imports for `'providers/auth_provider.dart'` and `'screens/splash_screen.dart'`. Add `ChangeNotifierProvider(create: (_) => AuthProvider())` as the first provider in the `MultiProvider` list. Change `home: const BrewBuddyShell()` to `home: const SplashScreen()`.  
       Files: `lib/main.dart`  
       Verify: `flutter analyze lib/main.dart` — 0 errors.

- [ ] 17. **Update home_screen.dart for auth-awareness**  
       Edit `lib/screens/home_screen.dart`: add import `'../providers/auth_provider.dart'`. In `build()`, add `final authProvider = context.watch<AuthProvider>();`. Change the greeting name text: `authProvider.isGuest ? 'Guest' : user.name.split(' ').first`. If `authProvider.isGuest`, replace the stars container with `const SizedBox.shrink()`. After the greeting Row (before Section B birthday banner), add: if `authProvider.isGuest`, insert a tappable `Container` with `AppColors.goldLight` bg, `'⭐ Log in to earn Stars'` text in `AppTextStyles.labelMedium.copyWith(color: AppColors.caramelGold)` and a `'Sign In'` chip that calls `Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false)`. Import `LoginScreen` from `'../screens/login_screen.dart'`.  
       Files: `lib/screens/home_screen.dart`  
       Verify: `flutter analyze lib/screens/home_screen.dart` — 0 errors.

- [ ] 18. **Full project analysis and test run**  
       Run `flutter analyze` from project root — must produce 0 errors. Run `flutter test` — must pass. Fix any cross-file import or type errors surfaced.  
       Files: all modified files  
       Verify: `cd /Users/rajneesharya/Desktop/Flutter/brew_buddy && flutter analyze && flutter test`

---

## File Creation Order (respects dependencies)

```
Step 1:  pubspec.yaml
Step 2:  lib/models/auth_models.dart
Step 3:  lib/services/auth_service.dart
Step 4:  lib/services/mock_auth_service.dart        ← imports auth_service + auth_models
Step 5:  lib/providers/auth_provider.dart           ← imports auth_service + auth_models
Steps 6–11: lib/widgets/auth/*.dart                 ← import theme only
Step 12: lib/screens/splash_screen.dart             ← imports auth_provider, main.dart (BrewBuddyShell)
Step 13: lib/screens/login_screen.dart              ← imports auth_provider, auth_service, otp_screen
Step 14: lib/screens/otp_screen.dart                ← imports auth_provider, complete_profile_screen, widgets/auth/*
Step 15: lib/screens/complete_profile_screen.dart   ← imports auth_provider, user_provider, main.dart
Steps 16–17: lib/main.dart, lib/screens/home_screen.dart   ← edit existing files
Step 18: flutter analyze + flutter test
```

## Import Cycle Check

- `auth_models.dart` → no lib imports ✓  
- `auth_service.dart` → imports `auth_models.dart` only ✓  
- `mock_auth_service.dart` → imports `auth_service.dart`, `auth_models.dart` ✓  
- `auth_provider.dart` → imports `auth_service.dart`, `auth_models.dart` ✓  
- Screens → import `auth_provider.dart` (not service directly) ✓  
- `home_screen.dart` → imports `auth_provider.dart`, `login_screen.dart` — one-way, no cycle ✓  
- `main.dart` exports `BrewBuddyShell` (used by splash/screens) — one-way ✓

No circular imports.
