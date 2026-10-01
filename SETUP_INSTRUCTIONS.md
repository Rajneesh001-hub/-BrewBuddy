# 🚀 BrewBuddy — Setup Instructions

## Quick Start (5 minutes)

### 1. Install Dependencies
```bash
cd brew_buddy
flutter pub get
```

### 2. Configure Google Maps (Required for Store Locator)

**Option A: Use a test key (recommended for development)**
```bash
# Copy the example file
cp android/local.properties.example android/local.properties

# Edit android/local.properties and add ANY placeholder key:
MAPS_API_KEY=AIzaSyDummyKeyForTesting123456789
```

**Option B: Get a real API key**
1. Go to [Google Cloud Console](https://console.cloud.google.com/google/maps-apis)
2. Create a new project
3. Enable **Maps SDK for Android**
4. Create credentials → API Key
5. Add the key to `android/local.properties`:
   ```
   MAPS_API_KEY=AIzaSyC...your-actual-key-here
   ```

### 3. Run the App
```bash
flutter run
```

That's it! The app should launch on your connected device or emulator.

---

## 📱 Testing the Features

### Home Screen
- Notice the greeting changes based on time of day
- Birthday banner shows if `mockUser.birthdayReward.isValid` is true
- **Happy Hour banner appears between 4 PM and 7 PM** with live countdown

### Menu & Customization
- Search works across all categories
- Try customizing a drink: notice the live price updates
- Add items to cart

### Cart & Checkout
- **Between 4 PM and 7 PM**, you'll see a 15% discount automatically applied
- Select a pickup time slot
- Place an order to see the QR code

### Rewards
- Check your star balance (starts at 18 stars)
- Try redeeming a reward (5-star items are affordable)
- Watch the tier progress bar

### Store Locator
- Tap the location button to fetch your current location
- Tap a store marker on the map to select it
- Tap "Directions" to open Google Maps (requires url_launcher)

---

## 🐛 Troubleshooting

### "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### "Google Maps not loading"
- Check that `android/local.properties` exists and contains `MAPS_API_KEY`
- The key can be a dummy value for testing — the map tiles will still load
- For production, enable **Maps SDK for Android** in Google Cloud Console

### "Location permission denied"
- Grant location permission when prompted
- On Android emulator: Settings → Apps → BrewBuddy → Permissions → Location → Allow

### "Package not found" errors
```bash
flutter clean
flutter pub get
```

---

## 📊 Mock Data Customization

All data is local — edit these files to customize:

- **Drinks**: `lib/data/mock_drinks.dart`
- **Rewards**: `lib/data/mock_rewards.dart`
- **Stores**: `lib/data/mock_stores.dart`
- **User**: `lib/data/mock_rewards.dart` → `mockUser`

---

## 🎯 Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point, bottom navigation |
| `lib/theme/app_theme.dart` | All colors, fonts, styles |
| `lib/screens/` | All 8 screens |
| `lib/providers/` | State management (Cart, Menu, User, Store) |
| `lib/widgets/` | Reusable components |
| `android/app/src/main/AndroidManifest.xml` | Permissions, API key placeholder |

---

## 🔧 Build for Release

```bash
# Android APK (for testing)
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## ✅ Verify Everything Works

```bash
# Check for code issues
flutter analyze

# Run tests (if any)
flutter test

# Check Flutter setup
flutter doctor
```

---

## 🎨 Design Notes

- All screens match the **Google Stitch** UI designs provided
- Material 3 components with 16px corner radius
- Poppins (headings) + Inter (body) via `google_fonts`
- Theme colors: Deep Green (#1E3932), Fresh Green (#00704A), Cream (#F2F0EB), Caramel Gold (#C8A36B)

---

## 📞 Need Help?

1. Run `flutter doctor` and fix any issues
2. Check that `pubspec.yaml` has all required packages
3. Ensure `android/local.properties` exists with a MAPS_API_KEY entry
4. Try `flutter clean && flutter pub get`

---

**Happy brewing! ☕**
