// ─── Star Progress Bar ────────────────────────────────────────────────────────
// Shows stars balance, tier badge, and animated progress to next tier.

import 'package:flutter/material.dart';
import '../models/reward_model.dart';
import '../theme/app_theme.dart';

class StarProgressBar extends StatelessWidget {
  final int stars;
  final LoyaltyTier tier;
  final double progress; // 0.0 – 1.0
  final int starsToNext;

  const StarProgressBar({
    super.key,
    required this.stars,
    required this.tier,
    required this.progress,
    required this.starsToNext,
  });

  @override
  Widget build(BuildContext context) {
    final isGold = tier == LoyaltyTier.gold;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: isGold ? AppDecorations.goldGradient : AppDecorations.deepGreenGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Tier badge + stars count ──
          Row(
            children: [
              // Tier badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isGold
                      ? AppColors.deepGreen
                      : AppColors.caramelGold,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.cornerRadiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isGold ? Icons.workspace_premium : Icons.eco,
                      size: 14,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tier.displayName} Member',
                      style: AppTextStyles.tierBadge,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Stars count
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.caramelGold, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$stars Stars',
                    style: AppTextStyles.starBalance.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Progress bar ──
          Stack(
            children: [
              // Track
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.cornerRadiusPill),
                ),
              ),
              // Fill
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: 8,
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: AppColors.caramelGold,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cornerRadiusPill),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Label ──
          if (isGold)
            Text(
              '🏆 You\'ve reached Gold status!',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            )
          else
            Text(
              '$starsToNext more stars to reach Gold',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
        ],
      ),
    );
  }
}
