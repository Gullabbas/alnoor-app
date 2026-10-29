# Al Noor Diagnostic Centre - QA Verification Checklist

This document provides a comprehensive test protocol for QA engineers and stakeholders to verify every screen, user journey, edge case, and interaction in the **Al Noor Diagnostic Centre** mobile application.

---

## 1. Demo User Profiles & Credentials

| User Name | Phone Number | OTP | PIN | Profile Characteristics / Test Focus |
|---|---|---|---|---|
| **Ahmed Raza** | `0300 1234567` | `1234` | `1234` | Primary family head with 4 profiles (Ahmed, Mother Fatima, Wife Ayesha, Daughter Zainab). 12 historical & active reports, active home sampling order en-route. |
| **Ayesha Khan** | `0321 7654321` | `1234` | `1234` | Wellness-focused user. Cardiac tests, Physiotherapy, Psychology consultations, Gold health card. |
| **Muhammad Usman** | `0333 1112223` | `1234` | `1234` | Corporate & Embassy user. Executive Health Package, Embassy Medicals, Gulf visa clearance documents. |
| **New User** | `0345 0000000` | `1234` | `1234` | Fresh clean account. Zero orders, zero reports. Verifies all empty states, onboarding hints, and first-time booking flows. |

> **Desktop Dock Shortcut:** When running on desktop web or large displays (>500px), click the **Demo Logins** icon in the top-right toolbar to open the quick-login cheat sheet and 1-click fill buttons.

---

## 2. Screen-by-Screen Test Cases

### 2.1. Onboarding & Authentication Flow
- [ ] **Splash Screen (`/splash`):**
  - Verify high-resolution Al Noor Diagnostic Centre emblem, gold foil accents, and founder attribution (*Prof. Dr. Safdar Ali Malik, Est. 1983*).
  - Verify smooth fade-in and automatic transition to Language Selection or Home within 2.6s.
- [ ] **Language Selection Screen (`/language`):**
  - Verify English (LTR) and Urdu (RTL) cards with authentic translations.
  - Selecting Urdu flips the entire application into RTL layout instantly.
- [ ] **Onboarding Carousel (`/onboarding`):**
  - Verify 3 value proposition slides (Home Sampling, 1500+ Tests & 128-Slice MDCT, Instant Online Reports).
  - Verify "Skip" jumps directly to Login. "Next" advances slides. "Get Started" opens Login.
- [ ] **Login Screen (`/login`):**
  - Verify `+92` fixed Pakistani country prefix.
  - Verify valid phone numbers (`03001234567`, `+923001234567`, `3001234567`) are accepted.
  - Verify quick demo user buttons auto-fill credentials.
  - Verify "Continue as Guest" allows full catalog exploration.
- [ ] **OTP Screen (`/otp`):**
  - Verify 4-box PIN input with autofocus.
  - Test invalid OTP shows red error toast; universal demo code `1234` triggers success.
  - Verify resend countdown timer (30s).
- [ ] **PIN Screen (`/pin`):**
  - Verify custom on-screen numeric keypad with tactile haptics.
  - Test PIN `1234` successfully unlocks session.
- [ ] **Profile Selection Screen (`/profile-selection`):**
  - Verify family avatar carousel (Ahmed, Mother, Wife, Daughter).
  - Switching avatar switches active patient context throughout the app.

---

### 2.2. Home Feed & Navigation (`/home`)
- [ ] **Header & Profile Bar:**
  - Displays greeting with active patient name, patient ID (`ALN-XXXXXX`), and notification bell badge.
  - Displays emergency UAN hotline button (`042 111 939 939`) and WhatsApp chat (`0308 113 9009`).
- [ ] **Hero 3D Tilt Card:**
  - Tilt on mouse hover or touch drag: verify realistic 3D perspective pitch/roll and moving specular light glare.
  - Shows Al Noor Health Pass status, loyalty health points, and "Book Sampling" shortcut.
- [ ] **Quick Action Grid:**
  - `Home Sampling`: Opens 7-step booking wizard.
  - `View Reports`: Opens My Documents tab.
  - `Talk to Doctor`: Opens Consultant Directory.
  - `Health Packages`: Opens curated wellness catalog.
- [ ] **Specialized Clinical Services:**
  - Radiology & MDCT, Cardiac Care, Neuro EEG, Physiotherapy, Embassy Medicals, Corporate Care.
- [ ] **Special Offers Banner Carousel:**
  - Verifies promotional banners with discount codes (`NOOR10`, `HEALTH20`, `FREESAMPLE`).
- [ ] **9 Reasons to Choose Al Noor Section:**
  - Interactive cards highlighting 40+ years legacy, ISO-15189 accreditation, 128-slice CT, barcoded vacutainer safety, etc.
- [ ] **Branches Directory (`/branches`):**
  - Displays Lahore branches (Shadman Flagship, Gulberg, DHA Phase 5, Johar Town, Faisal Town) with Google Maps navigation links.

---

### 2.3. Clinical Catalog & Search (`/catalog` & `/packages`)
- [ ] **Search & Real-Time Filtering:**
  - Typing "CBC", "Sugar", "Lipid", "Vitamin", "MRI", "CT" yields instantaneous instant-filtered results.
  - Department filter chips: *All, Pathology, Radiology, Cardiac, Neuro, Specialized*.
- [ ] **Test Card Details:**
  - Verify test title, sample type (Blood, Urine, Swab), fasting requirements badge, turnaround time (TAT: 4h, Same Day, 24h), and PKR price.
  - Clicking "Add to Cart" increments cart badge and displays floating snackbar confirmation.
