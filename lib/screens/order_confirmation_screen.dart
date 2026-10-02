// ─── Order Confirmation Screen ────────────────────────────────────────────────
// Shows order number, pickup time, store, QR code for pickup, and stars earned.

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/order_model.dart';
import '../theme/app_theme.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.deepGreen,
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          children: [
            // ── Success animation / header ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: AppDecorations.deepGreenGradient,
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.freshGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 3),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Order Placed!',
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'We\'re preparing your order',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Order details card ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.card,
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.tag,
                    label: 'Order Number',
                    value: '#${order.orderId}',
                    valueBold: true,
                  ),
                  const Divider(height: 20, color: AppColors.lightGrey),
                  _DetailRow(
                    icon: Icons.store_outlined,
                    label: 'Store',
                    value: order.storeName,
                  ),
                  const Divider(height: 20, color: AppColors.lightGrey),
                  _DetailRow(
                    icon: Icons.schedule,
                    label: 'Pickup Time',
                    value: order.pickupTime,
                    valueBold: true,
                  ),
                  const Divider(height: 20, color: AppColors.lightGrey),
                  _DetailRow(
                    icon: Icons.receipt_outlined,
                    label: 'Order Total',
                    value: '₹${order.total.toStringAsFixed(0)}',
                    valueBold: true,
                    valueColor: AppColors.freshGreen,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Stars earned ─────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                borderRadius:
                    BorderRadius.circular(AppDimensions.cornerRadius),
                border: Border.all(
                    color: AppColors.caramelGold.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Text('⭐', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stars Earned!',
                          style: AppTextStyles.h5.copyWith(
                              color: AppColors.deepGreen),
                        ),
                        Text(
                          'You earned ${order.starsEarned} Stars with this order',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.caramelGold,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cornerRadiusPill),
                    ),
                    child: Text(
                      '+${order.starsEarned}',
                      style: AppTextStyles.h4.copyWith(
                          color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── QR Code for pickup ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.card,
              child: Column(
                children: [
                  Text(
                    'Show this QR at pickup',
                    style: AppTextStyles.h5,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our barista will scan this to prepare your order',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  // QR code
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          AppDimensions.cornerRadius),
                      border:
                          Border.all(color: AppColors.lightGrey),
                    ),
                    child: QrImageView(
                      data: 'BREWBUDDY:${order.orderId}:${order.pickupTime}',
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                      errorStateBuilder: (context, err) => const Center(
                        child: Text(
                          'QR Error',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Order #${order.orderId}',
                    style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.mediumGrey,
                        letterSpacing: 1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Items ordered summary ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Items Ordered', style: AppTextStyles.h5),
                  const SizedBox(height: 12),
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            item.drink.imageUrl,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(item.drink.name,
                                    style: AppTextStyles.labelLarge),
                                Text(
                                  item.customization.summaryLines
                                      .join(' · '),
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '×${item.quantity}',
                            style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.mediumGrey),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${item.lineTotal.toStringAsFixed(0)}',
                            style: AppTextStyles.priceSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Done button ──────────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: () {
                // Pop all screens back to root
                Navigator.of(context)
                    .popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.home_outlined, size: 18),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      AppDimensions.cornerRadiusPill),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool valueBold;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mediumGrey),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.mediumGrey),
        ),
        const Spacer(),
        Text(
          value,
          style: valueBold
              ? AppTextStyles.labelLarge.copyWith(
                  color: valueColor ?? AppColors.deepGreen)
              : AppTextStyles.bodyMedium.copyWith(
                  color: valueColor ?? AppColors.darkText),
        ),
      ],
    );
  }
}
