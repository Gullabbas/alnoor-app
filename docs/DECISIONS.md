# Architecture & Engineering Decisions (DECISIONS.md)

This log records all senior architectural, design, and engineering decisions made for the **Al Noor Diagnostic Centre** mobile application.

---

## 1. Technical Stack & Architecture

- **Decision 1.1: Feature-First Clean Architecture**
  - **Context:** The application spans multiple complex healthcare domains (commerce, lab bookings, clinical reports, live chat, vitals tracking, consultant telemedicine).
  - **Decision:** Structure codebase by feature under `lib/features/<feature>/{data,domain,presentation}` alongside shared cores `lib/core/{theme,widgets,utils,router,l10n}` and `lib/data/{demo,local}`.
  - **Rationale:** Ensures clean modularity, strict separation of concerns, and ease of unit/widget testing.

- **Decision 1.2: Riverpod State Management without Code-Generation**
  - **Context:** Prompt specifies: "Riverpod (with code generation off, keep it simple and readable)".
  - **Decision:** Use vanilla `flutter_riverpod` providers (`StateNotifierProvider`, `NotifierProvider`, `ChangeNotifierProvider` where appropriate, `StateProvider`) with explicit types.
  - **Rationale:** Zero build runner overhead, transparent debugging, instant hot reload, and predictable state lifecycles.

- **Decision 1.3: GoRouter Navigation with Persistent Bottom Navigation Shell**
  - **Context:** Tab-based mobile application with deep-linking capability across Chrome web, Android, and iOS.
  - **Decision:** Implement `StatefulShellRoute.indexedStack` with custom page transitions and hero animations.
  - **Rationale:** Preserves scroll position across tabs (Home, Documents, Orders, Settings) while keeping navigation history tidy.

- **Decision 1.4: Hybrid Local Storage (Hive + SharedPreferences)**
  - **Context:** Full offline/demo experience with zero external backend requirement.
  - **Decision:** Use `shared_preferences` for system flags (auth token/pin, active locale, theme mode, onboarding seen) and `hive` / in-memory reactive stores for structured records (tests, packages, cart items, user orders, lab reports, chat messages, addresses, family profiles).
  - **Rationale:** High-performance, synchronous initialization, and zero SQL setup hassle on Flutter Web.

---

## 2. Desktop-First Testing with Mobile Viewport

- **Decision 2.1: Conditional DeviceFrame Wrapper**
  - **Context:** Testing is conducted in Chrome on laptops, yet the app must feel like an iPhone 15.
  - **Decision:** Inspect window width via `MediaQuery` / `kIsWeb`:
    - If window width > 500 px: Render centered iPhone 15 frame (390×844 logical pixels) surrounded by a branded luxury background, dynamic island, real-time status bar clock, and a floating desktop control dock.
    - If window width <= 500 px or native mobile: Render native full-screen layout.
  - **Rationale:** Seamless developer and stakeholder preview on desktop without needing an emulator or real device.

- **Decision 2.2: PointerDeviceKind Mouse-Drag Scroll Behavior**
  - **Context:** Standard Flutter web defaults disable mouse dragging on horizontal and vertical scroll views.
  - **Decision:** Configure a custom `AppScrollBehavior` extending `MaterialScrollBehavior` enabling `PointerDeviceKind.mouse`, `touch`, `trackpad`, and `stylus`.
  - **Rationale:** Ensures carousels, date strips, and bottom sheets can be swiped effortlessly using a laptop mouse or trackpad.

---

## 3. Design System: "Al Noor Light" & Dark Mode

- **Decision 3.1: Color System & Tokens**
  - `brandRed`: `#C81820` (Primary button, brand focal points)
  - `brandRedBright`: `#D0232A` (Gradient highlight)
  - `brandRose`: `#EF5A78` (Accent glow, charts, notification badges)
  - `brandCopper`: `#E5A274` (Signature secondary metallic warmth)
  - `brandPeach`: `#F6D9C3` (Soft surface tinting)
  - `ink`: `#111114` (High contrast primary text)
  - `inkSoft`: `#5B5B66` (Subdued secondary body)
  - `canvas`: `#FBF6F2` (Warm, non-glare off-white background)
  - `surface`: `#FFFFFF` (Card surfaces)
  - `success`: `#1E9E6A`, `warning`: `#F2A33A`, `danger`: `#B3261E` (Clinical result statuses)
  - Signature gradient: `LinearGradient(colors: [Color(0xFFE5A274), Color(0xFFD0232A), Color(0xFFC81820)], begin: Alignment.topLeft, end: Alignment.bottomRight)`

- **Decision 3.2: Typography Strategy**
  - English: `Plus Jakarta Sans` for display/headings, `Inter` for body/data tables.
  - Urdu: `Noto Nastaliq Urdu` for display headers, `Noto Sans Arabic` for crisp UI labels.
  - Offline fallback: System fonts with fallbacks ensure immediate rendering even before remote font assets load.

- **Decision 3.3: Interactive 3D Perspective Tilt**
  - Build `HeroCard3D` and `HealthCardWidget` with pointer hover / drag gesture detection applying 3D perspective transforms (`Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(..)..rotateY(..)`), with a specular reflection sweep layer that shifts as the cursor moves.

---

## 4. FakeApi & Demo Persistence Engine

- **Decision 4.1: Network Simulation Layer (`FakeApi`)**
  - **Context:** App needs to feel like it communicates with a cloud server.
  - **Decision:** Route all repository queries through a latency simulator with randomized delay (400–1000 ms), with option to toggle instant mode for tests.
  - **Rationale:** Verifies loading skeletons, shimmer states, and button progress indicators across all user flows.

- **Decision 4.2: Comprehensive Seed Data**
  - 4 Demo Users with dedicated profiles (Ahmed Raza, Ayesha Khan, Muhammad Usman, New User).
  - 120+ clinical tests (accurate PKR pricing, fasting requirements, sample tube types, turnaround times).
  - 10 comprehensive health packages with discount calculations.
  - 20 complete diagnostic reports featuring parameterized test results with normal/borderline/abnormal color ranges and doctor remarks.
  - Simulated rider live tracking on OpenStreetMap with moving coordinates, phlebotomist bio, ETA countdown, and status timeline.
  - 8 realistic customer support agents with topic-based conversational logic.
