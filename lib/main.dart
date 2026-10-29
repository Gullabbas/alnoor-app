import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_scroll_behavior.dart';
import 'core/widgets/device_frame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AlNoorApp(),
    ),
  );
}

class AlNoorApp extends ConsumerWidget {
  const AlNoorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(desktopThemeToggleProvider);
    final locale = ref.watch(desktopLocaleToggleProvider);

    return MaterialApp.router(
      title: 'Al Noor Diagnostic Centre',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ur', 'PK'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      scrollBehavior: const AppScrollBehavior(),
      routerConfig: appRouter,
      builder: (context, child) {
        return DeviceFrameWrapper(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
