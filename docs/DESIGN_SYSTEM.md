# Al Noor Diagnostic Centre - Design System

## 1. Design Philosophy: "Al Noor Light"
The design system of the **Al Noor Diagnostic Centre** mobile app reflects a modern luxury healthcare aesthetic:
- **Clean Clinical Confidence:** Dominant crisp white and soft light blue-gray surfaces convey sterile medical precision and calming tranquility.
- **Brand Authority:** Deep medical teal (`#008080` / `#005959`) and vibrant gold accent (`#D4AF37` / `#B8860B`) represent the 40+ years of legacy since 1983 established by founder Prof. Dr. Safdar Ali Malik.
- **Tactile Materiality:** Dynamic 3D perspective cards (`HeroCard3D` and `HealthCardWidget`) with touch/hover-driven tilt transforms and realistic specular lighting overlays give a premium, physical feel.
- **Pakistani Cultural & RTL Cohesion:** Seamless bidirectionality supporting English and Nastaliq-styled Urdu typography with mirrored icons and direction-aware layout containers.

---

## 2. Color System (`AppColors`)

| Token Name | Hex Code | Purpose / Application |
|---|---|---|
| `primary` | `#008080` (Deep Teal) | Primary brand color, buttons, active tab indicators, major headers |
| `primaryDark` | `#005959` | Gradient terminations, card shadows, high-contrast dark accents |
| `primaryLight` | `#339999` | Hover states, subtle badge borders, active toggle highlights |
| `secondary` | `#D4AF37` (Metallic Gold) | VIP badges, Gold membership health cards, special offers |
| `secondaryDark` | `#B8860B` | Gold card gradient base, premium borders |
| `secondaryLight` | `#F4E8C1` | Gold pill background, highlight badges, tip headers |
| `backgroundLight` | `#F8FAFC` (Slate Tint) | Primary application background in light mode |
| `surfaceLight` | `#FFFFFF` (Pure White) | Card containers, modal sheets, bottom navigation surface |
| `backgroundDark` | `#0F172A` (Navy Slate) | Dark mode canvas background |
| `surfaceDark` | `#1E293B` (Elevated Slate) | Dark mode card containers and sheets |
| `textPrimary` | `#0F172A` | High-emphasis body text, test titles, prices |
| `textSecondary` | `#64748B` (Muted Slate) | Subtitles, turnaround times, prerequisites |
| `textMuted` | `#94A3B8` | Input placeholders, inactive navigation icons |
| `success` | `#10B981` (Emerald) | Completed order status, normal biomarker ranges, discount applied |
| `warning` | `#F59E0B` (Amber) | Out-of-range critical biomarkers, sample en-route status |
| `error` | `#EF4444` (Ruby) | Cancelled orders, invalid inputs, error alerts |
| `info` | `#3B82F6` (Sky Blue) | Informational callouts, sample collection guidelines |

---

## 3. Typography Scale (`AppTypography`)
The app utilizes a dual-engine font pairing with automatic fallback:
- **English:** Clean, contemporary sans-serif with geometric legibility (`Outfit` / `Inter` / System San Francisco / Roboto).
- **Urdu:** Legible high-contrast Arabic/Urdu typography (`Noto Nastaliq Urdu` / `Gulzar` / System Arabic) with customized line heights (`height: 1.4 - 1.6`) to prevent ascender/descender clipping.

### Scale:
- **Display 1 (28px / SemiBold):** Splash titles, Hero balance, Success screen headings
- **Headline 1 (22px / Bold):** Section headers, Screen titles, Package banner titles
- **Headline 2 (18px / SemiBold):** Card titles, Test names, Bottom sheet titles
- **Body Large (16px / Regular):** Main paragraph text, doctor bios, guidelines
- **Body Medium (14px / Regular):** Test parameters, instructions, addresses, filter labels
- **Caption / Micro (12px / Medium):** Timestamps, turnaround badges, fast tags, TAT info
- **Price Large (20px / Bold):** Formatted PKR pricing in checkout and cart

---

## 4. Reusable Component Catalog

### 4.1. `HeroCard3D` (Interactive Tilt Card)
- **Physics:** Responds to pointer hover and touch pan gestures. Calculates delta offset relative to card center, producing dynamic pitch and roll rotation matrix:
  ```dart
  Matrix4.identity()
    ..setEntry(3, 2, 0.001) // perspective
    ..rotateX(_tiltX)
    ..rotateY(_tiltY)
  ```
- **Specular Glare:** An interactive RadialGradient overlay shifts across the card surface in synchronization with tilt direction, mimicking authentic glass/metallic sheen.

### 4.2. `HealthCardWidget`
- **Features:** 3D luxury metallic card representing patient health membership (Al Noor Health Pass).
- **Visuals:** Features embossed Al Noor logo, patient name, unique Patient ID barcode / QR code, issue date, and subtle gold foil shimmer.
- **Actions:** Flip card for emergency contact details, blood group, allergies, and quick share action.

### 4.3. `AppButton`
- **Primary:** Teal filled pill or rounded rectangle (12px radius) with subtle drop shadow and press animation.
- **Secondary:** Gold accent button for booking and fast-track actions.
- **Outlined:** Clean 1.5px border for secondary flows (e.g. "View Sample Report").
- **States:** Idle, Hover, Pressed, Loading (with embedded Cupertino/Material spinner), Disabled.

### 4.4. `AppTextField`
- **Design:** Soft slate-50 fill (`#F1F5F9`), subtle border transition on focus (`#008080`), clear suffix action, prefix icons, and real-time validation error styling.
- **Specializations:** Phone number field with fixed `+92` flag prefix, search field with debounced clearing.

### 4.5. `StatusChip`
- **Design:** Compact rounded pill with matching light-tinted background and solid text color.
- **Variants:**
  - `Booked / Confirmed` (Sky Blue)
  - `Phlebotomist Dispatched` (Amber)
  - `Sample Collected` (Teal)
  - `In Lab Processing` (Purple)
  - `Report Ready` (Emerald Green)
  - `Cancelled` (Rose Red)

### 4.6. `SkeletonLoader`
- Shimmer animation overlay (`shimmer: ^3.0.0`) matching exact card dimensions to eliminate cumulative layout shift (CLS) during simulated network latency.

---

## 5. Responsive Breakpoints & Desktop Test Frame
- **Mobile Handset (< 500px):** Full-bleed native mobile experience, edges aligned to device safe areas.
- **Tablet / Desktop Browser (> 500px):** Automatically housed in `DeviceFrameWrapper`:
  - **Frame Viewport:** 390px × 844px (authentic iPhone 15 aspect ratio).
  - **Live Dynamic Island / Notch:** Live system clock, WiFi, battery indicators.
  - **Dock Controls:** Side bar with instant demo credentials, language switcher, light/dark mode toggle, and test data reset.
