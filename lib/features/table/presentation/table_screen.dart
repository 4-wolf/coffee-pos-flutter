import 'package:example/features/menu/presentation/menu_screen.dart';
import 'package:example/features/menu/providers/cart_provider.dart';
import 'package:example/features/table/data/coffee_table.dart';
import 'package:example/features/table/data/selected_table_provider.dart';
import 'package:example/features/table/providers/table_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableScreen extends ConsumerWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableAsync = ref.watch(tablesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn bàn')),

      body: tableAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Text('Không thể tải danh sách bàn'),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(tablesProvider);
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        },

        data: (tables) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              mainAxisSpacing: 12,
            ),

            itemCount: tables.length,

            itemBuilder: (context, index) {
              final table = tables[index];

              final isAvailable = table.status == 'AVAILABLE';

              return Card(
                child: InkWell(
                  onTap: isAvailable
                      ? () => _selectTable(context, ref, table)
                      : null,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        Icons.table_restaurant,
                        size: 50,
                        color: isAvailable ? Colors.green : Colors.red,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        table.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(isAvailable ? 'Bàn trống' : 'Đang phục vụ'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _selectTable(
    BuildContext context,
    WidgetRef ref,
    CoffeeTable table,
  ) async {
    final currenTable = ref.read(selectedTableProvider);
    final cartItems = ref.read(cartProvider);

    final isSwitchingTable = currenTable != null && currenTable.id != table.id;

    if (isSwitchingTable && cartItems.isNotEmpty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Đổi bàn?'),
            content: Text(
              'Giỏ hàng hiện tại đang thuộc ${currenTable.name}. '
              'Đổi sang ${table.name} sẽ xóa giỏ hàng này. '
              'Tiếp tục?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Đổi bàn'),
              ),
            ],
          );
        },
      );

      if (confirm != true) {
        return;
      }

      ref.read(cartProvider.notifier).clear();
    }

    ref.read(selectedTableProvider.notifier).selectTable(table);

    if (!context.mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MenuScreen()),
    );
  }
}
