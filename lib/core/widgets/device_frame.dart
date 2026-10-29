import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';

enum DevicePreset {
  iphone15('iPhone 15', Size(390, 844), 48.0),
  pixel8('Pixel 8', Size(412, 892), 40.0),
  smallPhone('Compact (360×640)', Size(360, 640), 32.0);

  final String label;
  final Size size;
  final double borderRadius;
  const DevicePreset(this.label, this.size, this.borderRadius);
}

class DevicePresetNotifier extends Notifier<DevicePreset> {
  @override
  DevicePreset build() => DevicePreset.iphone15;

  void setPreset(DevicePreset p) => state = p;
}

final devicePresetProvider = NotifierProvider<DevicePresetNotifier, DevicePreset>(
  () => DevicePresetNotifier(),
);

class DesktopThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() => state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  void setMode(ThemeMode mode) => state = mode;
}

final desktopThemeToggleProvider = NotifierProvider<DesktopThemeNotifier, ThemeMode>(
  () => DesktopThemeNotifier(),
);

class DesktopLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void toggle() => state = state.languageCode == 'en' ? const Locale('ur') : const Locale('en');
  void setLocale(Locale loc) => state = loc;
}

final desktopLocaleToggleProvider = NotifierProvider<DesktopLocaleNotifier, Locale>(
  () => DesktopLocaleNotifier(),
);

class DeviceFrameWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const DeviceFrameWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<DeviceFrameWrapper> createState() => _DeviceFrameWrapperState();
}

class _DeviceFrameWrapperState extends ConsumerState<DeviceFrameWrapper> {
  Timer? _clockTimer;
  DateTime _now = DateTime.now();
  bool _showCheatSheet = false;
  bool _isDockExpanded = false;

  @override
  void initState() {
    super.initState();
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() => _now = DateTime.now());
        }
      });
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    // Real mobile devices and mobile browsers (screen width <= 768px):
    // Render 100% full-bleed edge-to-edge native mobile UI.
    // No outer frame, no background watermark, no top dock covering the screen.
    final isWideDesktop = media.size.width > 768;

    if (!isWideDesktop) {
      return widget.child;
    }

    final preset = ref.watch(devicePresetProvider);
    final targetSize = preset.size;

    // Calculate scale factor if window height is tight
    final availableHeight = media.size.height - 40;
    final scale = (availableHeight / targetSize.height).clamp(0.65, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF130F10),
      body: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => Stack(
              children: [
          // Ambient luxury background with Al Noor soft glowing orbs
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.6, -0.6),
                  radius: 1.2,
                  colors: [
                    Color(0xFF2E1214),
                    Color(0xFF130F10),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -100,
            bottom: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.brandCopper.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Faint Al Noor branding watermark
          Positioned(
            left: 40,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/branding/logo-alnoor.png',
                      height: 48,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.local_hospital_rounded,
                        color: AppColors.brandCopper,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AL NOOR DIAGNOSTIC CENTRE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Better Diagnosis, Healthier Life • 40+ Years of Trust',
                          style: TextStyle(
                            color: AppColors.brandCopper,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Centered Phone Viewport
          Center(
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: targetSize.width,
                height: targetSize.height,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(preset.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.7),
                      blurRadius: 40,
                      spreadRadius: 8,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: AppColors.brandRed.withValues(alpha: 0.15),
                      blurRadius: 80,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF383335),
                    width: 3.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(preset.borderRadius - 3.5),
                  child: Stack(
                    children: [
                      // Inner App Screen with custom phone MediaQuery
                      Positioned.fill(
                        child: MediaQuery(
                          data: media.copyWith(
                            size: targetSize,
                            padding: const EdgeInsets.only(top: 44, bottom: 34),
                            viewPadding: const EdgeInsets.only(top: 44, bottom: 34),
                            viewInsets: EdgeInsets.zero,
                          ),
                          child: widget.child,
                        ),
                      ),

                      // Live Dynamic Status Bar Overlay
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 44,
                        child: _PhoneStatusBar(currentTime: _now),
                      ),

                      // iOS Home Indicator Bar
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 134,
                            height: 4.5,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Desktop Testing Toolbar Dock (Hidden by default, expands on click)
          Positioned(
            right: 28,
            top: 28,
            child: _isDockExpanded
                ? _DesktopDock(
                    onToggleCheatSheet: () {
                      setState(() => _showCheatSheet = !_showCheatSheet);
                    },
                    onCollapse: () {
                      setState(() {
                        _isDockExpanded = false;
                        _showCheatSheet = false;
                      });
                    },
                  )
                : InkWell(
                    onTap: () => setState(() => _isDockExpanded = true),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF221C1E).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF4A3E42)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune_rounded, size: 15, color: AppColors.brandCopper),
                          SizedBox(width: 8),
                          Text(
                            'Demo Tools',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.white54),
                        ],
                      ),
                    ),
                  ),
          ),

          // Credentials Cheat Sheet Overlay
          if (_showCheatSheet)
            Positioned(
              right: 28,
              top: 90,
              child: _CredentialsCheatSheetCard(
                onClose: () => setState(() => _showCheatSheet = false),
              ),
            ),
        ],
      ),
    ),
  ],
),
    );
  }
}

