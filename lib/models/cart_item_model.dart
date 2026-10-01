// ─── Cart Item Model ──────────────────────────────────────────────────────────
// Represents a single line-item in the cart, combining a drink + customization.

import 'drink_model.dart';
import 'customization_model.dart';

class CartItemModel {
  final String cartItemId; // unique ID for this cart entry
  final DrinkModel drink;
  final CustomizationModel customization;
  int quantity;

  CartItemModel({
    required this.cartItemId,
    required this.drink,
    required this.customization,
    this.quantity = 1,
  });

  /// Total price for this line item (base + extras × quantity)
  double get lineTotal =>
      (drink.basePrice + customization.extraPrice) * quantity;

  /// Price per single item
  double get unitPrice => drink.basePrice + customization.extraPrice;

  CartItemModel copyWith({
    DrinkModel? drink,
    CustomizationModel? customization,
    int? quantity,
  }) {
    return CartItemModel(
      cartItemId: cartItemId,
      drink: drink ?? this.drink,
      customization: customization ?? this.customization,
      quantity: quantity ?? this.quantity,
    );
  }
}
