class OrderResponse {
  final int id;
  final String status;
  final int total;

  OrderResponse({required this.id, required this.status, required this.total});

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'] as int,
      status: json['status'] as String,
      total: (json['total'] as num).toInt(),
    );
  }
}
