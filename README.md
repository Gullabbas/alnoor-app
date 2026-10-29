# Al Noor Diagnostic Centre - Official Mobile & Web Application

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod_3.3-blueviolet)](https://riverpod.dev)
[![GoRouter](https://img.shields.io/badge/Routing-GoRouter_17.2-informational)](https://pub.dev/packages/go_router)
[![License](https://img.shields.io/badge/License-Proprietary-red)](#)
[![Tests](https://img.shields.io/badge/Tests-8%2F8%20Passed-success)](#)
[![Analyzer](https://img.shields.io/badge/Analyzer-0%20Issues-brightgreen)](#)

A state-of-the-art, luxury medical application built for **Al Noor Diagnostic Centre** (Lahore, Pakistan • Established 1983 by Prof. Dr. Safdar Ali Malik). Engineered to provide a seamless diagnostic experience with home sampling, live phlebotomist tracking, digital diagnostic reports with longitudinal biomarker trend analysis, and authentic English/Urdu bilingual RTL support.

---

## 🌟 Key Features

1. **Luxury "Al Noor Light" Design System:**
   - Dominant clinical slate-white surfaces, deep medical teal (`#008080`), and metallic gold accents (`#D4AF37`).
   - Dynamic **3D perspective tilt cards** (`HeroCard3D`) and **metallic health passes** (`HealthCardWidget`) responding to mouse hover and touch gestures with specular lighting glares.
2. **Authentic Bilingual & Bidirectional (English & Urdu RTL):**
   - Full right-to-left layout inversion for Urdu with authentic Nastaliq-styled typography.
   - 1-click language switcher available directly in the UI and in the desktop toolbar.
3. **Desktop-First Mobile Simulation Frame:**
   - When viewed on browser or desktop displays (>500px), automatically renders inside a realistic iPhone 15 frame with live status bar (clock, battery, Wi-Fi).
   - Side toolbar with quick demo user switcher, language toggle, dark mode toggle, and test data reset.
4. **End-to-End Commerce & Home Sampling Booking:**
   - 120+ clinical tests and 10 health packages with intelligent search and department filters.
   - 7-step home sampling wizard (address, date/time slot, clinical fasting instructions, prescription photo upload, and payment method).
   - Coupon codes engine (`NOOR10` for 10% off, `FREESAMPLE` for waived sampling fee).
5. **Live Sample Collection Tracking:**
   - 6-stage real-time progress timeline (*Booked → Phlebotomist Assigned → En Route → Sample Collected → Lab Processing → Report Ready*).
   - Live map preview, countdown ETA timer, rider profile with 1-tap phone and WhatsApp buttons, and barcode scan confirmation.
6. **Smart Medical Documents & Biomarker Trends:**
   - Categorized diagnostic documents (*Pathology, Radiology, Cardiology, Prescriptions, Invoices*).
   - Interactive longitudinal biomarker trend graphs (`fl_chart`) for HbA1c, Fasting Blood Glucose, Vitamin D, and Lipid profiles with normal range reference bands.
   - Simulated PDF viewer with share and download capabilities.
7. **Care, Support & AI Health Assistant:**
   - Live support chat with 8 specialized customer care agents, typing indicator animation, and automated replies.
   - Al Noor AI Health Orb answering diagnostic preparation guidelines (fasting, TAT, prerequisites).
   - Consultant doctor directory and specialized clinic booking.

---

## 🔑 Demo Credentials Cheat Sheet

The app is fully offline and self-contained with rich pre-seeded clinical data. Any of the following demo accounts can be used to log in:

| User Name | Phone Number | Universal OTP | Universal PIN | Account Details |
|---|---|---|---|---|
| **Ahmed Raza** | `0300 1234567` | `1234` | `1234` | **Main Demo Account:** 4 family profiles (Ahmed, Mother Fatima, Wife Ayesha, Daughter Zainab). 12 historical diagnostic reports, 1 active order currently en-route. |
| **Ayesha Khan** | `0321 7654321` | `1234` | `1234` | **Wellness Account:** Female wellness profile, cardiac & physiotherapy records, Gold Health Card pass. |
| **Muhammad Usman** | `0333 1112223` | `1234` | `1234` | **Corporate Account:** Executive health checkup, Gulf embassy medicals, corporate health tier. |
| **New User** | `0345 0000000` | `1234` | `1234` | **Clean Slate:** Empty state verification, no prior orders or reports, first-time booking guidance. |

> **Universal Credentials:** Any valid 11-digit Pakistani phone number starting with `03xx` can also be used. The universal demo OTP is `1234` and the universal PIN is `1234`.

---

## 🚀 Quick Start & Running Locally

### Prerequisites
- [Flutter SDK 3.35.3+](https://docs.flutter.dev/get-started/install)
- Google Chrome (for web testing) or Android / iOS device/emulator.

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run on Desktop Browser (Chrome)
```bash
flutter run -d chrome
```
*The app automatically displays the iPhone 15 desktop test frame with the side control dock.*

### 3. Run on Mobile (Android / iOS)
```bash
flutter run
```
*On mobile screens, the app renders full-bleed edge-to-edge native UI.*

---

## 🧪 Testing & Verification

### Static Analysis
```bash
flutter analyze
```
*Expected: `No issues found!` (0 errors, 0 warnings).*

### Automated Unit & Widget Tests
```bash
flutter test
```
*Expected: `All tests passed!` (8/8 test suites passing).*

Test suite covers:
- App smoke test & widget mounting
- Pricing & coupon discount calculation (`NOOR10`, `FREESAMPLE`)
- Catalog & seed data integrity (120+ tests, 10 packages, 12 doctors, 8 agents)
- Pakistani phone number validation regex
- Authentication notifier, session persistence & family profile switching
- Diagnostic reports repository & longitudinal trend generation
- Order repository & active home sampling state
- English & Urdu dictionary completeness & RTL layout flag

---

## 📦 Production Release Builds

### Web Release Build
```bash
flutter build web --release
```
*Outputs static web bundle to `build/web/`.*

### Android APK (Release)
```bash
flutter build apk --release
```
*Outputs standalone APK to `build/app/outputs/flutter-apk/app-release.apk`.*

### Android App Bundle (Google Play Store)
```bash
flutter build appbundle --release
```
*Outputs AAB to `build/app/outputs/bundle/release/app-release.aab`.*

### iOS Archive (App Store / TestFlight)
*(Requires macOS with Xcode)*
```bash
flutter build ipa --release
```

---

## 📁 Project Architecture

```
lib/
├── core/
│   ├── l10n/              # AppLocalizations with authentic EN/UR dictionary
│   ├── router/            # GoRouter with StatefulShellRoute persistent nav
│   ├── theme/             # Al Noor Light medical tokens, typography & colors
│   └── widgets/           # 3D tilt card, metallic health pass, buttons, inputs
├── data/
│   ├── demo/              # SeedData (120+ clinical tests, 4 demo users) & FakeApi
│   ├── models/            # Immutable data models (User, Test, Report, Order, Vital)
│   └── repositories/      # Riverpod notifiers (Auth, Catalog, Cart, Orders, Reports)
├── features/
│   ├── auth/              # Login, OTP, PIN, Profile selection
│   ├── booking/           # 7-step home sampling wizard, Radiology, Success
│   ├── catalog/           # Searchable tests & curated health packages
│   ├── chat/              # Live agent support chat & AI Assistant orb
│   ├── doctors/           # Consultant directory & clinical booking
│   ├── health/            # Biomarker trends & 3D metallic health passes
│   ├── home/              # Dynamic feed, 9 reasons why, branch locations
│   ├── onboarding/        # Splash screen, language selection, carousel
│   ├── orders/            # Live sample collection tracking with ETA & map
│   ├── reports/           # Diagnostic documents & PDF generator
│   └── settings/          # Profile management, security & preferences
└── main.dart              # App root & ProviderScope
```

---

## 🏛️ Al Noor Diagnostic Centre - Campus Information

- **Founder:** Prof. Dr. Safdar Ali Malik (Consultant Radiologist & Pathologist)
- **Established:** 1983 (40+ Years of Excellence)
- **Flagship Campus:** 680-A Shadman, Opposite Fatima Memorial Hospital, Lahore, Punjab, Pakistan
- **UAN Hotline:** `+92 42 111 939 939`
- **WhatsApp Support:** `+92 308 113 9009`
- **Official Website:** [alnoordiagnostic.com](https://alnoordiagnostic.com)
