// ─── Drink Card Widget ────────────────────────────────────────────────────────
// Grid card with coffee.png images, rating badge, and modern layout.
// Uses local coffee.png asset for fast rendering without network requests.

import 'package:flutter/material.dart';
import '../models/drink_model.dart';
import '../theme/app_theme.dart';

class DrinkCard extends StatelessWidget {
  final DrinkModel drink;
  final String imageUrl; // Real image URL for grid cards
  final double rating; // Rating 4.5–5.0
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final bool isCompact; // smaller version for carousel

  const DrinkCard({
    super.key,
    required this.drink,
    this.imageUrl = '',
    this.rating = 4.8,
    required this.onTap,
    required this.onAdd,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppDecorations.card,
        child: isCompact ? _buildCompact() : _buildFull(),
      ),
    );
  }

  String _getReviewCount(String drinkId) {
    final hash = drinkId.hashCode.abs();
    final options = ['1.3k', '890', '450', '2.1k', '670', '1.1k', '320', '980', '750', '1.8k'];
    return options[hash % options.length];
  }

  // Full grid card with real images
  Widget _buildFull() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Image area ──
        Stack(
          children: [
            // Image container with rounded top corners
            Container(
              height: 160,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.cornerRadius),
                  topRight: Radius.circular(AppDimensions.cornerRadius),
                ),
                color: AppColors.cream,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.cornerRadius),
                  topRight: Radius.circular(AppDimensions.cornerRadius),
                ),
                child: Image.asset(
                  'assets/images/coffee.png',
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Rating badge (top-left)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.caramelGold,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.cornerRadiusPill),
                ),
                child: Text(
                  '★ ${rating.toStringAsFixed(1)} (${_getReviewCount(drink.id)})',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),

            // Limited time badge (top-right)
            if (drink.isLimitedTime)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed,
                    borderRadius: BorderRadius.circular(
                        AppDimensions.cornerRadiusPill),
                  ),
                  child: Text(
                    'Limited Time',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
          ],
        ),

        // ── Info area ──
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drink name
              Text(
                drink.name,
                style: AppTextStyles.h5.copyWith(
                  fontSize: 14,
                  color: AppColors.deepGreen,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 3),

              // Description
              Text(
                drink.description,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.mediumGrey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Price + Add button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Price
                  Text(
                    '₹${drink.basePrice.toStringAsFixed(0)}',
                    style: AppTextStyles.price.copyWith(
                      fontSize: 16,
                      color: AppColors.freshGreen,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  // Add button
                  GestureDetector(
                    onTap: onAdd,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.freshGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.add,
                            color: AppColors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Compact carousel card — coffee image + add button
  Widget _buildCompact() {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.cornerRadius),
                  topRight: Radius.circular(AppDimensions.cornerRadius),
                ),
                child: Image.asset(
                  'assets/images/coffee.png',
                  width: 160,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              if (drink.isLimitedTime)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.caramelGold,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cornerRadiusPill),
                    ),
                    child: Text(
                      'Limited',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Info + add button
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drink.name,
                  style: AppTextStyles.h5.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${drink.basePrice.toStringAsFixed(0)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.freshGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.freshGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add,
                            color: AppColors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
