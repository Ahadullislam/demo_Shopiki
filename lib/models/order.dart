import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Order.fromMap(Map<String, dynamic> map, String id) {
    return Order(
      id: id,
      userId: map['userId'] ?? '',
      items: List<dynamic>.from(map['items'] ?? []),
      status: map['status'] ?? 'Pending',
      total: (map['total'] ?? 0).toDouble(),
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'status': status,
      'total': total,
      'date': Timestamp.fromDate(date),
      'address': address,
    };
  }
}
