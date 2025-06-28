class Order {
  final String id;
  final String userId;
  final List<dynamic> items;
  final String status;
  final double total;
  final DateTime date;
  final String address;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.total,
    required this.date,
    required this.address,
  });
  // TODO: Add fromMap/toMap for Firestore
}
