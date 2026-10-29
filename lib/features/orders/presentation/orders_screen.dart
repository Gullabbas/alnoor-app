import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/orders_repository.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(ordersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.brandRed,
          labelColor: AppColors.brandRed,
          unselectedLabelColor: isDark ? AppColors.darkTextSoft : AppColors.inkSoft,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'Upcoming (${ordersState.upcomingOrders.length})'),
            Tab(text: 'Completed (${ordersState.completedOrders.length})'),
            Tab(text: 'Cancelled (${ordersState.cancelledOrders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(ordersState.upcomingOrders, 'No Upcoming Bookings', 'Schedule a certified phlebotomist visit to your home.', true, isDark),
          _buildOrderList(ordersState.completedOrders, 'No Completed Bookings', 'Completed orders and their reports will appear here.', false, isDark),
          _buildOrderList(ordersState.cancelledOrders, 'No Cancelled Orders', 'You have no cancelled appointments.', false, isDark),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> list, String emptyTitle, String emptyMsg, bool canBook, bool isDark) {
    if (list.isEmpty) {
      return EmptyState(
        icon: Icons.local_shipping_outlined,
        title: emptyTitle,
        message: emptyMsg,
        actionText: canBook ? 'Book Home Sampling' : null,
        onAction: canBook ? () => context.push('/book-sampling') : null,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, idx) {
        final order = list[idx];
        return _OrderCard(order: order, isDark: isDark);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const _OrderCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (order.status) {
      case OrderStatus.booked:
      case OrderStatus.phlebotomistAssigned:
      case OrderStatus.onTheWay:
        statusColor = AppColors.brandRed;
        break;
      case OrderStatus.sampleCollected:
      case OrderStatus.processing:
        statusColor = AppColors.warning;
        break;
      case OrderStatus.reportReady:
        statusColor = AppColors.success;
        break;
      case OrderStatus.cancelled:
        statusColor = AppColors.danger;
        break;
    }

    return GestureDetector(
      onTap: () => context.push('/order/${order.id}'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking No & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.bookingNumber,
                  style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w800, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Patient & Address
            Text(
              'Patient: ${order.patientName} (${order.patientId})',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 3),
            Text(
              '${DateFormat("dd MMM yyyy").format(order.scheduledDate)} • ${order.timeSlot}',
              style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
            ),
            const SizedBox(height: 10),

            // Items Count & Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} ${order.items.length == 1 ? "Test" : "Tests"} included',
                  style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
                ),
                Text(
                  'PKR ${order.total}',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.brandRed, fontSize: 15),
                ),
              ],
            ),
            const Divider(height: 20),

            // Track Rider button or View Details
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == OrderStatus.onTheWay) ...[
                  const Icon(Icons.location_on, color: AppColors.brandRed, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Track Rider Live',
                    style: TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ] else ...[
                  const Text(
                    'View Order Details >',
                    style: TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
