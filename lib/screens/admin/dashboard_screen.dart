import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';

enum ProductViewType { list, smallGrid, largeGrid }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ProductViewType _viewType = ProductViewType.list;

  @override
  void initState() {
    super.initState();
    _loadViewType();
  }

  Future<void> _loadViewType() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('dashboard_view_type') ?? 0;
    setState(() {
      _viewType = ProductViewType.values[index];
    });
  }

  Future<void> _saveViewType(ProductViewType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dashboard_view_type', type.index);
  }

  // TODO: Replace with real product data fetching
  List<Product> get products => [];

  @override
  Widget build(BuildContext context) {
    // Use the real products list (currently empty)
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Products',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const Spacer(),
              ToggleButtons(
                isSelected: [
                  _viewType == ProductViewType.list,
                  _viewType == ProductViewType.smallGrid,
                  _viewType == ProductViewType.largeGrid,
                ],
                onPressed: (index) {
                  setState(() {
                    _viewType = ProductViewType.values[index];
                  });
                  _saveViewType(ProductViewType.values[index]);
                },
                borderRadius: BorderRadius.circular(12),
                children: const [
                  Tooltip(message: 'List', child: Icon(Icons.view_list)),
                  Tooltip(message: 'Small Grid', child: Icon(Icons.grid_view)),
                  Tooltip(message: 'Large Grid', child: Icon(Icons.grid_on)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products available.'))
                : _buildProductView(products),
          ),
        ],
      ),
    );
  }

  Widget _buildProductView(List<Product> products) {
    switch (_viewType) {
      case ProductViewType.list:
        return ListView.separated(
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final product = products[index];
            final isOutOfStock = product.stock == 0;
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageURL,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${product.price.toStringAsFixed(2)}'),
                    Text(
                      isOutOfStock
                          ? 'Out of Stock'
                          : 'In Stock: ${product.stock}',
                      style: TextStyle(
                        color: isOutOfStock ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                trailing: isOutOfStock
                    ? const Icon(Icons.warning, color: Colors.red)
                    : null,
              ),
            );
          },
        );
      case ProductViewType.smallGrid:
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isOutOfStock = product.stock == 0;
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageURL,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${product.price.toStringAsFixed(2)}'),
                    Text(
                      isOutOfStock
                          ? 'Out of Stock'
                          : 'In Stock: ${product.stock}',
                      style: TextStyle(
                        color: isOutOfStock ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      case ProductViewType.largeGrid:
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isOutOfStock = product.stock == 0;
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageURL,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      isOutOfStock
                          ? 'Out of Stock'
                          : 'In Stock: ${product.stock}',
                      style: TextStyle(
                        color: isOutOfStock ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
    }
  }
}
