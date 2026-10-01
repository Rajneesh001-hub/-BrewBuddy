// ─── Mock Rewards Data ────────────────────────────────────────────────────────

import '../models/reward_model.dart';
import '../models/user_model.dart';

/// Reward redemption catalog
final List<RewardModel> mockRewards = [
  const RewardModel(
    id: 'rw_001',
    title: 'Free Tall Beverage',
    description: 'Redeem for any Tall-size beverage of your choice.',
    starCost: 25,
    imageEmoji: '☕',
  ),
  const RewardModel(
    id: 'rw_002',
    title: 'Extra Espresso Shot',
    description: 'Add a free extra shot to your next drink.',
    starCost: 5,
    imageEmoji: '⚡',
  ),
  const RewardModel(
    id: 'rw_003',
    title: 'Non-Dairy Milk Upgrade',
    description: 'Upgrade to Oat, Almond, or Soy milk for free.',
    starCost: 10,
    imageEmoji: '🥛',
  ),
  const RewardModel(
    id: 'rw_004',
    title: 'Free Syrup Pump',
    description: 'Add any flavored syrup to your next beverage free.',
    starCost: 5,
    imageEmoji: '🍯',
  ),
  const RewardModel(
    id: 'rw_005',
    title: 'Free Grande Beverage',
    description: 'Redeem for any Grande-size beverage of your choice.',
    starCost: 50,
    imageEmoji: '🏆',
  ),
  const RewardModel(
    id: 'rw_006',
    title: 'Free Food Item',
    description: 'One free bakery or food item from our menu.',
    starCost: 35,
    imageEmoji: '🥐',
  ),
  const RewardModel(
    id: 'rw_007',
    title: 'Double Star Day',
    description: 'Earn 2x stars on your next purchase.',
    starCost: 15,
    imageEmoji: '⭐',
  ),
  const RewardModel(
    id: 'rw_008',
    title: 'Venti Upgrade',
    description: 'Upgrade your drink size to Venti for free.',
    starCost: 20,
    imageEmoji: '📏',
    isAvailable: false,
  ),
];

/// Mock user data
UserModel mockUser = UserModel(
  id: 'usr_001',
  name: 'Priya Sharma',
  email: 'priya.sharma@email.com',
  phone: '+91 98765 43210',
  stars: 18,
  tier: LoyaltyTier.green,
  birthday: DateTime(1998, 10, 5),
  birthdayReward: BirthdayReward(
    isActive: true,
    expiryDate: DateTime(2026, 10, 31),
    description: 'Free tall beverage on your birthday month!',
  ),
  memberSince: DateTime(2023, 3, 15),
);

/// Tier benefits by tier
Map<LoyaltyTier, List<String>> tierBenefits = {
  LoyaltyTier.green: [
    'Earn 1 Star per ₹50 spent',
    'Free birthday reward',
    'Exclusive member offers',
    'Early access to seasonal menu',
  ],
  LoyaltyTier.gold: [
    'Earn 1.5 Stars per ₹50 spent',
    'Free birthday reward (double value)',
    'Monthly free drink reward',
    'Priority pickup',
    'Exclusive Gold member events',
    'Free Wi-Fi upgrade at stores',
  ],
};
