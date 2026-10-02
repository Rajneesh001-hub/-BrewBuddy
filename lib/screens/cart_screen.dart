// ─── Cart & Pickup Screen ─────────────────────────────────────────────────────
// Cart items with quantity controls, pickup time slots, happy-hour discount,
// stars-to-earn display, order total, and Place Order CTA.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/time_slot_chip.dart';
import 'order_confirmation_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        title: Text(
          'My Cart (${cartProvider.itemCount})',
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: cartProvider.items.isEmpty
          ? _EmptyCart(
              onBrowse: () => Navigator.pop(context),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Cart Items ──────────────────────────────────
                        Text('Your Order', style: AppTextStyles.sectionTitle),
                        const SizedBox(height: 12),
                        ...cartProvider.items.map(
                          (item) => _CartItemCard(
                            item: item,
                            onIncrement: () => cartProvider
                                .incrementQuantity(item.cartItemId),
                            onDecrement: () => cartProvider
                                .decrementQuantity(item.cartItemId),
                            onRemove: () =>
                                cartProvider.removeItem(item.cartItemId),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Happy Hour Banner ───────────────────────────
                        if (cartProvider.isHappyHour) ...[
                          _HappyHourDiscountBanner(
                              discount: cartProvider.discount),
                          const SizedBox(height: 16),
                        ],

                        // ── Pickup Time ─────────────────────────────────
                        Text('Pickup Time', style: AppTextStyles.sectionTitle),
                        const SizedBox(height: 4),
                        Text(
                          'Select your preferred pickup time',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: cartProvider.pickupTimeSlots
                              .map(
                                (slot) => TimeSlotChip(
                                  time: slot,
                                  isSelected:
                                      cartProvider.selectedPickupTime ==
                                          slot,
                                  onTap: () =>
                                      cartProvider.setPickupTime(slot),
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 20),

                        // ── Order Summary ───────────────────────────────
                        _OrderSummaryCard(
                          subtotal: cartProvider.subtotal,
                          discount: cartProvider.discount,
                          total: cartProvider.total,
                          isHappyHour: cartProvider.isHappyHour,
                          starsToEarn: cartProvider.starsToEarn,
                          currentStars: userProvider.stars,
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                // ── Sticky Place Order button ───────────────────────────
                _PlaceOrderBar(
                  total: cartProvider.total,
                  pickupTime: cartProvider.selectedPickupTime,
                  isReady: cartProvider.selectedPickupTime.isNotEmpty,
                  onPlace: () {
                    final order =
                        cartProvider.placeOrder('BrewBuddy MG Road');
                    userProvider.addStars(order.starsEarned);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OrderConfirmationScreen(order: order),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}

// ─── Cart Item Card ───────────────────────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.card,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadius),
            ),
            child: Center(
              child: Text(
                item.drink.imageUrl,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.drink.name, style: AppTextStyles.h5),
                const SizedBox(height: 4),
                // Customization summary
                ...item.customization.summaryLines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      '· $line',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${item.unitPrice.toStringAsFixed(0)} each',
                      style: AppTextStyles.priceSmall,
                    ),
                    const Spacer(),
                    // Quantity controls
                    _QuantityControl(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(
                Icons.delete_outline,
                color: AppColors.errorRed.withValues(alpha: 0.7),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quantity Control ─────────────────────────────────────────────────────────

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControl({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QBtn(icon: Icons.remove, onTap: onDecrement),
        Container(
          width: 32,
          alignment: Alignment.center,
          child: Text('$quantity', style: AppTextStyles.labelLarge),
        ),
        _QBtn(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.deepGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: AppColors.white),
      ),
    );
  }
}

// ─── Happy Hour Discount Banner ───────────────────────────────────────────────

class _HappyHourDiscountBanner extends StatelessWidget {
  final double discount;
  const _HappyHourDiscountBanner({required this.discount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.freshGreen.withValues(alpha: 0.12),
        borderRadius:
            BorderRadius.circular(AppDimensions.cornerRadius),
        border: Border.all(
            color: AppColors.freshGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Happy Hour Discount Applied!',
                  style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.freshGreen),
                ),
                Text(
                  '15% off all beverages (4 PM – 7 PM)',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '-₹${discount.toStringAsFixed(0)}',
            style: AppTextStyles.price,
          ),
        ],
      ),
    );
  }
}

// ─── Order Summary Card ───────────────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double total;
  final bool isHappyHour;
  final int starsToEarn;
  final int currentStars;

  const _OrderSummaryCard({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.isHappyHour,
    required this.starsToEarn,
    required this.currentStars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTextStyles.h5),
          const SizedBox(height: 12),
          _SummaryRow(
              label: 'Subtotal',
              value: '₹${subtotal.toStringAsFixed(0)}'),
          if (isHappyHour)
            _SummaryRow(
              label: 'Happy Hour (15%)',
              value: '-₹${discount.toStringAsFixed(0)}',
              valueColor: AppColors.freshGreen,
            ),
          const Divider(height: 20, color: AppColors.lightGrey),
          _SummaryRow(
            label: 'Total',
            value: '₹${total.toStringAsFixed(0)}',
            isBold: true,
          ),
          const SizedBox(height: 12),
          // Stars to earn
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.goldLight,
              borderRadius:
                  BorderRadius.circular(AppDimensions.cornerRadiusSmall),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: AppColors.caramelGold, size: 18),
                const SizedBox(width: 8),
                Text(
                  'You\'ll earn $starsToEarn Stars with this order',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.deepGreen,
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.labelLarge
                : AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.mediumGrey),
          ),
          const Spacer(),
          Text(
            value,
            style: isBold
                ? AppTextStyles.h4.copyWith(color: AppColors.freshGreen)
                : AppTextStyles.labelMedium.copyWith(
                    color: valueColor ?? AppColors.darkText),
          ),
        ],
      ),
    );
  }
}

// ─── Place Order Bar ──────────────────────────────────────────────────────────

class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final String pickupTime;
  final bool isReady;
  final VoidCallback onPlace;

  const _PlaceOrderBar({
    required this.total,
    required this.pickupTime,
    required this.isReady,
    required this.onPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (pickupTime.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.schedule,
                    size: 14, color: AppColors.mediumGrey),
                const SizedBox(width: 4),
                Text(
                  'Pickup at $pickupTime',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          ElevatedButton(
            onPressed: isReady ? onPlace : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: isReady
                  ? AppColors.freshGreen
                  : AppColors.mediumGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    AppDimensions.cornerRadiusPill),
              ),
            ),
            child: Text(
              isReady
                  ? 'Place Order  ·  ₹${total.toStringAsFixed(0)}'
                  : 'Select Pickup Time',
              style: AppTextStyles.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty Cart ───────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  final VoidCallback onBrowse;
  const _EmptyCart({required this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🛍️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            Text('Your cart is empty', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Add some drinks from the menu\nto get started!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.mediumGrey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onBrowse,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 52),
              ),
              child: const Text('Browse Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
