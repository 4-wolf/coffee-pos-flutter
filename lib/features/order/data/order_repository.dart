import 'package:dio/dio.dart';
import 'package:example/core/network/dio_provider.dart';
import 'package:example/features/cart/data/create_order_request.dart';
import 'package:example/features/cart/data/order_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderRepository {
  final Dio dio;
  OrderRepository(this.dio);

  Future<OrderResponse> createOrder(CreateOrderRequest request) async {
    try {
      final response = await dio.post('/orders', data: request.toJson());
      return OrderResponse.fromJson(response.data as Map<String, dynamic>);
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
  return OrderRepository(ref.watch(dioProvider));
});
