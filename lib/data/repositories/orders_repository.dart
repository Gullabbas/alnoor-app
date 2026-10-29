import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../demo/fake_api.dart';
import '../demo/seed_data.dart';
import '../models/order_model.dart';

class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
  });

  List<OrderModel> get upcomingOrders => orders
      .where((o) =>
          o.status == OrderStatus.booked ||
          o.status == OrderStatus.phlebotomistAssigned ||
          o.status == OrderStatus.onTheWay ||
          o.status == OrderStatus.sampleCollected ||
          o.status == OrderStatus.processing)
      .toList();

  List<OrderModel> get completedOrders => orders
      .where((o) => o.status == OrderStatus.reportReady)
      .toList();

  List<OrderModel> get cancelledOrders => orders
      .where((o) => o.status == OrderStatus.cancelled)
      .toList();

  OrderModel? getById(String id) {
    try {
      return orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OrdersNotifier extends Notifier<OrdersState> {
  @override
  OrdersState build() {
    return OrdersState(orders: List<OrderModel>.from(SeedData.orders));
  }

  Future<OrderModel> createBooking({
    required String patientId,
    required String patientName,
    required String address,
    required DateTime date,
    required String timeSlot,
    required List<OrderItem> items,
    required int subtotal,
    required int discount,
    required int total,
    required String paymentMethod,
  }) async {
    state = state.copyWith(isLoading: true);
    await FakeApi.delay(600, 1000);

    final bookingNum = 'ANDC-2026-${(1000 + Random().nextInt(9000))}';
    final newOrder = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      bookingNumber: bookingNum,
      patientId: patientId,
      patientName: patientName,
      address: address,
      scheduledDate: date,
      timeSlot: timeSlot,
      items: items,
      subtotal: subtotal,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      status: OrderStatus.onTheWay,
      createdAt: DateTime.now(),
      rider: const PhlebotomistRider(
        name: 'Tariq Mehmood',
        phone: '+92 301 4455667',
        rating: 4.9,
        vehicle: 'Honda 125 (LEP-4412)',
        photoUrl: '',
        latitude: 31.5165,
        longitude: 74.2850,
      ),
      etaMinutes: 18,
    );

    state = state.copyWith(
      orders: [newOrder, ...state.orders],
      isLoading: false,
    );

    return newOrder;
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    state = state.copyWith(isLoading: true);
    await FakeApi.delay(400, 700);

    final updated = state.orders.map((o) {
      if (o.id == orderId) {
        return o.copyWith(
          status: OrderStatus.cancelled,
          cancellationReason: reason,
        );
      }
      return o;
    }).toList();

    state = state.copyWith(orders: updated, isLoading: false);
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, OrdersState>(() => OrdersNotifier());
