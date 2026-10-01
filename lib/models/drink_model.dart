// ─── Drink Model ──────────────────────────────────────────────────────────────
// Represents a single beverage item in the menu.

/// Drink categories available in the menu
enum DrinkCategory {
  hotCoffee,
  coldCoffee,
  frappuccino,
  tea,
  seasonal,
}

extension DrinkCategoryExtension on DrinkCategory {
  String get displayName {
    switch (this) {
      case DrinkCategory.hotCoffee:
        return 'Hot Coffee';
      case DrinkCategory.coldCoffee:
        return 'Cold Coffee';
      case DrinkCategory.frappuccino:
        return 'Frappuccino';
      case DrinkCategory.tea:
        return 'Tea';
      case DrinkCategory.seasonal:
        return 'Seasonal';
    }
  }
}

/// Nutritional information for a drink
class NutritionInfo {
  final int calories;
  final int caffeineMg;
  final double sugarG;
  final double fatG;
  final double proteinG;

  const NutritionInfo({
    required this.calories,
    required this.caffeineMg,
    required this.sugarG,
    required this.fatG,
    required this.proteinG,
  });
}

/// Origin story for single-origin coffees
class OriginInfo {
  final String region;
  final String country;
  final String flavorNotes;
  final String story;
  final String altitude;
  final String process;

  const OriginInfo({
    required this.region,
    required this.country,
    required this.flavorNotes,
    required this.story,
    required this.altitude,
    required this.process,
  });
}

/// Brewing method details
class BrewingInfo {
  final String method;
  final String description;
  final String brewTime;
  final String temperature;

  const BrewingInfo({
    required this.method,
    required this.description,
    required this.brewTime,
    required this.temperature,
  });
}

/// Main drink model
class DrinkModel {
  final String id;
  final String name;
  final String description;
  final double basePrice; // in INR
  final DrinkCategory category;
  final String imageUrl; // emoji fallback or network URL
  final bool isLimitedTime;
  final bool isBestseller;
  final NutritionInfo nutrition;
  final OriginInfo? origin; // nullable — not all drinks have origin stories
  final BrewingInfo brewing;
  final List<String> availableTemperatures; // 'Hot', 'Warm', 'Iced'

  const DrinkModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.category,
    required this.imageUrl,
    this.isLimitedTime = false,
    this.isBestseller = false,
    required this.nutrition,
    this.origin,
    required this.brewing,
    this.availableTemperatures = const ['Hot', 'Iced'],
  });
}
