// ─── Auth Provider ─────────────────────────────────────────────────────────────
// ChangeNotifier that owns the authentication state.
// Screens call methods here; they never touch AuthService directly.

import 'package:flutter/foundation.dart';

import '../models/auth_models.dart';
import '../services/auth_service.dart';
import '../services/mock_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _authService = authService ?? MockAuthService();

  final AuthService _authService;

  // ─── Private State ────────────────────────────────────────────────────────────

  AuthUser? _currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;
  bool _isGuest = false;
  String? _error;
  bool _isLoading = false;

  // ─── Public Getters ───────────────────────────────────────────────────────────

  AuthUser? get currentUser => _currentUser;
  AuthStatus get status => _status;

  /// `true` when the user has authenticated with a real phone number and OTP.
  bool get isLoggedIn =>
      _status == AuthStatus.authenticated && !_isGuest;

  /// `true` when the user is browsing without logging in.
  bool get isGuest => _isGuest;

  /// The last error message, cleared at the start of each new operation.
  String? get error => _error;

  bool get isLoading => _isLoading;

  /// `true` when the user has just verified OTP but not yet completed profile.
  bool get isNewUser => _currentUser?.isNewUser ?? true;

  // ─── Actions ─────────────────────────────────────────────────────────────────

  /// Sends an OTP to [phone].
  ///
  /// Returns `true` on success (valid phone), `false` if the phone is invalid.
  /// On failure, [error] is set with a user-facing message.
  Future<bool> sendOtp(String phone) async {
    _setLoading(true);
    _error = null;

    try {
      final success = await _authService.sendOtp(phone);
      if (!success) {
        _error = 'Please enter a valid 10-digit Indian mobile number.';
      }
      return success;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Verifies [otp] for [phone].
  ///
  /// Returns `true` on success.  On failure, [error] is set.
  Future<bool> verifyOtp(String phone, String otp) async {
    _setLoading(true);
    _error = null;

    try {
      final user = await _authService.verifyOtp(phone, otp);
      if (user == null) {
        _error = 'Invalid code. Try again.';
        return false;
      }
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _isGuest = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Saves (or updates) the user's profile details.
  Future<void> saveProfile({
    required String name,
    String? email,
    DateTime? dateOfBirth,
    bool whatsappUpdates = false,
  }) async {
    if (_currentUser == null) return;

    _setLoading(true);
    _error = null;

    try {
      final updated = await _authService.saveProfile(
        phone: _currentUser!.phone,
        name: name,
        email: email,
        dateOfBirth: dateOfBirth,
        whatsappUpdates: whatsappUpdates,
      );
      _currentUser = updated;
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _error = 'Could not save profile. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  /// Allows the user to browse the app without logging in.
  void loginAsGuest() {
    _currentUser = null;
    _isGuest = true;
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  /// Clears the session and navigates the UI back to login.
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _isGuest = false;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Reads any persisted session on app start.
  ///
  /// Call this once from the splash screen (or main.dart) before the user
  /// sees any screen.  If a session is found, the status becomes
  /// [AuthStatus.authenticated]; otherwise it stays [AuthStatus.unauthenticated].
  Future<void> checkSession() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final stored = await _authService.getStoredSession();
      if (stored != null) {
        _currentUser = stored;
        _status = AuthStatus.authenticated;
        _isGuest = false;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  /// Factory that creates an [AuthProvider] and calls [checkSession] before
  /// returning.  Use this when you need the session state immediately (e.g.,
  /// when wiring up MultiProvider in main.dart).
  static Future<AuthProvider> create({AuthService? authService}) async {
    final provider = AuthProvider(authService: authService);
    await provider.checkSession();
    return provider;
  }

  // ─── Private Helpers ─────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
