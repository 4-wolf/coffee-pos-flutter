import 'package:example/features/cart/data/order_item.dart';

class CreateOrderRequest {
  final List<OrderItem> items;
  final String tableId;

  CreateOrderRequest({required this.items, required this.tableId});

  Map<String, dynamic> toJson() => {
    'tableId': tableId,
    'items': items
        .map((i) => {'productId': i.product.id, 'quantity': i.quantity})
        .toList(),
  };
}
