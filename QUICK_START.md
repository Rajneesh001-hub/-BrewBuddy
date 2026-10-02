# ☕ BrewBuddy - Quick Start Guide

## 🚀 Run the App (Easy Way)

### Option 1: Using the run script (EASIEST)
```bash
cd /Users/rajneesharya/Desktop/Flutter/brew_buddy
./run.sh
```

### Option 2: Direct Flutter command
```bash
cd /Users/rajneesharya/Desktop/Flutter/brew_buddy
flutter run -d chrome --web-port=8080
```

### Option 3: No port specification
```bash
cd /Users/rajneesharya/Desktop/Flutter/brew_buddy
flutter run -d chrome
```

---

## 📱 Access the App

Once the app starts, open your browser and go to:
👉 **http://127.0.0.1:8080**

---

## 🎯 What to Try

### Home Screen
- ✅ Personalized greeting
- ✅ Star balance and Gold tier status
- ✅ Birthday reward banner
- ✅ Happy hour countdown (4-7 PM)
- ✅ Seasonal specials carousel
- ✅ Your usual order card
- ✅ Bean of the day

### Menu Screen
- ✅ Browse by category (Hot Coffee, Cold Coffee, Frappuccino, Tea)
- ✅ Search for drinks
- ✅ Large drink cards with images & ratings
- ✅ Add to cart

### Cart & Checkout
- ✅ Customize drinks (milk, shots, syrups, temperature)
- ✅ Select pickup time
- ✅ See happy hour discount
- ✅ Place order with QR code

### Rewards
- ✅ View star progress
- ✅ See tier benefits
- ✅ Redemption catalog

### Store Locator
- ✅ Find stores on map
- ✅ See hours and amenities
- ✅ Get directions

---

## 🛑 Stop the App

Press `q` in the terminal, or press `Ctrl+C`

---

## 🔄 Hot Reload

While the app is running, press `r` in the terminal for hot reload (instant refresh without rebuilding)

---

## 🧹 Clean Build

If you encounter issues:
```bash
flutter clean
flutter pub get
flutter run -d chrome --web-port=8080
```

---

## 📊 Project Structure

```
lib/
├── screens/          # 8 app screens
├── widgets/          # Reusable UI components
├── models/           # Data models
├── providers/        # State management
├── theme/            # Design system & colors
├── data/             # Mock data
└── main.dart         # App entry point
```

---

## 🎨 Design Features

- **Material 3** design system
- **Colors**: Deep Green, Fresh Green, Cream, Caramel Gold
- **Typography**: Poppins + Inter fonts
- **Images**: Real coffee photos from Unsplash
- **Animations**: Smooth transitions & interactions

---

## 💡 Tips

- App has NO backend - all data is mock data
- Perfect for portfolio or case study
- Fully functional and ready to customize
- Can be built for Android/iOS with minimal changes

---

Enjoy! ☕
