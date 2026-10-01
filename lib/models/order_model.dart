// ─── Order Model ──────────────────────────────────────────────────────────────
// Represents a placed order, used on the confirmation screen.

import 'cart_item_model.dart';

class OrderModel {
  final String orderId;
  final List<CartItemModel> items;
  final double subtotal;
  final double discount;     // happy-hour or other discounts
  final double total;
  final int starsEarned;
  final String pickupTime;
  final String storeName;
  final DateTime placedAt;

  const OrderModel({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.starsEarned,
    required this.pickupTime,
    required this.storeName,
    required this.placedAt,
  });

  /// Stars earned = 1 star per ₹50 spent
  static int calculateStars(double total) => (total / 50).floor();
}
