import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order.dart';
import '../../services/database_service.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    return Scaffold(
      body: StreamProvider<List<Order>>.value(
        value: db.getOrders(),
        initialData: const [],
        child: const OrderList(),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Order>?>(context);
    final db = DatabaseService();

    if (orders == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
      return const Center(child: Text('No orders found.'));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          title: Text('Order #${order.id.substring(0, 6)}'),
          subtitle: Text('Status: ${order.status}'),
          trailing: PopupMenuButton<String>(
            onSelected: (status) {
              final newOrder = Order(
                id: order.id,
                userId: order.userId,
                items: order.items,
                status: status,
                total: order.total,
                date: order.date,
                address: order.address,
              );
              db.updateOrder(newOrder);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Pending',
                child: Text('Pending'),
              ),
              const PopupMenuItem<String>(
                value: 'Processing',
                child: Text('Processing'),
              ),
              const PopupMenuItem<String>(
                value: 'Shipped',
                child: Text('Shipped'),
              ),
              const PopupMenuItem<String>(
                value: 'Delivered',
                child: Text('Delivered'),
              ),
              const PopupMenuItem<String>(
                value: 'Cancelled',
                child: Text('Cancelled'),
              ),
            ],
          ),
        );
      },
    );
  }
}
