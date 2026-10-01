// ─── User Provider ────────────────────────────────────────────────────────────
// Manages user profile, star balance, loyalty tier, and reward redemptions.

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/reward_model.dart';
import '../data/mock_rewards.dart';

class UserProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  UserModel _user = mockUser;
  final List<RewardModel> _catalog = mockRewards;
  final List<String> _redeemedRewardIds = [];

  // ── Getters ────────────────────────────────────────────────────────────────

  UserModel get user => _user;

  List<RewardModel> get rewardCatalog => _catalog;

  List<String> get redeemedRewardIds => List.unmodifiable(_redeemedRewardIds);

  int get stars => _user.stars;

  LoyaltyTier get tier => _user.tier;

  BirthdayReward get birthdayReward => _user.birthdayReward;

  bool get hasBirthdayReward => _user.birthdayReward.isValid;

  /// Stars needed to next tier
  int get starsToNextTier => _user.starsToNextTier();

  /// Progress 0.0–1.0 toward next tier
  double get tierProgress => _user.tierProgress();

  // ── Actions ────────────────────────────────────────────────────────────────

  /// Add stars after a completed order
  void addStars(int amount) {
    final newStars = _user.stars + amount;
    final newTier = UserModel.tierFromStars(newStars);
    _user = _user.copyWith(stars: newStars, tier: newTier);
    notifyListeners();
  }

  /// Attempt to redeem a reward — returns true on success
  bool redeemReward(RewardModel reward) {
    if (_user.stars < reward.starCost) return false;
    if (!reward.isAvailable) return false;

    final newStars = _user.stars - reward.starCost;
    final newTier = UserModel.tierFromStars(newStars);
    _user = _user.copyWith(stars: newStars, tier: newTier);
    _redeemedRewardIds.add(reward.id);
    notifyListeners();
    return true;
  }

  /// Check if a reward has been redeemed this session
  bool isRedeemed(String rewardId) => _redeemedRewardIds.contains(rewardId);

  /// Whether the user can afford a reward
  bool canAfford(RewardModel reward) => _user.stars >= reward.starCost;

  /// Tier-specific benefits
  List<String> get currentTierBenefits =>
      tierBenefits[_user.tier] ?? [];
}
