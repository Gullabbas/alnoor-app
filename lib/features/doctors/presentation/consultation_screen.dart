import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/demo/seed_data.dart';

class ConsultationCallScreen extends StatefulWidget {
  final String doctorId;

  const ConsultationCallScreen({super.key, required this.doctorId});

  @override
  State<ConsultationCallScreen> createState() => _ConsultationCallScreenState();
}

class _ConsultationCallScreenState extends State<ConsultationCallScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool _isMuted = false;
  bool _isVideoOff = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTimer() {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final doc = SeedData.doctors.firstWhere(
      (d) => d.id == widget.doctorId,
      orElse: () => SeedData.doctors.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF140F11),
      body: SafeArea(
        child: Stack(
          children: [
            // Center Doctor Video Simulation
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandRed.withValues(alpha: 0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 70),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    doc.name,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doc.specialty,
                    style: const TextStyle(color: AppColors.brandCopper, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimer(),
                          style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Call Controls
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _callActionBtn(
                    icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    color: _isMuted ? Colors.amber : Colors.white24,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _callActionBtn(
                    icon: _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                    color: _isVideoOff ? Colors.amber : Colors.white24,
                    onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                  ),
                  _callActionBtn(
                    icon: Icons.call_end_rounded,
                    color: AppColors.danger,
                    iconColor: Colors.white,
                    onTap: () {
                      context.pop();
                      AppToast.show(context, title: 'Consultation Ended', message: 'E-Prescription notes will be available shortly', type: ToastType.info);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _callActionBtn({required IconData icon, required Color color, Color iconColor = Colors.white, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}
