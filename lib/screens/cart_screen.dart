import 'package:example/models/order_item.dart';
import 'package:example/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + item.getSubtotal(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ hàng")),

      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text('Giỏ hàng đang trống'))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: const Icon(Icons.local_cafe),

                        title: Text(
                          item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .decrease(item.product);
                              },
                            ),

                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Increase
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .increaseItem(item.product);
                              },
                            ),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Text('${item.getSubtotal().toStringAsFixed(0)} đ'),

                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),

                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .remove(item.product);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Tổng tiền:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '${total.toStringAsFixed(0)} đ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: cartItems.isEmpty
                        ? null
                        : () {
                            ref.read(cartProvider.notifier).clear();

                            Navigator.pop(context);
                          },

                    child: const Text('Thanh toán'),
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
