import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    return Scaffold(
      body: StreamProvider<List<AppUser>>.value(
        value: db.getUsers(),
        initialData: const [],
        child: const UserList(),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<AppUser>?>(context);
    final db = DatabaseService();

    if (users == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (users.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: PopupMenuButton<String>(
            onSelected: (role) {
              final newUser = AppUser(
                id: user.id,
                name: user.name,
                email: user.email,
                role: role,
              );
              db.updateUser(newUser);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'admin',
                child: Text('Admin'),
              ),
              const PopupMenuItem<String>(
                value: 'user',
                child: Text('User'),
              ),
            ],
          ),
        );
      },
    );
  }
}
