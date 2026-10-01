// ─── Cart Provider ────────────────────────────────────────────────────────────
// Manages cart state, happy-hour discounts, order placement, and pickup times.

import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/customization_model.dart';
import '../models/drink_model.dart';
import '../models/order_model.dart';

class CartProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  final List<CartItemModel> _items = [];
  String _selectedPickupTime = '';
  OrderModel? _lastOrder;

  // ── Getters ────────────────────────────────────────────────────────────────

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  String get selectedPickupTime => _selectedPickupTime;

  OrderModel? get lastOrder => _lastOrder;

  /// Subtotal before any discounts
  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.lineTotal);

  /// Whether happy hour (4 PM – 7 PM) is active right now
  bool get isHappyHour {
    final now = DateTime.now();
    return now.hour >= 16 && now.hour < 19;
  }

  /// 15% discount during happy hour, else 0
  double get discount => isHappyHour ? subtotal * 0.15 : 0.0;

  /// Final order total
  double get total => subtotal - discount;

  /// Stars earned for this order (1 star per ₹50 spent)
  int get starsToEarn => OrderModel.calculateStars(total);

  /// Pickup time slots — every 15 min from now + 10 min buffer, for 2 hours
  List<String> get pickupTimeSlots {
    final slots = <String>[];
    final now = DateTime.now();
    // Add 10-minute buffer before first slot
    var start = now.add(const Duration(minutes: 10));
    // Round up to next 15-min boundary
    final remainder = start.minute % 15;
    if (remainder != 0) {
      start = start.add(Duration(minutes: 15 - remainder));
    }

    for (int i = 0; i < 8; i++) {
      final slot = start.add(Duration(minutes: 15 * i));
      final hour = slot.hour;
      final minute = slot.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      slots.add('$displayHour:$minute $period');
    }
    return slots;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  /// Add a drink to the cart with its customization
  void addItem(DrinkModel drink, CustomizationModel customization) {
    // Generate a unique cart item ID
    final cartItemId =
        '${drink.id}_${DateTime.now().millisecondsSinceEpoch}';

    _items.add(CartItemModel(
      cartItemId: cartItemId,
      drink: drink,
      customization: customization,
    ));

    // Auto-select the first pickup slot if none chosen
    if (_selectedPickupTime.isEmpty) {
      final slots = pickupTimeSlots;
      if (slots.isNotEmpty) _selectedPickupTime = slots.first;
    }

    notifyListeners();
  }

  /// Increment quantity of a cart item
  void incrementQuantity(String cartItemId) {
    final index = _items.indexWhere((i) => i.cartItemId == cartItemId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  /// Decrement quantity — removes item if quantity reaches 0
  void decrementQuantity(String cartItemId) {
    final index = _items.indexWhere((i) => i.cartItemId == cartItemId);
    if (index != -1) {
      if (_items[index].quantity <= 1) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
      }
      notifyListeners();
    }
  }

  /// Remove a cart item entirely
  void removeItem(String cartItemId) {
    _items.removeWhere((i) => i.cartItemId == cartItemId);
    notifyListeners();
  }

  /// Set the chosen pickup time slot
  void setPickupTime(String time) {
    _selectedPickupTime = time;
    notifyListeners();
  }

  /// Place the order — returns the created OrderModel
  OrderModel placeOrder(String storeName) {
    final order = OrderModel(
      orderId: 'BB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(_items),
      subtotal: subtotal,
      discount: discount,
      total: total,
      starsEarned: starsToEarn,
      pickupTime: _selectedPickupTime,
      storeName: storeName,
      placedAt: DateTime.now(),
    );

    _lastOrder = order;
    _items.clear();
    _selectedPickupTime = '';
    notifyListeners();
    return order;
  }

  /// Clear the cart
  void clearCart() {
    _items.clear();
    _selectedPickupTime = '';
    notifyListeners();
  }
}
