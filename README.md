# 🍕 BellaPizza - Pizza Ordering App

A beautiful, production-ready Flutter application for ordering pizzas with custom add-ons. Built for the Calda Frontend Challenge.

[![Flutter](https://img.shields.io/badge/Flutter-3.1%2B-blue.svg)](https://flutter.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-green.svg)](https://supabase.com/)

## ✨ Features

- ✅ **User Authentication** - Email/password signup & login
- ✅ **Pizza Browsing** - Grid view of 12 delicious pizzas
- ✅ **Size Selection** - Small, Medium, or Large
- ✅ **Add-ons** - Mozzarella, Parmesan, Corn, Jalapeños, Chicken
- ✅ **Custom Slide to Order** - Swipe to confirm (NO external libraries!)
- ✅ **Order Management** - Saved to Supabase database
- ✅ **Pixel-Perfect UI** - Design from Figma

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/Nik537/BellaPizza.git
cd BellaPizza

# Install
flutter pub get

# Configure Supabase in lib/main.dart

# Run
flutter run
```

## 📱 Screens

1. **Splash** - Welcome & navigation
2. **Login** - User authentication
3. **Sign Up** - Registration
4. **Pizzas** - Grid of 12 pizzas
5. **Pizza Details** - Size, add-ons, ordering
6. **Order Success** - Confirmation

## 🎯 Key Component: Slide to Order

Custom swipeable widget (NO external libraries!):
- Location: `lib/widgets/slide_to_order_widget.dart`
- 273 lines of pure Flutter/Dart
- Gesture-based sliding with animations

## 🗄️ Database Setup

See full SQL in parent directory or run this in Supabase SQL Editor:

1. Create profiles, pizzas, add_ons, orders, orders_add_ons tables
2. Create trigger for auto-profile creation
3. Insert 12 pizzas and 5 add-ons
4. Get API credentials from Settings → API

## 🎨 Tech Stack

- **Flutter 3.1+** - Cross-platform framework
- **Supabase** - Backend & Authentication
- **Provider** - State management
- **Custom Widgets** - Pure Dart implementations

## 📦 Project Structure

```
lib/
├── main.dart                    # Entry point
├── constants/app_constants.dart # Design system
├── models/models.dart           # Data models
├── services/supabase_service.dart # API
├── widgets/                     # Custom components
└── screens/                     # 6 screens
```

## 🛠️ Development

```bash
flutter run              # Debug mode
flutter run --release    # Release mode
flutter analyze          # Check code
flutter clean           # Clean build
```

## ✅ Challenge Requirements Met

| Requirement | Status |
|-------------|--------|
| Authentication | ✅ |
| Pizza browsing | ✅ |
| Add-on selection | ✅ |
| Order creation | ✅ |
| **Slide to Order (no libs)** | ✅ |
| Pixel-perfect design | ✅ |

## 👨‍💻 Author

**Nik Noavak**
- GitHub: [@Nik537](https://github.com/Nik537)

---

**Built with ❤️ using Flutter & Supabase**

🍕 **BellaPizza - Order your perfect pizza!** 🍕
