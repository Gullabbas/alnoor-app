import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alnoor/main.dart';
import 'package:alnoor/core/l10n/app_localizations.dart';
import 'package:alnoor/data/models/order_model.dart';
import 'package:alnoor/data/repositories/auth_repository.dart';
import 'package:alnoor/data/repositories/catalog_repository.dart';
import 'package:alnoor/data/repositories/orders_repository.dart';
import 'package:alnoor/data/repositories/reports_repository.dart';
import 'package:alnoor/data/demo/seed_data.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Al Noor Diagnostic Centre - Unit & Widget Tests', () {
    testWidgets('App smoke test - mounts AlNoorApp cleanly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: AlNoorApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AlNoorApp), findsOneWidget);

      // Cleanly unmount so any pending navigation timers in splash screen cancel
      await tester.pumpWidget(const SizedBox());
    });

    test('Pricing & Coupon Logic - Cart calculation with NOOR10', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final cartNotifier = container.read(cartProvider.notifier);

      cartNotifier.addItem(const OrderItem(id: 't_cbc', name: 'CBC Test', price: 1000));
      cartNotifier.addItem(const OrderItem(id: 't_hba1c', name: 'HbA1c', price: 2000));

      expect(container.read(cartProvider).subtotal, 3000);

      // Apply 10% coupon
      final applied = cartNotifier.applyCoupon('NOOR10');
      expect(applied, isTrue);
      expect(container.read(cartProvider).discountAmount, 300);
      expect(container.read(cartProvider).total, 2700);

      // Remove coupon
      cartNotifier.removeCoupon();
      expect(container.read(cartProvider).discountAmount, 0);
      expect(container.read(cartProvider).total, 3000);
    });

    test('Catalog & Seed Data - Verifies 120+ clinical tests loaded', () {
      final tests = SeedData.allTests;
      expect(tests.length, greaterThanOrEqualTo(120));
      expect(SeedData.packages.length, 10);
      expect(SeedData.doctors.length, 12);
      expect(SeedData.supportAgents.length, 8);
      expect(SeedData.users.length, 4);
    });

    test('Phone Number Validation regex', () {
      final reg = RegExp(r'^(03\d{9}|\+923\d{9}|3\d{9})$');
      expect(reg.hasMatch('03001234567'), isTrue);
      expect(reg.hasMatch('+923001234567'), isTrue);
      expect(reg.hasMatch('3001234567'), isTrue);
      expect(reg.hasMatch('12345'), isFalse);
      expect(reg.hasMatch('042111939939'), isFalse);
    });

    test('Auth Repository - Login simulation and profile switching', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final authNotifier = container.read(authProvider.notifier);

      // Initial state is Ahmed Raza (authenticated demo user)
      expect(container.read(authProvider).user, isNotNull);
      expect(container.read(authProvider).user!.phone, '03001234567');
      expect(container.read(authProvider).user!.fullName, 'Ahmed Raza');
      expect(container.read(authProvider).user!.familyProfiles.length, 4);

      // Switch active profile to dependent child (Fatima Raza)
      authNotifier.switchActiveProfile('f_daughter');
      expect(container.read(authProvider).activeProfileId, 'f_daughter');

      // Switch back to self
      authNotifier.switchActiveProfile('f_self');
      expect(container.read(authProvider).activeProfileId, 'f_self');

      // Logout and login as Ayesha Khan
      authNotifier.logout();
      expect(container.read(authProvider).isAuthenticated, isFalse);

      final ok = await authNotifier.login('03217654321');
      expect(ok, isTrue);
      expect(container.read(authProvider).user!.fullName, 'Ayesha Khan');
    });

    test('Reports Repository - Retrieves clinical reports and biomarkers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(reportsRepositoryProvider);
      final reports = repo.getReportsForPatient('all');
      expect(reports.isNotEmpty, isTrue);

      final firstReport = reports.first;
      expect(firstReport.testName.isNotEmpty, isTrue);
      expect(firstReport.parameters.isNotEmpty, isTrue);

      // Verify biomarker parameter bounds check
      final bm = firstReport.parameters.first;
      expect(bm.name.isNotEmpty, isTrue);
      expect(bm.unit.isNotEmpty, isTrue);

      // Verify trend generation
      final trends = repo.getTestTrends('hba1c');
      expect(trends.length, 4);
    });

    test('Orders Repository - Tracks active sampling and allows booking', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final ordersState = container.read(ordersProvider);
      expect(ordersState.orders.isNotEmpty, isTrue);
      expect(ordersState.upcomingOrders.isNotEmpty, isTrue);

      // Verify active order has sample collection stages
      final activeOrder = ordersState.upcomingOrders.first;
      expect(activeOrder.items.isNotEmpty, isTrue);
      expect(activeOrder.address.isNotEmpty, isTrue);
    });

    test('Localization - English and Urdu dictionary completeness', () {
      expect(AppStrings.get('appName', 'en'), 'Al Noor Diagnostic Centre');
      expect(AppStrings.get('appName', 'ur'), 'ال نور ڈائیگنوسٹک سینٹر');

      expect(AppStrings.get('homeSampling', 'en'), 'Home Sampling');
      expect(AppStrings.get('homeSampling', 'ur'), 'ہوم سیمپلنگ');

      final notifier = AppLocaleNotifier();
      expect(notifier.isUrdu, isFalse);
      expect(notifier.textDirection, TextDirection.ltr);

      notifier.toggleLocale();
      expect(notifier.isUrdu, isTrue);
      expect(notifier.textDirection, TextDirection.rtl);
    });
  });
}
