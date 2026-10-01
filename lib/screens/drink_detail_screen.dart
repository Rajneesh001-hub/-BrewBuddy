// ─── Drink Detail Screen ──────────────────────────────────────────────────────
// Hero image, name, price, and three tabs: Nutrition / Origin / Brewing.
// "Customize" CTA navigates to CustomizationScreen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drink_model.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../theme/app_theme.dart';
import 'customization_screen.dart';

class DrinkDetailScreen extends StatefulWidget {
  const DrinkDetailScreen({super.key});

  @override
  State<DrinkDetailScreen> createState() => _DrinkDetailScreenState();
}

class _DrinkDetailScreenState extends State<DrinkDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final cartProvider = context.watch<CartProvider>();
    final drink = menuProvider.selectedDrink;

    if (drink == null) {
      return const Scaffold(
        body: Center(child: Text('No drink selected')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ─────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.deepGreen,
            iconTheme: const IconThemeData(color: AppColors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1E3932),
                          Color(0xFF2D5247),
                        ],
                      ),
                    ),
                  ),
                  // Drink emoji centered
                  Center(
                    child: Text(
                      drink.imageUrl,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  // Limited time badge overlay
                  if (drink.isLimitedTime)
                    Positioned(
                      top: 80,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.caramelGold,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.cornerRadiusPill),
                        ),
                        child: Text(
                          '🍂 Limited Time',
                          style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Name + Price + Category ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category label
                            Text(
                              drink.category.displayName.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.freshGreen,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(drink.name, style: AppTextStyles.h2),
                            const SizedBox(height: 6),
                            Text(
                              drink.description,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.mediumGrey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${drink.basePrice.toStringAsFixed(0)}',
                            style: AppTextStyles.h2.copyWith(
                                color: AppColors.freshGreen),
                          ),
                          Text(
                            'onwards',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Tabs ──────────────────────────────────────────────────
                Container(
                  color: AppColors.white,
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Nutrition'),
                      Tab(text: 'Origin'),
                      Tab(text: 'Brewing'),
                    ],
                    labelColor: AppColors.deepGreen,
                    unselectedLabelColor: AppColors.mediumGrey,
                    labelStyle: AppTextStyles.labelLarge.copyWith(
                        fontSize: 14),
                    unselectedLabelStyle: AppTextStyles.labelMedium
                        .copyWith(fontSize: 14),
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                          color: AppColors.freshGreen, width: 2.5),
                    ),
                  ),
                ),

                // ── Tab content (fixed height container) ─────────────────
                SizedBox(
                  height: 340,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Nutrition
                      _NutritionTab(nutrition: drink.nutrition),
                      // Tab 2: Origin
                      drink.origin != null
                          ? _OriginTab(origin: drink.origin!)
                          : _NoDataTab(
                              message:
                                  'Origin details not available for this drink.'),
                      // Tab 3: Brewing
                      _BrewingTab(brewing: drink.brewing),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ── Action buttons ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Column(
                    children: [
                      // Customize CTA (primary)
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomizationScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.tune, size: 18),
                        label: const Text('Customize & Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppDimensions.cornerRadiusPill),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Quick add (secondary)
                      OutlinedButton.icon(
                        onPressed: () {
                          cartProvider.addItem(
                              drink, menuProvider.currentCustomization);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${drink.name} added!'),
                              backgroundColor: AppColors.freshGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.shopping_bag_outlined,
                            size: 18),
                        label: const Text('Quick Add'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppDimensions.cornerRadiusPill),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nutrition Tab ────────────────────────────────────────────────────────────

class _NutritionTab extends StatelessWidget {
  final dynamic nutrition;
  const _NutritionTab({required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Per serving (Grande, 16 fl oz)',
              style: AppTextStyles.bodySmall),
          const SizedBox(height: 16),
          // Nutrition grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _NutritionCell(
                  label: 'Calories',
                  value: '${nutrition.calories}',
                  unit: 'kcal',
                  icon: '🔥'),
              _NutritionCell(
                  label: 'Caffeine',
                  value: '${nutrition.caffeineMg}',
                  unit: 'mg',
                  icon: '⚡'),
              _NutritionCell(
                  label: 'Sugar',
                  value: '${nutrition.sugarG.toStringAsFixed(1)}',
                  unit: 'g',
                  icon: '🍬'),
              _NutritionCell(
                  label: 'Fat',
                  value: '${nutrition.fatG.toStringAsFixed(1)}',
                  unit: 'g',
                  icon: '💧'),
              _NutritionCell(
                  label: 'Protein',
                  value: '${nutrition.proteinG.toStringAsFixed(1)}',
                  unit: 'g',
                  icon: '💪'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '* Values are approximate and based on standard recipe with whole milk.',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _NutritionCell extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String icon;

  const _NutritionCell({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              Text(
                '$value $unit',
                style: AppTextStyles.h5.copyWith(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Origin Tab ───────────────────────────────────────────────────────────────

class _OriginTab extends StatelessWidget {
  final dynamic origin;
  const _OriginTab({required this.origin});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Region banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: AppDecorations.deepGreenGradient,
            child: Row(
              children: [
                const Text('🗺️', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      origin.region,
                      style: AppTextStyles.h4.copyWith(
                          color: Colors.white),
                    ),
                    Text(
                      origin.country,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Flavor notes
          Text('Flavor Notes', style: AppTextStyles.h5),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.goldLight,
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
              border: Border.all(
                  color: AppColors.caramelGold.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('☕', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    origin.flavorNotes,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.deepGreen,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Story
          Text('The Story', style: AppTextStyles.h5),
          const SizedBox(height: 8),
          Text(
            origin.story,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
          ),
          const SizedBox(height: 16),

          // Details row
          Row(
            children: [
              Expanded(
                child: _DetailChip(
                    icon: '⛰️',
                    label: 'Altitude',
                    value: origin.altitude),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DetailChip(
                    icon: '🌱',
                    label: 'Process',
                    value: origin.process),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _DetailChip(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall),
                Text(value,
                    style: AppTextStyles.labelLarge.copyWith(
                        fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Brewing Tab ──────────────────────────────────────────────────────────────

class _BrewingTab extends StatelessWidget {
  final dynamic brewing;
  const _BrewingTab({required this.brewing});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Method header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.freshGreen.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
              border: Border.all(
                  color: AppColors.freshGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('⚗️', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Method', style: AppTextStyles.bodySmall),
                      Text(brewing.method, style: AppTextStyles.h4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text('How It\'s Made', style: AppTextStyles.h5),
          const SizedBox(height: 8),
          Text(
            brewing.description,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.7),
          ),
          const SizedBox(height: 16),

          // Brew time + temp
          Row(
            children: [
              Expanded(
                child: _DetailChip(
                  icon: '⏱️',
                  label: 'Brew Time',
                  value: brewing.brewTime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DetailChip(
                  icon: '🌡️',
                  label: 'Temperature',
                  value: brewing.temperature,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── No Data Placeholder ──────────────────────────────────────────────────────

class _NoDataTab extends StatelessWidget {
  final String message;
  const _NoDataTab({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.mediumGrey)),
          ],
        ),
      ),
    );
  }
}
