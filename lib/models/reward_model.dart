// ─── Reward Model ─────────────────────────────────────────────────────────────
// Represents a redeemable reward in the catalog.

/// Loyalty tier — determines benefits and color
enum LoyaltyTier {
  green, // 5+ stars
  gold,  // 30+ stars
}

extension LoyaltyTierExtension on LoyaltyTier {
  String get displayName {
    switch (this) {
      case LoyaltyTier.green:
        return 'Green';
      case LoyaltyTier.gold:
        return 'Gold';
    }
  }

  int get starsRequired {
    switch (this) {
      case LoyaltyTier.green:
        return 5;
      case LoyaltyTier.gold:
        return 30;
    }
  }
}

/// A single item in the reward redemption catalog
class RewardModel {
  final String id;
  final String title;
  final String description;
  final int starCost;
  final String imageEmoji;
  final bool isAvailable; // can be false if out of stock

  const RewardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.starCost,
    required this.imageEmoji,
    this.isAvailable = true,
  });
}

/// User's birthday reward state
class BirthdayReward {
  final bool isActive;
  final DateTime expiryDate;
  final String description;

  const BirthdayReward({
    required this.isActive,
    required this.expiryDate,
    required this.description,
  });

  /// Whether the birthday reward is still valid
  bool get isValid => isActive && DateTime.now().isBefore(expiryDate);
}
