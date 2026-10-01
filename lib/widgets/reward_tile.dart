// ─── Reward Tile ──────────────────────────────────────────────────────────────
// Single row in the reward redemption catalog.

import 'package:flutter/material.dart';
import '../models/reward_model.dart';
import '../theme/app_theme.dart';

class RewardTile extends StatelessWidget {
  final RewardModel reward;
  final bool canAfford;
  final bool isRedeemed;
  final VoidCallback onRedeem;

  const RewardTile({
    super.key,
    required this.reward,
    required this.canAfford,
    required this.isRedeemed,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !reward.isAvailable || isRedeemed || !canAfford;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRedeemed
            ? AppColors.successGreenLight
            : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(
          color: isRedeemed
              ? AppColors.freshGreen.withOpacity(0.4)
              : AppColors.lightGrey,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Emoji icon ──
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
            ),
            child: Center(
              child: Text(
                reward.imageEmoji,
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ── Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.title, style: AppTextStyles.h5),
                const SizedBox(height: 2),
                Text(
                  reward.description,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Star cost chip
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.caramelGold, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      '${reward.starCost} Stars',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.caramelGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // ── Redeem button ──
          _buildRedeemButton(isDisabled),
        ],
      ),
    );
  }

  Widget _buildRedeemButton(bool isDisabled) {
    if (isRedeemed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.freshGreen,
          borderRadius:
              BorderRadius.circular(AppDimensions.cornerRadiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              'Redeemed',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (!reward.isAvailable) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius:
              BorderRadius.circular(AppDimensions.cornerRadiusPill),
        ),
        child: Text(
          'Unavailable',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.mediumGrey,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: isDisabled ? null : onRedeem,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isDisabled
              ? AppColors.lightGrey
              : AppColors.freshGreen,
          borderRadius:
              BorderRadius.circular(AppDimensions.cornerRadiusPill),
        ),
        child: Text(
          'Redeem',
          style: AppTextStyles.labelSmall.copyWith(
            color: isDisabled ? AppColors.mediumGrey : AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
