import 'package:example/features/cart/data/order_item.dart';
import 'package:example/features/menu/data/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends Notifier<List<OrderItem>> {
  @override
  List<OrderItem> build() => [];

  void add(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      // món chưa có: thêm mới
      state = [...state, OrderItem(product: product, quantity: 1)];
    } else {
      // món đã có: tăng số lượng
      final oldItem = state[index];

      final newItem = OrderItem(
        product: oldItem.product,
        quantity: oldItem.quantity + 1,
      );

      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) newItem else state[i],
      ];
    }
  }

  void remove(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void increaseItem(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      return;
    }
    final oldItem = state[index];

    final newItem = OrderItem(
      product: oldItem.product,
      quantity: oldItem.quantity + 1,
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) newItem else state[i],
    ];
  }

  void decrease(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      return;
    }
    final oldItem = state[index];

    if (oldItem.quantity == 1) {
      remove(product);
      return;
    }
    final newItem = OrderItem(
      product: oldItem.product,
      quantity: oldItem.quantity - 1,
    );

    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) newItem else state[i],
    ];
  }

  void clear() => state = [];
}

// Đăng ký bean
final cartProvider = NotifierProvider<CartNotifier, List<OrderItem>>(
  CartNotifier.new,
);

final cartTotalProvide = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold(0.0, (sum, item) => sum + item.getSubtotal());
});
