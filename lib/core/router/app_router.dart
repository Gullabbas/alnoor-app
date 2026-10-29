import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/main_scaffold.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/language_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/pin_screen.dart';
import '../../features/auth/presentation/profile_selection_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/branches_screen.dart';
import '../../features/home/presentation/notifications_screen.dart';
import '../../features/home/presentation/offers_screen.dart';
import '../../features/catalog/presentation/tests_screen.dart';
import '../../features/catalog/presentation/packages_screen.dart';
import '../../features/catalog/presentation/package_detail_screen.dart';
import '../../features/booking/presentation/cart_screen.dart';
import '../../features/booking/presentation/book_sampling_screen.dart';
import '../../features/booking/presentation/order_success_screen.dart';
import '../../features/booking/presentation/radiology_booking_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/orders/presentation/order_detail_screen.dart';
import '../../features/reports/presentation/documents_screen.dart';
import '../../features/reports/presentation/report_detail_screen.dart';
import '../../features/reports/presentation/trends_screen.dart';
import '../../features/health/presentation/my_health_screen.dart';
import '../../features/health/presentation/health_cards_screen.dart';
import '../../features/doctors/presentation/doctors_screen.dart';
import '../../features/doctors/presentation/consultation_screen.dart';
import '../../features/chat/presentation/ai_assistant_screen.dart';
import '../../features/chat/presentation/live_chat_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/edit_profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _docNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _orderNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingNavKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: '/pin',
      builder: (context, state) => const PinScreen(),
    ),
    GoRoute(
      path: '/profile-select',
      builder: (context, state) => const ProfileSelectionScreen(),
    ),

    // Stateful Nested Bottom Shell Route
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _docNavKey,
          routes: [
            GoRoute(
              path: '/documents',
              builder: (context, state) => const DocumentsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _orderNavKey,
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingNavKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Modals and Flow Routes
    GoRoute(
      path: '/tests',
      builder: (context, state) => const TestsScreen(),
    ),
    GoRoute(
      path: '/packages',
      builder: (context, state) => const PackagesScreen(),
    ),
    GoRoute(
      path: '/package-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'pkg_exec_fasting';
        return PackageDetailScreen(packageId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/book-sampling',
      builder: (context, state) => const BookSamplingScreen(),
    ),
    GoRoute(
      path: '/order-success/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'ord_1';
        return OrderSuccessScreen(orderId: id);
      },
    ),
    GoRoute(
      path: '/order/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'ord_1';
        return OrderDetailScreen(orderId: id);
      },
    ),
    GoRoute(
      path: '/report/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'rep_1';
        return ReportDetailScreen(reportId: id);
      },
    ),
    GoRoute(
      path: '/trends/:type',
      builder: (context, state) {
        final type = state.pathParameters['type'] ?? 'hba1c';
        return TrendsScreen(initialTest: type);
      },
    ),
    GoRoute(
      path: '/my-health',
      builder: (context, state) => const MyHealthScreen(),
    ),
    GoRoute(
      path: '/health-cards',
      builder: (context, state) => const HealthCardsScreen(),
    ),
    GoRoute(
      path: '/doctors',
      builder: (context, state) => const DoctorsScreen(),
    ),
    GoRoute(
      path: '/consultation/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'doc_safdar';
        return ConsultationCallScreen(doctorId: id);
      },
    ),
    GoRoute(
      path: '/ai-assistant',
      builder: (context, state) => const AiAssistantScreen(),
    ),
    GoRoute(
      path: '/live-chat',
      builder: (context, state) => const LiveChatScreen(),
    ),
    GoRoute(
      path: '/radiology-booking',
      builder: (context, state) => const RadiologyBookingScreen(),
    ),
    GoRoute(
      path: '/branches',
      builder: (context, state) => const BranchesScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/offers',
      builder: (context, state) => const OffersScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
  ],
);
