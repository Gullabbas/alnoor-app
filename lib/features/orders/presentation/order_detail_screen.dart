import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/orders_repository.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  void _callRider(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _chatWithRider() async {
    final uri = Uri.parse('https://wa.me/923014455667');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this home sampling appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Keep Appointment'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              ref.read(ordersProvider.notifier).cancelOrder(orderId, 'Cancelled by patient');
              Navigator.of(ctx).pop();
              AppToast.show(context, title: 'Booking Cancelled', type: ToastType.warning);
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final order = orders.getById(orderId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final isEnRoute = order.status == OrderStatus.onTheWay;

    return Scaffold(
      appBar: AppBar(
        title: Text(order.bookingNumber),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Map Tracking Simulation (if on the way)
            if (isEnRoute) ...[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF261D20) : const Color(0xFFF0E5DC),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.brandCopper),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Simulated Map Route Pattern
                    CustomPaint(
                      size: const Size(double.infinity, 200),
                      painter: _MapRoutePainter(),
                    ),

                    // Rider Marker
                    Positioned(
                      left: 120,
                      top: 70,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '🛵 Phlebotomist',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Icon(Icons.location_on, color: AppColors.brandRed, size: 36),
                        ],
                      ),
                    ),

                    // Destination Marker
                    const Positioned(
                      right: 50,
                      bottom: 40,
                      child: Column(
                        children: [
                          Icon(Icons.home, color: AppColors.success, size: 30),
                          Text('You', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),

                    // ETA Overlay Badge
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.brandCopper),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_rounded, color: AppColors.brandCopper, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Arriving in ${order.etaMinutes} minutes',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Rider Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.brandPeach,
                      child: const Icon(Icons.person, color: AppColors.brandRed, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.rider?.name ?? 'Tariq Mehmood',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '⭐ ${order.rider?.rating ?? 4.9} • ${order.rider?.vehicle ?? "Honda 125"}',
                            style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.phone, color: AppColors.success, size: 20),
                      ),
                      onPressed: () => _callRider(order.rider?.phone ?? '+923014455667'),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chat_bubble, color: AppColors.success, size: 20),
                      ),
                      onPressed: _chatWithRider,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Status Timeline
            const Text('Sampling Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),

            _buildTimeline(order.status, isDark),
            const SizedBox(height: 24),

            // Order Items & Pricing
            const Text('Tests Ordered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                children: [
                  ...order.items.map((i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(i.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                            Text('PKR ${i.price}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                          ],
                        ),
                      )),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total (Paid via ' , style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
                      Text(order.paymentMethod, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      const Spacer(),
                      Text('PKR ${order.total}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.brandRed)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Cancel / Reschedule Actions
            if (order.status != OrderStatus.cancelled && order.status != OrderStatus.reportReady) ...[
              AppButton(
                text: 'Cancel Appointment',
                variant: AppButtonVariant.danger,
                onPressed: () => _showCancelDialog(context, ref, order.id),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(OrderStatus current, bool isDark) {
    final stages = [
      {'status': OrderStatus.booked, 'title': 'Booked & Confirmed', 'desc': 'Scheduled in Al Noor Central Dispatch'},
      {'status': OrderStatus.phlebotomistAssigned, 'title': 'Phlebotomist Assigned', 'desc': 'Cold-chain collection kit prepared'},
      {'status': OrderStatus.onTheWay, 'title': 'On The Way', 'desc': 'Rider is en route to your location'},
      {'status': OrderStatus.sampleCollected, 'title': 'Sample Collected', 'desc': 'Barcoded and temperature verified'},
      {'status': OrderStatus.processing, 'title': 'Processing in Lab', 'desc': 'Automated digital analyzers at Shadman'},
      {'status': OrderStatus.reportReady, 'title': 'Report Ready', 'desc': 'Consultant digital signature verified'},
    ];

    final currentIndex = stages.indexWhere((s) => s['status'] == current);

    return Column(
      children: List.generate(stages.length, (idx) {
        final stage = stages[idx];
        final isDone = idx <= (currentIndex == -1 ? 0 : currentIndex);
        final isLast = idx == stages.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDone ? AppColors.brandRed : (isDark ? Colors.white12 : Colors.black12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone ? Icons.check : Icons.circle,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 38,
                    color: isDone ? AppColors.brandRed : (isDark ? Colors.white12 : Colors.black12),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage['title'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: isDone ? (isDark ? AppColors.darkText : AppColors.ink) : AppColors.inkLighter,
                    ),
                  ),
                  Text(
                    stage['desc'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.brandRed.withValues(alpha: 0.4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(120, 100)
      ..cubicTo(160, 60, 220, 140, size.width - 50, size.height - 40);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
