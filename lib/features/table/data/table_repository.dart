import 'package:dio/dio.dart';
import 'package:example/features/table/data/coffee_table.dart';

class TableRepository {
  final Dio dio;

  TableRepository(this.dio);

  Future<List<CoffeeTable>> getTables() async {
    final response = await dio.get('/api/tables');

    final List<dynamic> data = response.data;

    return data.map((json) => CoffeeTable.fromJson(json)).toList();
  }
}
