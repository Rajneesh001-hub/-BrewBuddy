// ─── Auth Models ──────────────────────────────────────────────────────────────
// Defines AuthUser (the authenticated user record) and AuthStatus enum.
// Kept separate from UserModel so the auth layer has no UI or loyalty
// dependencies, and to make toJson/fromJson easy for shared_preferences.

/// Represents an authenticated BrewBuddy user.
class AuthUser {
  final String phone;
  final String name;
  final String email;
  final DateTime? dateOfBirth;
  final bool whatsappUpdates;
  final int stars;
  final bool isNewUser;

  const AuthUser({
    required this.phone,
    this.name = '',
    this.email = '',
    this.dateOfBirth,
    this.whatsappUpdates = false,
    this.stars = 0,
    this.isNewUser = true,
  });

  /// Returns a copy of this [AuthUser] with the given fields replaced.
  AuthUser copyWith({
    String? phone,
    String? name,
    String? email,
    DateTime? dateOfBirth,
    bool? whatsappUpdates,
    int? stars,
    bool? isNewUser,
  }) {
    return AuthUser(
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      whatsappUpdates: whatsappUpdates ?? this.whatsappUpdates,
      stars: stars ?? this.stars,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  /// Serialise to a JSON map for storage in shared_preferences.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'phone': phone,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'whatsappUpdates': whatsappUpdates,
      'stars': stars,
      'isNewUser': isNewUser,
    };
  }

  /// Deserialise from a JSON map read from shared_preferences.
  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : null,
      whatsappUpdates: json['whatsappUpdates'] as bool? ?? false,
      stars: json['stars'] as int? ?? 0,
      isNewUser: json['isNewUser'] as bool? ?? true,
    );
  }

  @override
  String toString() =>
      'AuthUser(phone: $phone, name: $name, stars: $stars, isNewUser: $isNewUser)';
}

/// Represents the current authentication state of the app.
enum AuthStatus {
  /// No session active, user is on the login screen.
  unauthenticated,

  /// An async auth operation (OTP send / verify / session check) is in flight.
  loading,

  /// The user has successfully authenticated (or is browsing as guest).
  authenticated,

  /// The user is browsing without logging in.
  guest,
}
