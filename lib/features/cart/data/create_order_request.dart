import 'package:example/features/cart/data/order_item.dart';

class CreateOrderRequest {
  final List<OrderItem> items;
  final String tableId;

  CreateOrderRequest({required this.items, required this.tableId});

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'items': items.map((item) {
        return {'productId': item.product.id, 'quantity': item.quantity};
      }).toList(),
    };
  }
}
