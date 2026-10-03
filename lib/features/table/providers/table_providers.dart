import 'package:example/core/network/dio_provider.dart';
import 'package:example/features/table/data/coffee_table.dart';
import 'package:example/features/table/data/table_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final TableRepositoryProvider = Provider<TableRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return TableRepository(dio);
});

final tablesProvider = FutureProvider<List<CoffeeTable>>((ref) {
  final repository = ref.watch(TableRepositoryProvider);

  return repository.getTables();
});
