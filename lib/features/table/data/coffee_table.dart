class CoffeeTable {
  final int id;
  final String name;
  final String status;

  CoffeeTable({required this.id, required this.name, required this.status});

  factory CoffeeTable.fromJson(Map<String, dynamic> json) {
    return CoffeeTable(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }

  bool get isAvailable => status == 'AVAILABLE';
}
