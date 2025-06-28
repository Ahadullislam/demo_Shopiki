import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement order management, status update, export CSV/PDF
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Orders')),
      body: Center(child: Text('Order Management')),
    );
  }
}
