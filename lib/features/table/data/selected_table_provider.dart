import 'package:example/features/table/data/coffee_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTableProvider =
    NotifierProvider<SelectedTableNotifier, CoffeeTable?>(
      SelectedTableNotifier.new,
    );

class SelectedTableNotifier extends Notifier<CoffeeTable?> {
  @override
  CoffeeTable? build() {
    return null;
  }

  void selectTable(CoffeeTable table) {
    state = table;
  }

  void clear() {
    state = null;
  }
}
