// ─── Menu Screen ──────────────────────────────────────────────────────────────
// Redesigned with BrewBuddy logo, location, search, category chips,
// section header, drink grid, and sticky cart indicator.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drink_model.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../models/customization_model.dart';
import '../theme/app_theme.dart';
import '../widgets/drink_card.dart';
import 'cart_screen.dart';
import 'drink_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Category name mappings for section headers
  static const Map<DrinkCategory, String> _categoryTitles = {
    DrinkCategory.hotCoffee: 'Hot Classics & Handcrafted Espresso',
    DrinkCategory.coldCoffee: 'Chilled to Perfection',
    DrinkCategory.cappuccino: 'Blended Indulgence',
    DrinkCategory.tea: 'Tea & Herbal Blends',
    DrinkCategory.seasonal: 'Limited Time Specials',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Generate a deterministic rating from drink ID
  double _getRatingForDrink(String drinkId) {
    final hash = drinkId.hashCode % 50;
    return 4.5 + (hash / 100);
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final cartProvider = context.watch<CartProvider>();

    // When searching, show results across all categories
    final drinks = menuProvider.isSearching
        ? menuProvider.searchResults
        : menuProvider.filteredDrinks;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // ── Main scrollable content ──
          CustomScrollView(
            slivers: [
              // Search bar
              SliverToBoxAdapter(
                child: _buildSearchBar(menuProvider),
              ),

              // Category tabs (hidden when searching)
              if (!menuProvider.isSearching)
                SliverToBoxAdapter(
                  child: _buildCategoryTabs(menuProvider),
                ),

              // Section header (hidden when searching)
              if (!menuProvider.isSearching && drinks.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    menuProvider.selectedCategory,
                    drinks.length,
                  ),
                ),

              // Drinks grid or empty state
              if (drinks.isEmpty)
                SliverFillRemaining(
                  child: _EmptyState(isSearching: menuProvider.isSearching),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final drink = drinks[index];
                        return DrinkCard(
                          drink: drink,
                          rating: _getRatingForDrink(drink.id),
                          onTap: () {
                            menuProvider.selectDrink(drink);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DrinkDetailScreen(),
                              ),
                            );
                          },
                          onAdd: () {
                            cartProvider.addItem(
                                drink, const CustomizationModel());
                          },
                        );
                      },
                      childCount: drinks.length,
                    ),
                  ),
                ),
            ],
          ),

          // ── Sticky cart indicator (bottom) ──
          if (cartProvider.itemCount > 0)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildStickyCartBar(context, cartProvider),
            ),
        ],
      ),
    );
  }

  /// Custom AppBar with logo, location, and actions
  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        backgroundColor: AppColors.deepGreen,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            // Left: Logo + BrewBuddy + MENU
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.coffee, color: AppColors.white, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'BrewBuddy',
                      style: AppTextStyles.appBarTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '· MENU',
                      style: AppTextStyles.appBarTitle
                          .copyWith(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                // Location row
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Indranagar 100ft Rd',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.expand_more,
                        color: AppColors.white, size: 14),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Notification bell
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.white, size: 22),
            onPressed: () {},
          ),
          // Profile avatar
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: AppColors.freshGreen,
              radius: 16,
              child: Icon(Icons.person,
                  color: AppColors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  /// Search bar widget
  Widget _buildSearchBar(MenuProvider menuProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: menuProvider.setSearch,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search drinks, roasts, treats...',
          prefixIcon:
              const Icon(Icons.search, color: AppColors.mediumGrey, size: 20),
          suffixIcon: menuProvider.isSearching
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    menuProvider.clearSearch();
                  },
                  child: const Icon(Icons.close,
                      color: AppColors.mediumGrey, size: 20),
                )
              : const Icon(Icons.tune, color: AppColors.mediumGrey, size: 20),
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDimensions.cornerRadiusPill),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// Category chips row
  Widget _buildCategoryTabs(MenuProvider menuProvider) {
    final categories = [
      DrinkCategory.hotCoffee,
      DrinkCategory.coldCoffee,
      DrinkCategory.cappuccino,
      DrinkCategory.tea,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map((category) {
                final isSelected =
                    menuProvider.selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => menuProvider.selectCategory(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.freshGreen
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.cornerRadiusPill),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                )
                              ],
                      ),
                      child: Text(
                        category.displayName,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.darkText,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              })
              .toList(),
        ),
      ),
    );
  }

  /// Section header with category title, subtitle, and item count
  Widget _buildSectionHeader(
      DrinkCategory category, int itemCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _categoryTitles[category] ?? 'Beverages',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ethically sourced from estates in Coorg and Araku Valley',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mediumGrey,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.freshGreen.withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadiusPill),
            ),
            child: Text(
              '$itemCount items',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.freshGreen,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Sticky cart indicator bar
  Widget _buildStickyCartBar(
      BuildContext context, CartProvider cartProvider) {
    final itemLabel = cartProvider.itemCount > 1 ? 'items' : 'item';
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.deepGreen,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadiusPill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          ),
          borderRadius:
              BorderRadius.circular(AppDimensions.cornerRadiusPill),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: icon, item count, total
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        color: AppColors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${cartProvider.itemCount} $itemLabel',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.white,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      ' · ₹${cartProvider.total.toStringAsFixed(0)}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                // Right: View Cart arrow
                Row(
                  children: [
                    Text(
                      'View Cart',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.caramelGold,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward,
                        color: AppColors.caramelGold, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isSearching;
  const _EmptyState({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isSearching ? '🔍' : '☕',
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'No drinks found'
                : 'No drinks in this category',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 8),
          Text(
            isSearching
                ? 'Try a different search term'
                : 'More coming soon!',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.mediumGrey),
          ),
        ],
      ),
    );
  }
}
