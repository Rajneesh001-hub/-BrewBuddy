// ─── Home Screen ──────────────────────────────────────────────────────────────
// Main landing screen with Google Stitch design specification:
// - Coffee shop branding with location selector in AppBar
// - Greeting + Stars row with Gold tier badge
// - Birthday reward banner
// - Your Usual Order card with reorder button
// - Happy Hour special timer
// - Seasonal Specials carousel
// - Bean of the Day info card

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/user_provider.dart';
import '../models/customization_model.dart';
import '../theme/app_theme.dart';
import '../widgets/birthday_banner.dart';
import '../widgets/drink_card.dart';
import '../widgets/happy_hour_banner.dart';
import 'cart_screen.dart';
import 'menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final menuProvider = context.watch<MenuProvider>();
    final cartProvider = context.watch<CartProvider>();
    final user = userProvider.user;
    final seasonal = menuProvider.seasonalDrinksForHome;

    // Greeting based on time of day
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning,'
        : hour < 17
            ? 'Good afternoon,'
            : 'Good evening,';

    return Scaffold(
      backgroundColor: AppColors.cream,
      // ────── APPBAR ──────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // LEFT: Logo + Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Coffee emoji + title
                Row(
                  children: [
                    const Text(
                      '☕',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BrewBuddy · HOME',
                      style: AppTextStyles.h5.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                // Row 2: Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      'Indranagar 100ft Rd',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // RIGHT: Actions
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 22,
              ),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: AppColors.freshGreen,
                radius: 16,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ────── BODY ────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ────── SECTION A: Greeting + Stars Row ──────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Greeting column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.freshGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.name.split(' ').first,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.deepGreen,
                            ),
                          ),
                          Text(
                            'Your morning brew is ready to craft.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.mediumGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Right: Stars container
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.goldLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.caramelGold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.caramelGold,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${user.stars} Stars',
                                  style: AppTextStyles.starBalance,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.caramelGold,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'GOLD TIER',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ────── SECTION B: Birthday Banner ──────────────────────
                  if (userProvider.hasBirthdayReward) ...[
                    BirthdayBanner(
                      reward: user.birthdayReward,
                      onRedeem: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              '🎂 Birthday reward applied to your next order!',
                            ),
                            backgroundColor: AppColors.freshGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ────── SECTION C: Your Usual Order Card ────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppColors.deepGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '☕',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YOUR USUAL',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.mediumGrey,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Double Shot Oat Cortado',
                                style: AppTextStyles.h5.copyWith(
                                  color: AppColors.deepGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.freshGreen,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Reorder',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ────── SECTION D: Happy Hour Special Card ──────────────
                  const HappyHourBanner(),

                  const SizedBox(height: 16),

                  // ────── SECTION E: Seasonal Specials ────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seasonal Specials',
                              style: AppTextStyles.sectionTitle,
                            ),
                            Text(
                              'FESTIVE ED.',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.caramelGold,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'See all >',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.freshGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 230,
                    child: seasonal.isNotEmpty
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: seasonal.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final drink = seasonal[index];
                              return DrinkCard(
                                drink: drink,
                                isCompact: true,
                                onTap: () {
                                  menuProvider.selectDrink(drink);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MenuScreen(),
                                    ),
                                  );
                                },
                                onAdd: () {
                                  cartProvider.addItem(
                                    drink,
                                    const CustomizationModel(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${drink.name} added to cart',
                                      ),
                                      backgroundColor: AppColors.freshGreen,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      action: SnackBarAction(
                                        label: 'View Cart',
                                        textColor: AppColors.caramelGold,
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const CartScreen(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No seasonal drinks available',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.mediumGrey,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),

                  // ────── SECTION F: Bean of the Day ──────────────────────
                  Text(
                    'BEAN OF THE DAY',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.mediumGrey,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: AppDecorations.card,
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              '🫘',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Attikan Estate · Medium Dark Roast',
                                style: AppTextStyles.h5.copyWith(
                                  color: AppColors.deepGreen,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Single origin · Karnataka, India',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.mediumGrey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
