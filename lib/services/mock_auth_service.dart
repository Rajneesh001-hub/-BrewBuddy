// ─── Mock Auth Service ─────────────────────────────────────────────────────────
// Simulates network latency with Future.delayed(~900 ms).
// OTP "123456" is always correct.  No real network calls are made.
// Session is persisted to shared_preferences under the key 'auth_user'.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_models.dart';
import 'auth_service.dart';

/// shared_preferences key where the current session's JSON is stored.
const String _kAuthUserKey = 'auth_user';

/// Simulated network delay for all async operations.
const Duration _kNetworkDelay = Duration(milliseconds: 900);

/// The only OTP the mock accepts as valid.
const String _kValidOtp = '123456';

class MockAuthService implements AuthService {
  @override
  Future<bool> sendOtp(String phone) async {
    await Future<void>.delayed(_kNetworkDelay);
    return AuthService.isValidIndianMobile(phone);
  }

  @override
  Future<AuthUser?> verifyOtp(String phone, String otp) async {
    await Future<void>.delayed(_kNetworkDelay);

    if (otp != _kValidOtp) return null;

    // Check whether this phone already has a saved profile.
    final stored = await _readStoredUser();
    if (stored != null && stored.phone == phone) {
      // Returning user — mark isNewUser=false.
      return stored.copyWith(isNewUser: false);
    }

    // New user — return a skeleton AuthUser; full profile filled in at Step 3.
    return AuthUser(
      phone: phone,
      isNewUser: true,
    );
  }

  @override
  Future<AuthUser> saveProfile({
    required String phone,
    required String name,
    String? email,
    DateTime? dateOfBirth,
    bool whatsappUpdates = false,
  }) async {
    await Future<void>.delayed(_kNetworkDelay);

    // Start with any existing record for this phone so we don't lose stars.
    final existing = await _readStoredUser();
    final int baseStars = (existing?.phone == phone) ? (existing!.stars) : 0;

    // New profile gets +20 welcome Stars on first save.
    final bool isNew = existing == null || existing.phone != phone;
    final int stars = isNew ? baseStars + 20 : baseStars;

    final user = AuthUser(
      phone: phone,
      name: name,
      email: email ?? '',
      dateOfBirth: dateOfBirth,
      whatsappUpdates: whatsappUpdates,
      stars: stars,
      isNewUser: false, // profile is now complete
    );

    await _persistUser(user);
    return user;
  }

  @override
  Future<AuthUser?> getStoredSession() async {
    await Future<void>.delayed(_kNetworkDelay);
    return _readStoredUser();
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAuthUserKey);
  }

  // ─── Private Helpers ─────────────────────────────────────────────────────────

  Future<AuthUser?> _readStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kAuthUserKey);
    if (jsonString == null) return null;
    try {
      final Map<String, dynamic> map =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return AuthUser.fromJson(map);
    } catch (_) {
      // Corrupt data — treat as no session.
      return null;
    }
  }

  Future<void> _persistUser(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAuthUserKey, jsonEncode(user.toJson()));
  }
}
