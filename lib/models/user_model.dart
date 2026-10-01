// ─── User Model ───────────────────────────────────────────────────────────────
// Holds the current user's profile and loyalty state.

import 'reward_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int stars; // current star balance
  final LoyaltyTier tier;
  final DateTime birthday;
  final BirthdayReward birthdayReward;
  final DateTime memberSince;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.stars,
    required this.tier,
    required this.birthday,
    required this.birthdayReward,
    required this.memberSince,
  });

  /// Determine tier from star balance
  static LoyaltyTier tierFromStars(int stars) {
    if (stars >= LoyaltyTier.gold.starsRequired) return LoyaltyTier.gold;
    return LoyaltyTier.green;
  }

  /// Stars needed to reach the next tier
  int starsToNextTier() {
    switch (tier) {
      case LoyaltyTier.green:
        return (LoyaltyTier.gold.starsRequired - stars).clamp(0, 999);
      case LoyaltyTier.gold:
        return 0; // already at max tier
    }
  }

  /// Progress fraction (0.0–1.0) towards the next tier
  double tierProgress() {
    switch (tier) {
      case LoyaltyTier.green:
        // Progress from Green threshold (5) to Gold threshold (30)
        final earned = (stars - 5).clamp(0, 25);
        return earned / 25.0;
      case LoyaltyTier.gold:
        return 1.0;
    }
  }

  UserModel copyWith({
    int? stars,
    LoyaltyTier? tier,
    BirthdayReward? birthdayReward,
  }) {
    return UserModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      stars: stars ?? this.stars,
      tier: tier ?? this.tier,
      birthday: birthday,
      birthdayReward: birthdayReward ?? this.birthdayReward,
      memberSince: memberSince,
    );
  }
}
