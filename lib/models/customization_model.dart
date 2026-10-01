// ─── Customization Model ──────────────────────────────────────────────────────
// Holds all user-selected options when customizing a drink.

/// Milk type options with price delta
enum MilkType {
  whole,
  oat,
  almond,
  soy,
}

extension MilkTypeExtension on MilkType {
  String get displayName {
    switch (this) {
      case MilkType.whole:
        return 'Whole Milk';
      case MilkType.oat:
        return 'Oat Milk';
      case MilkType.almond:
        return 'Almond Milk';
      case MilkType.soy:
        return 'Soy Milk';
    }
  }

  /// Extra price in INR for non-standard milk
  double get extraPrice {
    switch (this) {
      case MilkType.whole:
        return 0.0;
      case MilkType.oat:
        return 30.0;
      case MilkType.almond:
        return 40.0;
      case MilkType.soy:
        return 30.0;
    }
  }
}

/// Syrup flavors available
enum SyrupFlavor {
  vanilla,
  caramel,
  hazelnut,
  classic,
  cinnamon,
  mocha,
}

extension SyrupFlavorExtension on SyrupFlavor {
  String get displayName {
    switch (this) {
      case SyrupFlavor.vanilla:
        return 'Vanilla';
      case SyrupFlavor.caramel:
        return 'Caramel';
      case SyrupFlavor.hazelnut:
        return 'Hazelnut';
      case SyrupFlavor.classic:
        return 'Classic';
      case SyrupFlavor.cinnamon:
        return 'Cinnamon';
      case SyrupFlavor.mocha:
        return 'Mocha';
    }
  }
}

/// Full customization state for a drink
class CustomizationModel {
  final MilkType milkType;
  final int espressoShots; // 1 – 4
  final int syrupPumps;    // 0 – 6
  final SyrupFlavor syrupFlavor;
  final String temperature; // 'Hot', 'Warm', 'Iced'

  const CustomizationModel({
    this.milkType = MilkType.whole,
    this.espressoShots = 2,
    this.syrupPumps = 0,
    this.syrupFlavor = SyrupFlavor.vanilla,
    this.temperature = 'Hot',
  });

  /// Price delta from customization extras (over base drink price)
  double get extraPrice {
    double extra = milkType.extraPrice;
    // Each extra shot costs ₹20
    extra += (espressoShots - 2).clamp(0, 2) * 20.0;
    // Each syrup pump costs ₹15
    extra += syrupPumps * 15.0;
    return extra;
  }

  /// Human-readable summary list for cart display
  List<String> get summaryLines {
    final lines = <String>[
      milkType.displayName,
      '$espressoShots Espresso Shot${espressoShots > 1 ? 's' : ''}',
      if (syrupPumps > 0)
        '$syrupPumps pump${syrupPumps > 1 ? 's' : ''} ${syrupFlavor.displayName}',
      temperature,
    ];
    return lines;
  }

  CustomizationModel copyWith({
    MilkType? milkType,
    int? espressoShots,
    int? syrupPumps,
    SyrupFlavor? syrupFlavor,
    String? temperature,
  }) {
    return CustomizationModel(
      milkType: milkType ?? this.milkType,
      espressoShots: espressoShots ?? this.espressoShots,
      syrupPumps: syrupPumps ?? this.syrupPumps,
      syrupFlavor: syrupFlavor ?? this.syrupFlavor,
      temperature: temperature ?? this.temperature,
    );
  }
}