- [ ] **Package Detail View (`/package-detail`):**
  - Shows breakdown of all individual tests bundled in package.
  - Highlights savings vs separate test ordering.

---

### 2.4. Commerce Flow & Home Sampling Booking (`/cart` & `/booking`)
- [ ] **Cart Screen (`/cart`):**
  - Verify itemized price breakdown (Subtotal, Home Sampling Fee Rs. 200, Discount).
  - Test coupon validation:
    - Apply `NOOR10`: confirms 10% discount subtracted.
    - Apply `FREESAMPLE`: waives Rs. 200 home sampling fee.
    - Apply `INVALID`: displays user-friendly error message.
  - Patient Assignment: Allows assigning specific tests to different family members.
- [ ] **7-Step Home Sampling Wizard (`/booking`):**
  - Step 1: Select or enter sampling address in Lahore (Shadman, Gulberg, DHA, etc.).
  - Step 2: Date picker (Today, Tomorrow, Custom).
  - Step 3: Time slot selector (Morning 7-9 AM, 9-11 AM, Afternoon, Evening).
  - Step 4: Special clinical instructions (Fasting status, wheelchair required, pediatric butterfly needle).
  - Step 5: Prescription upload (Take photo / Choose from gallery simulation).
  - Step 6: Payment method selection (Cash on Sampling, JazzCash, Easypaisa, Credit/Debit Card).
  - Step 7: Final review and confirm.
- [ ] **Order Success Screen (`/order-success`):**
  - Confetti burst animation (`confetti: ^0.8.0`).
  - Displays unique Booking Reference ID (`ALN-ORD-XXXX`).
  - "Track Phlebotomist" button navigates to live order tracking.

---

### 2.5. Order Tracking & Phlebotomist Dispatch (`/orders` & `/order-detail`)
- [ ] **Orders List Tab (`/orders`):**
  - Filter segmented tabs: *Active / Upcoming*, *Completed*, *Cancelled*.
- [ ] **Live Phlebotomist Tracker (`/order-detail`):**
  - Step timeline: *Booked -> Phlebotomist Assigned -> On the Way -> Sample Collected -> Lab Processing -> Report Ready*.
  - Rider Card: Phlebotomist name, photo, motorcycle registration (`LEE-1234`), 4.9-star rating, direct Call and WhatsApp buttons.
  - Live Map preview with ETA timer countdown.
  - Real-time sample barcode scan confirmation.

---

### 2.6. Health Records, Reports & Longitudinal Trends (`/documents`)
- [ ] **Documents List (`/documents`):**
  - Filter tabs: *All, Pathology, Radiology, Cardiology, Prescriptions, Invoices*.
  - Status indicators: *Normal (Green)*, *Attention / Critical (Amber/Red)*, *Pending (Blue)*.
- [ ] **Report Detail View (`/report-detail`):**
  - Clinical report header with patient demographics, barcode, pathologist sign-off.
  - Biomarker parameter table: Name, Result Value, Unit, Reference Range, and Visual Range Gauge.
  - Out-of-range values highlighted in high-contrast amber/red warning badges.
  - "Share PDF" and "Download Report" trigger simulated PDF generator.
- [ ] **Longitudinal Biomarker Trends (`/trends`):**
  - Interactive line charts (`fl_chart: ^1.3.0`) for HbA1c, Fasting Blood Glucose, Vitamin D, and Lipid Profile across multiple visits.
  - Normal reference range shaded band overlay.

---

### 2.7. Al Noor Health Pass & 3D Metallic Cards (`/health-cards`)
- [ ] **3D Metallic Health Card Widget:**
  - Interactive 3D tilt responding to pointer/touch gestures.
  - Front view: Al Noor embossed crest, Patient Name, Membership Tier (Blue / Silver / Gold / Executive), QR code, barcode, issue date.
  - Tap "Flip Card" for emergency blood group, allergies, and emergency phone contacts.

---

### 2.8. Support, Care & AI Assistant (`/chat` & `/ai-assistant`)
- [ ] **Live Chat Support (`/live-chat`):**
  - 8 real support agents with photo, designation, and online status.
  - Quick inquiry pills: *Sample Collection Timing, Report Status, Pricing Inquiry, Radiology Booking*.
  - Realistic typing indicator animation and automated intelligent responses.
- [ ] **Al Noor AI Health Orb (`/ai-assistant`):**
  - Pulsing dynamic AI sphere animation.
  - Answers clinical test preparation questions (e.g., "Do I need to fast for Lipid Profile?", "When will my CBC report be ready?").

---

### 2.9. Localization & RTL Verification
- [ ] **English Mode:**
  - Verified left-to-right alignment, clean modern typography, left-aligned chevrons and back buttons.
- [ ] **Urdu Mode:**
  - Verified right-to-left layout, correct mirrored chevrons and icons.
  - Authentic Nastaliq-styled Urdu translations (no awkward machine translation).

---

### 2.10. Desktop Viewport & Device Frame
- [ ] **Responsive Adaptation:**
  - Screen width < 500px: Full-bleed native mobile layout.
  - Screen width > 500px: Centered iPhone 15 frame (390×844) with live dynamic status bar (clock, battery, Wi-Fi).
  - Floating Desktop Dock:
    - "Demo Logins" cheat sheet modal.
    - English / Urdu instant toggle.
    - Light / Dark mode instant toggle.
    - Device switcher (iPhone 15, Pixel 8, iPad Mini, Fullscreen).