class _PhoneStatusBar extends StatelessWidget {
  final DateTime currentTime;

  const _PhoneStatusBar({required this.currentTime});

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('h:mm').format(currentTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            timeStr,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),

          // Dynamic Island Notch
          Container(
            width: 110,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF151515),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Signal, Wi-Fi, Battery icons
          const Row(
            children: [
              Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black87),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 14, color: Colors.black87),
              SizedBox(width: 5),
              Icon(Icons.battery_full_rounded, size: 18, color: Colors.black87),
            ],
          ),
        ],
      ),
    );
  }
}

class _DesktopDock extends ConsumerWidget {
  final VoidCallback onToggleCheatSheet;
  final VoidCallback onCollapse;

  const _DesktopDock({
    required this.onToggleCheatSheet,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(devicePresetProvider);
    final themeMode = ref.watch(desktopThemeToggleProvider);
    final currentLocale = ref.watch(desktopLocaleToggleProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF221C1E).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3D3235)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cheat sheet button
          _DockButton(
            icon: Icons.key_rounded,
            label: 'Demo Logins',
            tooltip: 'View Demo Credentials',
            onTap: onToggleCheatSheet,
          ),
          const _DockDivider(),

          // Language Toggle
          _DockButton(
            icon: Icons.translate_rounded,
            label: currentLocale.languageCode == 'en' ? 'اردو' : 'English',
            tooltip: 'Switch App Language',
            onTap: () {
              ref.read(desktopLocaleToggleProvider.notifier).toggle();
            },
          ),
          const _DockDivider(),

          // Dark/Light Toggle
          _DockButton(
            icon: themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            label: themeMode == ThemeMode.dark ? 'Light' : 'Dark',
            tooltip: 'Toggle Theme',
            onTap: () {
              ref.read(desktopThemeToggleProvider.notifier).toggle();
            },
          ),
          const _DockDivider(),

          // Device Switcher
          DropdownButtonHideUnderline(
            child: DropdownButton<DevicePreset>(
              value: preset,
              dropdownColor: const Color(0xFF221C1E),
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.brandCopper),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              items: DevicePreset.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p.label),
                );
              }).toList(),
              onChanged: (p) {
                if (p != null) {
                  ref.read(devicePresetProvider.notifier).setPreset(p);
                }
              },
            ),
          ),
          const _DockDivider(),

          // Hide / Collapse button
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 16, color: Colors.white70),
            tooltip: 'Collapse Tools',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: onCollapse,
          ),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onTap;

  const _DockButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.brandCopper),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockDivider extends StatelessWidget {
  const _DockDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: const Color(0xFF3D3235),
    );
  }
}

class _CredentialsCheatSheetCard extends StatelessWidget {
  final VoidCallback onClose;

  const _CredentialsCheatSheetCard({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1719),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF453438)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.medical_services_rounded, color: AppColors.brandRed, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Demo Logins',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white60, size: 18),
                onPressed: onClose,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Universal OTP: 1234  •  Universal PIN: 1234',
            style: TextStyle(
              color: AppColors.brandCopper,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          _credRow('0300 1234567', 'Ahmed Raza', 'Main (4 profiles, 12 reports)'),
          const SizedBox(height: 8),
          _credRow('0321 7654321', 'Ayesha Khan', 'Female (wellness, physio)'),
          const SizedBox(height: 8),
          _credRow('0333 1112223', 'M. Usman', 'Corporate / Embassy user'),
          const SizedBox(height: 8),
          _credRow('0345 0000000', 'New User', 'Fresh empty account'),
          const SizedBox(height: 14),
          const Text(
            'Tip: Click any number in the login screen to auto-fill!',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    ),
  );
}

  Widget _credRow(String phone, String name, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF281E21),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                phone,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  color: AppColors.brandPeach,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
