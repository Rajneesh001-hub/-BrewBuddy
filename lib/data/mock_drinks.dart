// ─── Mock Drinks Data ─────────────────────────────────────────────────────────
// All drink data for the menu. No backend required.

import '../models/drink_model.dart';

final List<DrinkModel> mockDrinks = [
  // ── HOT COFFEE ──────────────────────────────────────────────────────────────

  DrinkModel(
    id: 'hc_001',
    name: 'Caffè Americano',
    description:
        'Espresso shots topped with hot water to create a light layer of crema.',
    basePrice: 295,
    category: DrinkCategory.hotCoffee,
    imageUrl: '☕',
    isBestseller: true,
    nutrition: const NutritionInfo(
      calories: 15,
      caffeineMg: 225,
      sugarG: 0,
      fatG: 0,
      proteinG: 1,
    ),
    origin: const OriginInfo(
      region: 'Coorg',
      country: 'India',
      flavorNotes: 'Dark chocolate, cedar, smoky finish',
      story:
          'Sourced from the misty hills of Coorg, Karnataka — India\'s coffee country. '
          'These beans are grown at 1,100–1,500 m altitude, shade-grown under silver oak trees, '
          'and wet-processed to highlight their clean, bright character.',
      altitude: '1,100 – 1,500 m',
      process: 'Washed',
    ),
    brewing: const BrewingInfo(
      method: 'Espresso + Hot Water',
      description:
          'Two shots of full-bodied espresso are pulled at 9 bar pressure, '
          'then combined with hot water (around 90 °C) to mellow the intensity. '
          'The result is smooth, full, and never bitter.',
      brewTime: '25–30 sec',
      temperature: '88–92 °C',
    ),
    availableTemperatures: ['Hot', 'Iced'],
  ),

  DrinkModel(
    id: 'hc_002',
    name: 'Cappuccino',
    description:
        'Dark, rich espresso lying beneath a thick layer of textured microfoam.',
    basePrice: 345,
    category: DrinkCategory.hotCoffee,
    imageUrl: '☕',
    isBestseller: true,
    nutrition: const NutritionInfo(
      calories: 120,
      caffeineMg: 150,
      sugarG: 10,
      fatG: 4,
      proteinG: 6,
    ),
    brewing: const BrewingInfo(
      method: 'Espresso + Steamed Milk Foam',
      description:
          'A double shot of espresso is topped with equal parts steamed milk and thick, '
          'velvety microfoam. The foam is aerated to a dense, creamy texture — '
          'hallmark of a true Italian-style cappuccino.',
      brewTime: '30–35 sec',
      temperature: '65–70 °C',
    ),
    availableTemperatures: ['Hot'],
  ),

  DrinkModel(
    id: 'hc_003',
    name: 'Caffè Latte',
    description: 'Rich espresso with steamed milk and a light layer of foam.',
    basePrice: 375,
    category: DrinkCategory.hotCoffee,
    imageUrl: '☕',
    nutrition: const NutritionInfo(
      calories: 190,
      caffeineMg: 150,
      sugarG: 18,
      fatG: 7,
      proteinG: 13,
    ),
    brewing: const BrewingInfo(
      method: 'Espresso + Steamed Milk',
      description:
          'A smooth, creamy latte starts with two shots of espresso '
          'topped with steamed whole milk and finished with a thin layer of foam. '
          'The milk is heated to around 65 °C for natural sweetness.',
      brewTime: '30–35 sec',
      temperature: '65–70 °C',
    ),
    availableTemperatures: ['Hot', 'Iced'],
  ),

  DrinkModel(
    id: 'hc_004',
    name: 'Flat White',
    description:
        'Velvety microfoamed milk and ristretto shots for a stronger, bolder flavour.',
    basePrice: 395,
    category: DrinkCategory.hotCoffee,
    imageUrl: '☕',
    nutrition: const NutritionInfo(
      calories: 170,
      caffeineMg: 195,
      sugarG: 13,
      fatG: 9,
      proteinG: 10,
    ),
    origin: const OriginInfo(
      region: 'Chikmagalur',
      country: 'India',
      flavorNotes: 'Brown sugar, citrus brightness, nutty undertones',
      story:
          'These beans come from the Baba Budan Giri range in Chikmagalur — '
          'the birthplace of Indian coffee. Grown at 1,000–1,450 m, '
          'the estate uses natural sun-drying to intensify sweetness.',
      altitude: '1,000 – 1,450 m',
      process: 'Natural',
    ),
    brewing: const BrewingInfo(
      method: 'Ristretto + Microfoam',
      description:
          'Two ristretto shots — short pulls with half the water of espresso — '
          'concentrate the sweetness and intensity. Topped with microfoamed milk '
          'that is velvety and barely aerated for a silky mouthfeel.',
      brewTime: '15–20 sec',
      temperature: '62–65 °C',
    ),
    availableTemperatures: ['Hot'],
  ),

  // ── COLD COFFEE ─────────────────────────────────────────────────────────────

  DrinkModel(
    id: 'cc_001',
    name: 'Iced Caffè Latte',
    description: 'Our silky latte chilled over ice — perfect for warm days.',
    basePrice: 375,
    category: DrinkCategory.coldCoffee,
    imageUrl: '🥤',
    isBestseller: true,
    nutrition: const NutritionInfo(
      calories: 130,
      caffeineMg: 150,
      sugarG: 11,
      fatG: 5,
      proteinG: 8,
    ),
    brewing: const BrewingInfo(
      method: 'Espresso + Cold Milk + Ice',
      description:
          'Double espresso shots are poured over a full glass of ice, '
          'then topped with cold milk. The contrast of hot espresso and '
          'ice creates a naturally sweet, smooth drink.',
      brewTime: '25–30 sec',
      temperature: 'Iced',
    ),
    availableTemperatures: ['Iced'],
  ),

  DrinkModel(
    id: 'cc_002',
    name: 'Cold Brew',
    description:
        'Slow-steeped for 20 hours, served over ice for a smooth, mellow taste.',
    basePrice: 355,
    category: DrinkCategory.coldCoffee,
    imageUrl: '🥤',
    nutrition: const NutritionInfo(
      calories: 5,
      caffeineMg: 205,
      sugarG: 0,
      fatG: 0,
      proteinG: 1,
    ),
    origin: const OriginInfo(
      region: 'Araku Valley',
      country: 'India',
      flavorNotes: 'Smooth chocolate, low acidity, sweet finish',
      story:
          'Araku Valley in Andhra Pradesh is one of India\'s most celebrated '
          'coffee origins. Tribal farming cooperatives tend these beans at '
          '900–1,100 m altitude, shade-grown in the Eastern Ghats.',
      altitude: '900 – 1,100 m',
      process: 'Washed',
    ),
    brewing: const BrewingInfo(
      method: 'Cold Brew Immersion',
      description:
          'Coarsely ground coffee is steeped in cold, filtered water for '
          '20 hours at room temperature. Time replaces heat, extracting smooth, '
          'low-acid flavors without bitterness.',
      brewTime: '20 hours',
      temperature: 'Cold (4 °C)',
    ),
    availableTemperatures: ['Iced'],
  ),

  DrinkModel(
    id: 'cc_003',
    name: 'Nitro Cold Brew',
    description:
        'Cold brew infused with nitrogen for a smooth, creamy cascade.',
    basePrice: 425,
    category: DrinkCategory.coldCoffee,
    imageUrl: '🥤',
    isLimitedTime: false,
    nutrition: const NutritionInfo(
      calories: 5,
      caffeineMg: 280,
      sugarG: 0,
      fatG: 0,
      proteinG: 1,
    ),
    brewing: const BrewingInfo(
      method: 'Nitrogen-Infused Cold Brew',
      description:
          'Our Cold Brew is infused with nitrogen gas and served from a tap. '
          'The tiny nitrogen bubbles create a cascading, Guinness-like pour '
          'and a smooth, naturally sweet, creamy texture — no milk needed.',
      brewTime: '20 hours brew + nitrogen charge',
      temperature: 'Iced',
    ),
    availableTemperatures: ['Iced'],
  ),

  // ── FRAPPUCCINO ─────────────────────────────────────────────────────────────

  DrinkModel(
    id: 'fr_001',
    name: 'Caramel Frappuccino',
    description:
        'Coffee blended with milk and ice, layered with caramel sauce.',
    basePrice: 445,
    category: DrinkCategory.frappuccino,
    imageUrl: '🧋',
    isBestseller: true,
    nutrition: const NutritionInfo(
      calories: 380,
      caffeineMg: 90,
      sugarG: 54,
      fatG: 15,
      proteinG: 5,
    ),
    brewing: const BrewingInfo(
      method: 'Blended',
      description:
          'A Frappuccino is blended at high speed to create a thick, '
          'smooth, icy beverage. Coffee, milk, ice, and flavored syrups '
          'are combined and topped with whipped cream.',
      brewTime: '60 sec blend',
      temperature: 'Iced/Blended',
    ),
    availableTemperatures: ['Iced'],
  ),

  DrinkModel(
    id: 'fr_002',
    name: 'Mocha Frappuccino',
    description: 'Coffee, mocha sauce, milk, and ice — topped with whip.',
    basePrice: 445,
    category: DrinkCategory.frappuccino,
    imageUrl: '🧋',
    nutrition: const NutritionInfo(
      calories: 410,
      caffeineMg: 95,
      sugarG: 58,
      fatG: 16,
      proteinG: 6,
    ),
    brewing: const BrewingInfo(
      method: 'Blended',
      description:
          'Espresso roast, mocha sauce, whole milk, and ice are blended '
          'to a creamy consistency, then finished with whipped cream '
          'and a drizzle of chocolate sauce.',
      brewTime: '60 sec blend',
      temperature: 'Iced/Blended',
    ),
    availableTemperatures: ['Iced'],
  ),

  DrinkModel(
    id: 'fr_003',
    name: 'Matcha Cream Frappuccino',
    description: 'Matcha green tea blended with milk and ice, no coffee.',
    basePrice: 425,
    category: DrinkCategory.frappuccino,
    imageUrl: '🧋',
    nutrition: const NutritionInfo(
      calories: 310,
      caffeineMg: 70,
      sugarG: 44,
      fatG: 12,
      proteinG: 5,
    ),
    brewing: const BrewingInfo(
      method: 'Blended (No Coffee)',
      description:
          'Premium matcha powder is blended with whole milk, vanilla syrup, '
          'and ice. A coffee-free Frappuccino that delivers earthy green tea '
          'flavor with a naturally sweet, creamy finish.',
      brewTime: '60 sec blend',
      temperature: 'Iced/Blended',
    ),
    availableTemperatures: ['Iced'],
  ),

  // ── TEA ─────────────────────────────────────────────────────────────────────

  DrinkModel(
    id: 'tea_001',
    name: 'Masala Chai Latte',
    description:
        'A warming blend of spiced black tea with steamed milk — India in a cup.',
    basePrice: 295,
    category: DrinkCategory.tea,
    imageUrl: '🍵',
    isBestseller: true,
    nutrition: const NutritionInfo(
      calories: 240,
      caffeineMg: 70,
      sugarG: 32,
      fatG: 6,
      proteinG: 9,
    ),
    brewing: const BrewingInfo(
      method: 'Chai Concentrate + Steamed Milk',
      description:
          'Our chai concentrate is a blend of black Assam tea with cinnamon, '
          'cardamom, ginger, black pepper, and cloves. Combined with steamed '
          'milk for a warming, spiced cup.',
      brewTime: '4–5 min',
      temperature: '68 °C',
    ),
    availableTemperatures: ['Hot', 'Iced'],
  ),

  DrinkModel(
    id: 'tea_002',
    name: 'Matcha Green Tea Latte',
    description: 'Smooth and creamy matcha with steamed milk.',
    basePrice: 325,
    category: DrinkCategory.tea,
    imageUrl: '🍵',
    nutrition: const NutritionInfo(
      calories: 240,
      caffeineMg: 80,
      sugarG: 32,
      fatG: 7,
      proteinG: 12,
    ),
    brewing: const BrewingInfo(
      method: 'Matcha + Steamed Milk',
      description:
          'Ceremonial-grade matcha is whisked with a small amount of hot water '
          'to form a smooth paste, then combined with steamed milk for '
          'a vibrant, earthy latte.',
      brewTime: '2–3 min',
      temperature: '65–70 °C',
    ),
    availableTemperatures: ['Hot', 'Iced'],
  ),

  // ── SEASONAL ────────────────────────────────────────────────────────────────

  DrinkModel(
    id: 'sea_001',
    name: 'Pumpkin Spice Latte',
    description:
        'Fall\'s favourite — espresso, pumpkin spice, and steamed milk.',
    basePrice: 495,
    category: DrinkCategory.seasonal,
    imageUrl: '🎃',
    isLimitedTime: true,
    nutrition: const NutritionInfo(
      calories: 380,
      caffeineMg: 150,
      sugarG: 50,
      fatG: 14,
      proteinG: 14,
    ),
    brewing: const BrewingInfo(
      method: 'Espresso + Pumpkin Sauce + Steamed Milk',
      description:
          'Two shots of espresso are combined with our exclusive pumpkin sauce '
          '(real pumpkin, cinnamon, nutmeg, clove, ginger) and steamed milk, '
          'topped with whipped cream and pumpkin spice.',
      brewTime: '30–35 sec',
      temperature: '65–70 °C',
    ),
    availableTemperatures: ['Hot', 'Iced'],
  ),

  DrinkModel(
    id: 'sea_002',
    name: 'Thandai Cold Brew',
    description: 'Cold brew infused with traditional Indian Thandai spices.',
    basePrice: 465,
    category: DrinkCategory.seasonal,
    imageUrl: '🌸',
    isLimitedTime: true,
    nutrition: const NutritionInfo(
      calories: 80,
      caffeineMg: 200,
      sugarG: 12,
      fatG: 2,
      proteinG: 3,
    ),
    origin: const OriginInfo(
      region: 'Araku Valley',
      country: 'India',
      flavorNotes: 'Rose, saffron, pepper, cooling finish',
      story:
          'Inspired by the traditional Holi drink, this cold brew is '
          'infused with rose petals, saffron, almonds, fennel, and cardamom. '
          'A celebration of Indian flavors in every sip.',
      altitude: '900 – 1,100 m',
      process: 'Natural',
    ),
    brewing: const BrewingInfo(
      method: 'Cold Brew + Thandai Infusion',
      description:
          'Araku cold brew is steeped with a Thandai spice blend '
          '(rose, saffron, almond, fennel, cardamom, poppy seeds) for 4 hours, '
          'then strained and served over ice.',
      brewTime: '20 hr brew + 4 hr infusion',
      temperature: 'Iced',
    ),
    availableTemperatures: ['Iced'],
  ),

  DrinkModel(
    id: 'sea_003',
    name: 'Rose Gold Latte',
    description: 'Rose syrup and turmeric with steamed oat milk — festive.',
    basePrice: 475,
    category: DrinkCategory.seasonal,
    imageUrl: '🌹',
    isLimitedTime: true,
    nutrition: const NutritionInfo(
      calories: 220,
      caffeineMg: 0,
      sugarG: 28,
      fatG: 5,
      proteinG: 4,
    ),
    brewing: const BrewingInfo(
      method: 'Rose Syrup + Turmeric + Oat Milk',
      description:
          'A caffeine-free seasonal special — steamed oat milk is combined '
          'with rose syrup, a pinch of turmeric, and cardamom. '
          'Served with a dusting of dried rose petals on top.',
      brewTime: '2–3 min',
      temperature: '65 °C',
    ),
    availableTemperatures: ['Hot', 'Iced'],
  ),

  DrinkModel(
    id: 'sea_004',
    name: 'Filter Coffee Latte',
    description: 'South Indian filter decoction with steamed milk — BrewBuddy style.',
    basePrice: 325,
    category: DrinkCategory.seasonal,
    imageUrl: '☕',
    isLimitedTime: true,
    isBestseller: true,
    nutrition: const NutritionInfo(
      calories: 210,
      caffeineMg: 180,
      sugarG: 22,
      fatG: 8,
      proteinG: 10,
    ),
    origin: const OriginInfo(
      region: 'Nilgiris',
      country: 'India',
      flavorNotes: 'Chicory, dark chocolate, roasted grain',
      story:
          'A tribute to South India\'s beloved filter coffee tradition. '
          'These Tamil Nadu Nilgiri beans are blended with chicory and '
          'double-decocted in a traditional brass filter.',
      altitude: '1,800 – 2,200 m',
      process: 'Dry / Natural',
    ),
    brewing: const BrewingInfo(
      method: 'Filter Decoction + Steamed Milk',
      description:
          'Coffee powder is packed into a traditional filter and hot water '
          'is poured through twice to make a thick decoction. '
          'Steamed milk is added in a 1:3 ratio for the classic taste.',
      brewTime: '10–15 min',
      temperature: '70 °C',
    ),
    availableTemperatures: ['Hot'],
  ),
];

/// Seasonal drinks subset (for Home carousel)
List<DrinkModel> get seasonalDrinks =>
    mockDrinks.where((d) => d.isLimitedTime).toList();

/// Bestseller drinks
List<DrinkModel> get bestsellerDrinks =>
    mockDrinks.where((d) => d.isBestseller).toList();

/// Drinks by category
List<DrinkModel> drinksByCategory(DrinkCategory category) =>
    mockDrinks.where((d) => d.category == category).toList();
