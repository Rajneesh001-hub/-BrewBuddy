// ─── Birthday Banner ─────────────────────────────────────────────────────────
// Shown on the Home screen when the birthday reward is still valid.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reward_model.dart';
import '../theme/app_theme.dart';

class BirthdayBanner extends StatelessWidget {
  final BirthdayReward reward;
  final VoidCallback? onRedeem;

  const BirthdayBanner({
    super.key,
    required this.reward,
    this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    if (!reward.isValid) return const SizedBox.shrink();

    final expiryStr =
        DateFormat('MMM dd, yyyy').format(reward.expiryDate);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B3F2A), Color(0xFF9B5B3A)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
      ),
      child: Row(
        children: [
          // ── Cake emoji ──
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
            ),
            child: const Center(
              child: Text('🎂', style: TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 14),

          // ── Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎉 Birthday Reward!',
                  style: AppTextStyles.h5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reward.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires: $expiryStr',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.caramelGold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // ── Redeem CTA ──
          GestureDetector(
            onTap: onRedeem,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.caramelGold,
                borderRadius: BorderRadius.circular(
                    AppDimensions.cornerRadiusPill),
              ),
              child: Text(
                'Redeem',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
