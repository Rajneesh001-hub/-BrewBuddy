// ─── Rewards Screen ───────────────────────────────────────────────────────────
// Stars balance, tier progress bar, current benefits, redemption catalog,
// and birthday reward banner.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reward_model.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/birthday_banner.dart';
import '../widgets/reward_tile.dart';
import '../widgets/star_progress_bar.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        automaticallyImplyLeading: false,
        title: const Text('Rewards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stars progress card ──────────────────────────────────────
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
              child: StarProgressBar(
                stars: user.stars,
                tier: user.tier,
                progress: user.tierProgress(),
                starsToNext: user.starsToNextTier(),
              ),
            ),

            const SizedBox(height: 16),

            // ── Tier milestone row ───────────────────────────────────────
            _TierMilestoneRow(currentTier: user.tier),

            const SizedBox(height: 20),

            // ── Birthday reward ──────────────────────────────────────────
            if (userProvider.hasBirthdayReward) ...[
              BirthdayBanner(
                reward: user.birthdayReward,
                onRedeem: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          '🎂 Birthday reward applied to your next order!'),
                      backgroundColor: AppColors.freshGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],

            // ── Current tier benefits ────────────────────────────────────
            _TierBenefitsCard(
              tier: user.tier,
              benefits: userProvider.currentTierBenefits,
            ),

            const SizedBox(height: 20),

            // ── Redeem catalog ───────────────────────────────────────────
            Row(
              children: [
                Text('Redeem Stars', style: AppTextStyles.sectionTitle),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.caramelGold, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${user.stars} available',
                      style: AppTextStyles.starBalance,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(
              'Tap to redeem. Stars are deducted immediately.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),

            ...userProvider.rewardCatalog.map((reward) {
              return RewardTile(
                reward: reward,
                canAfford: userProvider.canAfford(reward),
                isRedeemed: userProvider.isRedeemed(reward.id),
                onRedeem: () => _handleRedeem(context, userProvider, reward),
              );
            }),

            const SizedBox(height: 24),

            // ── How stars work ────────────────────────────────────────────
            _HowStarsWork(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _handleRedeem(
      BuildContext context, UserProvider provider, RewardModel reward) {
    // Confirm dialog before deducting
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        ),
        title: Text('Redeem Reward', style: AppTextStyles.h4),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reward.title, style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            Text(reward.description, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: AppColors.caramelGold, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Costs ${reward.starCost} Stars',
                  style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.caramelGold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final success = provider.redeemReward(reward);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? '✅ ${reward.title} redeemed!'
                        : '❌ Not enough stars',
                  ),
                  backgroundColor:
                      success ? AppColors.freshGreen : AppColors.errorRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppDimensions.cornerRadiusPill),
              ),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

// ─── Tier Milestone Row ───────────────────────────────────────────────────────

class _TierMilestoneRow extends StatelessWidget {
  final LoyaltyTier currentTier;
  const _TierMilestoneRow({required this.currentTier});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _MilestoneBubble(
          label: 'Green',
          stars: 5,
          icon: Icons.eco,
          isReached: true,
          color: AppColors.freshGreen,
        ),
        Expanded(
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.freshGreen,
                  currentTier == LoyaltyTier.gold
                      ? AppColors.caramelGold
                      : AppColors.lightGrey,
                ],
              ),
            ),
          ),
        ),
        _MilestoneBubble(
          label: 'Gold',
          stars: 30,
          icon: Icons.workspace_premium,
          isReached: currentTier == LoyaltyTier.gold,
          color: AppColors.caramelGold,
        ),
      ],
    );
  }
}

class _MilestoneBubble extends StatelessWidget {
  final String label;
  final int stars;
  final IconData icon;
  final bool isReached;
  final Color color;

  const _MilestoneBubble({
    required this.label,
    required this.stars,
    required this.icon,
    required this.isReached,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReached ? color : AppColors.lightGrey,
            border: Border.all(
              color: isReached ? color : AppColors.mediumGrey,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isReached ? AppColors.white : AppColors.mediumGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isReached ? color : AppColors.mediumGrey,
              fontWeight:
                  isReached ? FontWeight.w700 : FontWeight.w400,
            )),
        Text('$stars ⭐',
            style: AppTextStyles.bodySmall.copyWith(
              color: isReached ? AppColors.darkText : AppColors.mediumGrey,
            )),
      ],
    );
  }
}

// ─── Tier Benefits Card ───────────────────────────────────────────────────────

class _TierBenefitsCard extends StatelessWidget {
  final LoyaltyTier tier;
  final List<String> benefits;

  const _TierBenefitsCard(
      {required this.tier, required this.benefits});

  @override
  Widget build(BuildContext context) {
    final isGold = tier == LoyaltyTier.gold;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(
          color:
              isGold ? AppColors.caramelGold.withValues(alpha: 0.5) : AppColors.lightGrey,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isGold
                      ? AppColors.caramelGold
                      : AppColors.freshGreen,
                  borderRadius: BorderRadius.circular(
                      AppDimensions.cornerRadiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGold ? Icons.workspace_premium : Icons.eco,
                      size: 14,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${tier.displayName} Member Benefits',
                      style: AppTextStyles.tierBadge,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...benefits.map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: isGold
                        ? AppColors.caramelGold
                        : AppColors.freshGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(benefit, style: AppTextStyles.bodyMedium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── How Stars Work ───────────────────────────────────────────────────────────

class _HowStarsWork extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.deepGreenLight,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(
            color: AppColors.deepGreen.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⭐', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('How Stars Work', style: AppTextStyles.h5),
            ],
          ),
          const SizedBox(height: 12),
          const _HowRow(
              emoji: '🛍️',
              text: 'Earn 1 Star for every ₹50 spent'),
          const _HowRow(
              emoji: '🌿',
              text: 'Reach 5 Stars to unlock Green tier'),
          const _HowRow(
              emoji: '🏆',
              text: 'Reach 30 Stars to unlock Gold tier'),
          const _HowRow(
              emoji: '🎁',
              text: 'Redeem Stars for free drinks & upgrades'),
          const _HowRow(
              emoji: '🎂',
              text: 'Get a free birthday drink every year'),
        ],
      ),
    );
  }
}

class _HowRow extends StatelessWidget {
  final String emoji;
  final String text;
  const _HowRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
