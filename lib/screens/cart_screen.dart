import 'package:example/models/order_item.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<OrderItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotal() {
    return widget.cartItems.fold(
      0,
      (total, item) => total + item.getSubtotal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,

              itemBuilder: (context, index) {
                final item = widget.cartItems[index];

                return ListTile(
                  leading: const Icon(Icons.local_cafe),

                  title: Text(item.product.name),

                  subtitle: Text('Số lượng: ${item.quantity}'),

                  trailing: Text('${item.getSubtotal().toStringAsFixed(0)} đ'),
                );
              },
            ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  'Tổng tiền:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                Text(
                  '${getTotal().toStringAsFixed(0)} đ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
