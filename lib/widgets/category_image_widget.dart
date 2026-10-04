// ─── Category Image Widget ──────────────────────────────────────────────────────
// Displays category-specific images based on drink category
// Maps each category to an appropriate emoji/icon for fast rendering

import 'package:flutter/material.dart';
import '../models/drink_model.dart';

class CategoryImageWidget extends StatelessWidget {
  final DrinkCategory category;
  final double width;
  final double height;
  final BoxFit fit;

  const CategoryImageWidget({
    super.key,
    required this.category,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  /// Get emoji and color for each category
  Map<String, dynamic> _getCategoryStyle(DrinkCategory category) {
    switch (category) {
      case DrinkCategory.hotCoffee:
        return {
          'emoji': '☕',
          'color': const Color(0xFF6F4E37), // Rich brown
          'label': 'Hot Coffee'
        };
      case DrinkCategory.coldCoffee:
        return {
          'emoji': '🧊',
          'color': const Color(0xFF8B6F47), // Medium brown
          'label': 'Cold Coffee'
        };
      case DrinkCategory.cappuccino:
        return {
          'emoji': '🧋',
          'color': const Color(0xFFA0826D), // Lighter brown
          'label': 'Cappuccino'
        };
      case DrinkCategory.tea:
        return {
          'emoji': '🫖',
          'color': const Color(0xFF8B7355), // Tea brown
          'label': 'Tea'
        };
      case DrinkCategory.seasonal:
        return {
          'emoji': '❄️',
          'color': const Color(0xFF7A5C3C), // Dark brown
          'label': 'Seasonal'
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(category);
    final emoji = style['emoji'] as String;
    final color = style['color'] as Color;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(
            fontSize: 80,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black26,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
