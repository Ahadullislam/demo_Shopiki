import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement push notifications, offers
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Center(child: Text('Push Notifications & Offers')),
    );
  }
}
