// ─── Drink Card Widget ────────────────────────────────────────────────────────
// Redesigned full grid card with real coffee images, rating badge,
// and modern layout. Used in Menu grid and Home carousel.

import 'package:cached_network_image/cached_network_image.dart';
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
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.cream,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.freshGreen,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.cream,
                          child: const Center(
                            child: Text('☕', style: TextStyle(fontSize: 48)),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.cream,
                        child: Center(
                          child: Text(
                            drink.imageUrl,
                            style: const TextStyle(fontSize: 64),
                          ),
                        ),
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

  // Compact carousel card — real image + add button
  Widget _buildCompact() {
    // Map drink categories to relevant Unsplash coffee images
    final categoryImages = {
      DrinkCategory.hotCoffee: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&q=80',
      DrinkCategory.coldCoffee: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=300&q=80',
      DrinkCategory.frappuccino: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=300&q=80',
      DrinkCategory.tea: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=300&q=80',
      DrinkCategory.seasonal: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300&q=80',
    };
    final imgUrl = categoryImages[drink.category] ??
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=300&q=80';

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
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 120,
                    color: AppColors.cream,
                    child: Center(
                      child: Text(drink.imageUrl,
                          style: const TextStyle(fontSize: 48)),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 120,
                    color: AppColors.cream,
                    child: Center(
                      child: Text(drink.imageUrl,
                          style: const TextStyle(fontSize: 48)),
                    ),
                  ),
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
