import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../demo/seed_data.dart';
import '../models/test_model.dart';
import '../models/order_model.dart';

class CartState {
  final List<OrderItem> items;
  final String? appliedCoupon;
  final double discountPercent;

  const CartState({
    this.items = const [],
    this.appliedCoupon,
    this.discountPercent = 0.0,
  });

  int get subtotal {
    return items.fold<int>(0, (sum, item) => sum + item.price);
  }

  int get discountAmount {
    return (subtotal * (discountPercent / 100)).round();
  }

  int get total {
    final t = subtotal - discountAmount;
    return t > 0 ? t : 0;
  }

  int get itemCount => items.length;

  bool containsItem(String id) {
    return items.any((item) => item.id == id);
  }

  CartState copyWith({
    List<OrderItem>? items,
    String? appliedCoupon,
    double? discountPercent,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    return const CartState();
  }

  void addItem(OrderItem item) {
    if (!state.containsItem(item.id)) {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((i) => i.id != id).toList(),
    );
  }

  bool applyCoupon(String code) {
    final upper = code.trim().toUpperCase();
    if (upper == 'NOOR10') {
      state = state.copyWith(appliedCoupon: 'NOOR10', discountPercent: 10.0);
      return true;
    } else if (upper == 'WELCOME20') {
      state = state.copyWith(appliedCoupon: 'WELCOME20', discountPercent: 20.0);
      return true;
    } else if (upper == 'ALNOOR30') {
      state = state.copyWith(appliedCoupon: 'ALNOOR30', discountPercent: 30.0);
      return true;
    }
    return false;
  }

  void removeCoupon() {
    state = state.copyWith(appliedCoupon: null, discountPercent: 0.0);
  }

  void clearCart() {
    state = const CartState();
  }
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() => CartNotifier());

class CatalogRepository {
  List<TestModel> getTests({String? category, String? query}) {
    var list = SeedData.allTests;
    if (category != null && category.isNotEmpty && category != 'All') {
      list = list.where((t) => t.category.toLowerCase() == category.toLowerCase()).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((t) =>
          t.name.toLowerCase().contains(q) ||
          t.category.toLowerCase().contains(q) ||
          t.description.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  List<PackageModel> getPackages({String? query}) {
    var list = SeedData.packages;
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((p) =>
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  TestModel? getTestById(String id) {
    try {
      return SeedData.allTests.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  PackageModel? getPackageById(String id) {
    try {
      return SeedData.packages.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) => CatalogRepository());
