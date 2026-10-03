import 'package:example/features/cart/data/create_order_request.dart';
import 'package:example/features/menu/providers/cart_provider.dart';
import 'package:example/features/order/data/order_repository.dart';
import 'package:example/features/table/data/selected_table_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() {
    return _CartScreenState();
  }
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);

    final total = items.fold<double>(
      0,
      (sum, item) => sum + item.getSubtotal(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),

      body: Column(
        children: [
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Giỏ hàng đang trống'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

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
                              onPressed: isPlaying
                                  ? null
                                  : () {
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

                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: isPlaying
                                  ? null
                                  : () {
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
                              icon: const Icon(Icons.delete),
                              onPressed: isPlaying
                                  ? null
                                  : () {
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

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: items.isEmpty || isPlaying ? null : _checkout,

                    child: isPlaying
                        ? const SizedBox(
                            height: 22,
                            width: 22,

                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Thanh toán'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkout() async {
    final items = ref.read(cartProvider);
    final selectedTable = ref.read(selectedTableProvider);
    if (selectedTable == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Chưa chọn bàn')));
      return;
    }

    setState(() {
      isPlaying = true;
    });

    try {
      final request = CreateOrderRequest(
        tableId: selectedTable.id.toString(),
        items: items,
      );

      await ref.read(orderRepositoryProvider).createOrder(request);

      // Thanh toán thành công -> xóa giỏ hàng
      ref.read(cartProvider.notifier).clear();

      // Reset bàn
      ref.read(selectedTableProvider.notifier).clear();

      if (!mounted) {
        return;
      }

      // Quay lại Menu
      Navigator.pop(context, true);
    } catch (error, stackTrace) {
      debugPrint('Thanh toán error: $error');
      debugPrint('Stack: $stackTrace');
      if (!mounted) return;

      setState(() => isPlaying = false);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: $error')));
    }
  }
}
