// ─── Customization Screen ─────────────────────────────────────────────────────
// Milk type, espresso shots, syrup pumps + flavor, temperature.
// Live price updates as options change. "Add to Cart" at the bottom.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/customization_model.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/customization_row.dart';
import 'cart_screen.dart';

class CustomizationScreen extends StatelessWidget {
  const CustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final cartProvider = context.watch<CartProvider>();
    final drink = menuProvider.selectedDrink;
    final custom = menuProvider.currentCustomization;

    if (drink == null) {
      return const Scaffold(body: Center(child: Text('No drink selected')));
    }

    final unitPrice = drink.basePrice + custom.extraPrice;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        title: Text('Customize ${drink.name}'),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Column(
        children: [
          // ── Scrollable options ──────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Drink summary header ──
                  _DrinkSummaryHeader(
                    emoji: drink.imageUrl,
                    name: drink.name,
                    basePrice: drink.basePrice,
                    customization: custom,
                    livePrice: unitPrice,
                  ),

                  const SizedBox(height: 20),
                  _sectionDivider('Milk Type'),
                  const SizedBox(height: 12),

                  // ── Milk type ──
                  CustomizationOptionRow(
                    label: 'Choose Milk',
                    options: MilkType.values
                        .map((m) => m.displayName)
                        .toList(),
                    selected: custom.milkType.displayName,
                    onChanged: (val) {
                      final milk = MilkType.values.firstWhere(
                          (m) => m.displayName == val);
                      menuProvider.updateMilkType(milk);
                    },
                    subtitles: {
                      MilkType.whole.displayName: 'Included',
                      MilkType.oat.displayName: '+₹30',
                      MilkType.almond.displayName: '+₹40',
                      MilkType.soy.displayName: '+₹30',
                    },
                  ),

                  const SizedBox(height: 20),
                  _sectionDivider('Espresso'),
                  const SizedBox(height: 16),

                  // ── Espresso shots ──
                  CustomizationStepper(
                    label: 'Espresso Shots',
                    subtitle: custom.espressoShots > 2
                        ? '+₹${((custom.espressoShots - 2) * 20).toStringAsFixed(0)} extra'
                        : 'Standard: 2 shots included',
                    value: custom.espressoShots,
                    min: 1,
                    max: 4,
                    onChanged: menuProvider.updateShots,
                  ),

                  const SizedBox(height: 20),
                  _sectionDivider('Syrup'),
                  const SizedBox(height: 16),

                  // ── Syrup pumps ──
                  CustomizationStepper(
                    label: 'Syrup Pumps',
                    subtitle: custom.syrupPumps > 0
                        ? '+₹${(custom.syrupPumps * 15).toStringAsFixed(0)} (₹15 per pump)'
                        : 'No syrup (₹15 per pump)',
                    value: custom.syrupPumps,
                    min: 0,
                    max: 6,
                    onChanged: menuProvider.updateSyrupPumps,
                  ),

                  // ── Syrup flavor (show only if pumps > 0) ──
                  if (custom.syrupPumps > 0) ...[
                    const SizedBox(height: 16),
                    CustomizationOptionRow(
                      label: 'Syrup Flavor',
                      options: SyrupFlavor.values
                          .map((s) => s.displayName)
                          .toList(),
                      selected: custom.syrupFlavor.displayName,
                      onChanged: (val) {
                        final flavor = SyrupFlavor.values.firstWhere(
                            (s) => s.displayName == val);
                        menuProvider.updateSyrupFlavor(flavor);
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  _sectionDivider('Temperature'),
                  const SizedBox(height: 12),

                  // ── Temperature ──
                  CustomizationOptionRow(
                    label: 'Serve Temperature',
                    options: drink.availableTemperatures,
                    selected: custom.temperature,
                    onChanged: menuProvider.updateTemperature,
                  ),

                  const SizedBox(height: 16),

                  // ── Customization summary ──
                  _CustomizationSummary(
                    customization: custom,
                    basePrice: drink.basePrice,
                    livePrice: unitPrice,
                  ),

                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),

          // ── Sticky bottom bar ───────────────────────────────────────────
          _BottomAddBar(
            price: unitPrice,
            onAdd: () {
              cartProvider.addItem(drink, custom);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${drink.name} added to cart!'),
                  backgroundColor: AppColors.freshGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              // Pop back to menu, then show cart
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionDivider(String label) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.sectionTitle),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: AppColors.lightGrey)),
      ],
    );
  }
}

// ─── Drink Summary Header ─────────────────────────────────────────────────────

class _DrinkSummaryHeader extends StatelessWidget {
  final String emoji;
  final String name;
  final double basePrice;
  final CustomizationModel customization;
  final double livePrice;

  const _DrinkSummaryHeader({
    required this.emoji,
    required this.name,
    required this.basePrice,
    required this.customization,
    required this.livePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card,
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(
                  customization.summaryLines.join(' · '),
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Live price
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              '₹${livePrice.toStringAsFixed(0)}',
              key: ValueKey(livePrice),
              style: AppTextStyles.h3
                  .copyWith(color: AppColors.freshGreen),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Customization Summary Card ───────────────────────────────────────────────

class _CustomizationSummary extends StatelessWidget {
  final CustomizationModel customization;
  final double basePrice;
  final double livePrice;

  const _CustomizationSummary({
    required this.customization,
    required this.basePrice,
    required this.livePrice,
  });

  @override
  Widget build(BuildContext context) {
    final extras = customization.extraPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Breakdown', style: AppTextStyles.h5),
          const SizedBox(height: 10),
          _PriceRow(
              label: 'Base price',
              value: '₹${basePrice.toStringAsFixed(0)}'),
          if (customization.milkType.extraPrice > 0)
            _PriceRow(
              label: '${customization.milkType.displayName} upgrade',
              value:
                  '+₹${customization.milkType.extraPrice.toStringAsFixed(0)}',
            ),
          if (customization.espressoShots > 2)
            _PriceRow(
              label:
                  'Extra ${customization.espressoShots - 2} shot(s)',
              value:
                  '+₹${((customization.espressoShots - 2) * 20).toStringAsFixed(0)}',
            ),
          if (customization.syrupPumps > 0)
            _PriceRow(
              label:
                  '${customization.syrupPumps} ${customization.syrupFlavor.displayName} pump(s)',
              value:
                  '+₹${(customization.syrupPumps * 15).toStringAsFixed(0)}',
            ),
          const Divider(height: 16, color: AppColors.lightGrey),
          Row(
            children: [
              Text('Total', style: AppTextStyles.labelLarge),
              const Spacer(),
              Text(
                '₹${livePrice.toStringAsFixed(0)}',
                style:
                    AppTextStyles.price.copyWith(fontSize: 18),
              ),
            ],
          ),
          if (extras == 0) ...[
            const SizedBox(height: 4),
            Text(
              'No extras added',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.mediumGrey)),
          const Spacer(),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}

// ─── Bottom Add to Cart Bar ───────────────────────────────────────────────────

class _BottomAddBar extends StatelessWidget {
  final double price;
  final VoidCallback onAdd;

  const _BottomAddBar({required this.price, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total', style: AppTextStyles.bodySmall),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  '₹${price.toStringAsFixed(0)}',
                  key: ValueKey(price),
                  style: AppTextStyles.h3
                      .copyWith(color: AppColors.freshGreen),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppDimensions.cornerRadiusPill),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
