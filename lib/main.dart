import 'package:example/features/menu/presentation/menu_screen.dart';
import 'package:example/features/menu/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coffee POS',
      home: const MenuScreen(),
    );
  }
}

class TestApiScreen extends ConsumerWidget {
  const TestApiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Test API')),
      body: productsAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(
            child: Text('Lỗi:\n$error', textAlign: TextAlign.center),
          );
        },
        data: (products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.category),
                trailing: Text('${product.price.toStringAsFixed(0)} đ'),
              );
            },
          );
        },
      ),
    );
  }
}
