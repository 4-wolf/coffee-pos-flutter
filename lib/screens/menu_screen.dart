import 'package:example/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  static final List<Product> products = [
    Product(name: 'Coffee', price: 30000),
    Product(name: 'Milk Tea', price: 40000),
    Product(name: 'Cake', price: 25000),
    Product(name: 'Juice', price: 35000),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartLength = ref.watch(cartProvider.select((cart) => cart.length));

    // final cartCount = ref.watch(cartProvider).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Coffee Menu"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cartLength > 0)
                Positioned(
                  right: 3,
                  top: 3,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartLength',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: GridView.builder(
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
                SnackBar(
                  content: Text('Đã thêm ${product.name}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
