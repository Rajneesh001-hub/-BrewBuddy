// ─── Auth Service Interface ────────────────────────────────────────────────────
// Abstract contract for authentication.  Swap MockAuthService for a real
// backend implementation without touching any UI code.

import '../models/auth_models.dart';

abstract class AuthService {
  /// Send a 6-digit OTP to [phone].
  ///
  /// Returns `true` if the phone number is valid and the OTP was dispatched,
  /// `false` if [phone] fails validation.
  Future<bool> sendOtp(String phone);

  /// Verify [otp] for [phone].
  ///
  /// Returns an [AuthUser] on success, `null` if the OTP is wrong.
  Future<AuthUser?> verifyOtp(String phone, String otp);

  /// Persist (or update) a user's profile after OTP verification.
  Future<AuthUser> saveProfile({
    required String phone,
    required String name,
    String? email,
    DateTime? dateOfBirth,
    bool whatsappUpdates,
  });

  /// Read the persisted session from local storage.
  ///
  /// Returns `null` when no session exists (first launch / after logout).
  Future<AuthUser?> getStoredSession();

  /// Clear the persisted session.
  Future<void> logout();

  // ─── Static Helpers ──────────────────────────────────────────────────────────

  /// Returns `true` if [phone] is a valid Indian mobile number:
  /// exactly 10 digits and starts with 6, 7, 8, or 9.
  static bool isValidIndianMobile(String phone) {
    // Strip any spaces or hyphens the user might have typed
    final digits = phone.replaceAll(RegExp(r'[\s\-]'), '');
    return RegExp(r'^[6-9]\d{9}$').hasMatch(digits);
  }
}
