import 'package:example/features/menu/providers/cart_provider.dart';
import 'package:example/features/menu/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'product_card.dart';
import '../../cart/presentation/cart_screen.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final cartCount = ref.watch(
                cartProvider.select(
                  (cart) =>
                      cart.fold<int>(0, (sum, item) => sum + item.quantity),
                ),
              );

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );

                      if (result == true && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Thanh toán thành công!'),
                          ),
                        );
                      }
                    },
                  ),

                  if (cartCount > 0)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 9,
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      body: productsAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60),

                const SizedBox(height: 16),

                const Text(
                  'Không thể tải menu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(productsProvider);
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        },

        data: (products) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductCard(
                product: product,
                onTap: () {
                  ref.read(cartProvider.notifier).add(product);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã thêm ${product.name}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
