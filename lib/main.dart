import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'themes/app_theme.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/manage_products.dart';
import 'screens/admin/manage_orders.dart';
import 'screens/admin/manage_users.dart';
import 'screens/admin/notifications.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Add options for web if needed
  runApp(const ShopikiAdminApp());
}

class ShopikiAdminApp extends StatefulWidget {
  const ShopikiAdminApp({super.key});

  @override
  State<ShopikiAdminApp> createState() => _ShopikiAdminAppState();
}

class _ShopikiAdminAppState extends State<ShopikiAdminApp> {
  bool isDark = false;

  void toggleTheme() => setState(() => isDark = !isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopiki Admin',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: AuthGate(toggleTheme: toggleTheme, isDark: isDark),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthGate extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  const AuthGate({super.key, required this.toggleTheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a launching splash page while checking auth
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
                  Text('Launching Shopiki Admin...'),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          // User is logged in, show dashboard
          return AdminHome(toggleTheme: toggleTheme, isDark: isDark);
        }
        // Not logged in, show login page
        return const LoginScreen();
      },
    );
  }
}

class AdminHome extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  const AdminHome({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    DashboardScreen(),
    ManageProductsScreen(),
    ManageOrdersScreen(),
    ManageUsersScreen(),
    NotificationsScreen(),
  ];
  final List<String> _titles = const [
    'Dashboard',
    'Products',
    'Orders',
    'Users',
    'Notifications',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        title: Row(
          children: [
            // Removed Lottie icon for now
            // const SizedBox(width: 12), // Remove if not needed
            Expanded(
              child: Text(
                _titles[_selectedIndex],
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).hintColor,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: 'Orders',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
            ],
            showUnselectedLabels: false,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
