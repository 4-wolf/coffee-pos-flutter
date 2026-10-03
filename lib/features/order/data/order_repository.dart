import 'package:dio/dio.dart';
import 'package:example/core/network/dio_provider.dart';
import 'package:example/features/cart/data/create_order_request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderRepository {
  final Dio dio;
  OrderRepository(this.dio);

  Future<void> createOrder(CreateOrderRequest request) async {
    try {
      final response = await dio.post('/api/orders', data: request.toJson());

      debugPrint('Order response: ${response.data}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw Exception('Không kết nối được server, kiểm tra mạng');
      }
      throw Exception('Đặt hàng thất bại: ${e.response?.data ?? e.message}');
    }
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return OrderRepository(dio);
});
