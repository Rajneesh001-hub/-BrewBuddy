# ☕ BrewBuddy

**A complete Flutter mobile app for coffee order-ahead, customization, and rewards management** — built for a coffee chain in India.

---

## 📱 Features

### 🏠 Home
- Personalized greeting with star balance
- **Birthday reward banner** with expiry tracking
- **Happy Hour countdown timer** (4–7 PM, 15% off beverages)
- Seasonal drinks carousel
- Bestseller recommendations

### ☕ Menu
- Search bar across all categories
- Category tabs: Hot Coffee, Cold Coffee, Frappuccino, Tea, Seasonal
- 2-column drink grid with badges (Limited Time, Bestseller)

### 🔬 Drink Detail
- Hero image with drink emoji
- Three tabs:
  - **Nutrition**: Calories, caffeine, sugar, fat, protein
  - **Origin**: Region story, flavor notes, altitude, process
  - **Brewing**: Method, brew time, temperature

### 🎨 Customization
- **Milk type** (Whole, Oat +₹30, Almond +₹40, Soy +₹30)
- **Espresso shots** (1–4, +₹20 per extra shot)
- **Syrup pumps** (0–6, +₹15 per pump) with flavor selector
- **Temperature** (Hot, Warm, Iced)
- **Live price updates** as options change
- Price breakdown card

### 🛒 Cart & Pickup
- Item cards with quantity controls and remove button
- **Pickup time slots** (15-min intervals, next 2 hours)
- **Happy Hour discount** applied automatically (4–7 PM)
- Order summary with stars-to-earn display
- Place Order CTA (disabled until time slot selected)

### ✅ Order Confirmation
- Order number, pickup time, store location
- **QR code** for barista scanning (via `qr_flutter`)
- Stars earned badge
- Items ordered summary

### ⭐ Rewards
- **Star progress bar** with animated tier progress
- Tier milestones: Green (5 stars) → Gold (30 stars)
- Current tier benefits card
- **Redemption catalog** with star costs
- Birthday reward banner
- "How Stars Work" info card

### 📍 Store Locator
- **Google Map** with store markers and user location
- Live location fetching (via `geolocator`)
- Stores sorted by distance
- Store tiles with:
  - Hours, distance, amenities (WiFi, Seating, Parking)
  - **Directions** button (opens Google Maps via `url_launcher`)
  - **Order Here** button

---

## 🎨 Design System

### Colors
- **Deep Green** `#1E3932` — App bars, headings, nav active
- **Fresh Green** `#00704A` — Primary buttons, CTAs
- **Cream** `#F2F0EB` — Page backgrounds
- **Caramel Gold** `#C8A36B` — Stars, Gold tier, price highlights
- **White** `#FFFFFF` — Cards, sheets

### Typography
- **Headings**: Poppins (Bold/SemiBold)
- **Body**: Inter (Regular)
- Material 3, 16px corner radius, soft shadows

### Theme
All colors, text styles, and dimensions centralized in `lib/theme/app_theme.dart`. Never hardcode values in screens.

---

## 🛠️ Tech Stack

- **Flutter** (latest stable, null-safe Dart)
- **Material 3** design
- **State Management**: Provider
- **Packages**:
  - `google_fonts` — Poppins & Inter fonts
  - `provider` — State management
  - `qr_flutter` — QR code generation
  - `google_maps_flutter` — Store map
  - `geolocator` — User location
  - `url_launcher` — Directions to Google Maps
  - `intl` — Date/time formatting

---

## 📂 Folder Structure

```
lib/
├── data/               # Mock data (drinks, rewards, stores)
├── models/             # Data models (Drink, Cart, Order, Reward, Store, User)
├── providers/          # Provider classes (Cart, Menu, User, Store)
├── screens/            # All screens (Home, Menu, Cart, Rewards, etc.)
├── theme/              # AppTheme, colors, text styles, dimensions
├── widgets/            # Reusable widgets (DrinkCard, StarProgressBar, etc.)
└── main.dart           # App entry + bottom navigation shell
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable): [Install Flutter](https://docs.flutter.dev/get-started/install)
- Android Studio / Xcode (for emulators)
- **Google Maps API Key** (for Store Locator)

### Installation

1. **Clone or download** this project

2. **Install dependencies**
   ```bash
   cd brew_buddy
   flutter pub get
   ```

3. **Configure Google Maps API Key**

   - Get your API key from [Google Cloud Console](https://console.cloud.google.com/google/maps-apis)
   - Copy the example file:
     ```bash
     cp android/local.properties.example android/local.properties
     ```
   - Edit `android/local.properties` and replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual key:
     ```properties
     MAPS_API_KEY=AIzaSyC...your-actual-key-here
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

---

## 📊 Business Logic

### Pricing
- **Base price** + customization extras:
  - Oat Milk: +₹30
  - Almond Milk: +₹40
  - Soy Milk: +₹30
  - Extra espresso shot (beyond 2): +₹20 each
  - Syrup pump: +₹15 each

### Happy Hour (4 PM – 7 PM)
- **15% discount** applied automatically
- Live countdown timer on Home screen
- Discount shown in cart

### Stars & Tiers
- **Earn**: 1 Star per ₹50 spent
- **Green Tier**: 5 stars (standard benefits)
- **Gold Tier**: 30 stars (premium benefits)
- Birthday reward: Free drink on your birthday month

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Analyze code
flutter analyze

# Check for issues
flutter doctor
```

---

## 📸 Screenshots

*Add your app screenshots here after running the app*

---

## 🎯 Features Roadmap

- [ ] Push notifications for seasonal drinks
- [ ] Order history
- [ ] Favorite drinks quick-add
- [ ] Payment gateway integration
- [ ] Social sharing for rewards
- [ ] Dark mode

---

## 👨‍💻 Developer Notes

### Mock Data
All data is local — no backend required. Edit files in `lib/data/` to add drinks, rewards, or stores.

### State Management
- `CartProvider`: Cart items, happy hour logic, order placement
- `MenuProvider`: Category filter, search, customization state
- `UserProvider`: Stars balance, tier, reward redemption
- `StoreProvider`: Store list, user location, distance calculation

### Permissions
- `INTERNET` — For Google Maps tiles
- `ACCESS_FINE_LOCATION` — User location on map
- `ACCESS_COARSE_LOCATION` — Fallback location

---

## 📄 License

This project is built as a case study for **ITM Skills University** — B.Tech Computer Science Engineering and AI, Cross Platform Application Development (Semester V).

---

## 🙏 Acknowledgments

- Design inspiration: Starbucks India
- Mock coffee data: Single-origin Indian coffee regions (Coorg, Chikmagalur, Araku Valley, Nilgiris)
- Icons: Material Icons
- Fonts: Google Fonts (Poppins, Inter)

---

## 📞 Support

For issues or questions about this project:
1. Check `flutter doctor` output
2. Ensure Google Maps API key is set correctly in `android/local.properties`
3. Run `flutter clean && flutter pub get` if you encounter build errors

---

**Built with ☕ and Flutter**
