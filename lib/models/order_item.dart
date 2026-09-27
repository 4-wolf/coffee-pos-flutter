import 'package:example/models/product.dart';

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({required this.product, required this.quantity});

  double getSubtotal() {
    return product.price * quantity;
  }
}
