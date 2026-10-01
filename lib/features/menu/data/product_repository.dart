import 'package:dio/dio.dart';
import 'package:example/features/menu/data/product.dart';

class ProductRepository {
  final Dio dio;
  ProductRepository(this.dio);

  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get('/api/products');
      final list = response.data as List<dynamic>;
      return list
          .map((e) => Product.fromJSON(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Không tải được menu: ${e.message}');
    }
  }
}
