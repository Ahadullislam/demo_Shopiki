import 'package:flutter/material.dart';
import '../../models/category.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  void _showFeature(BuildContext context, String feature) {
    if (feature == 'Add Product') {
      _showAddProductFlow(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(feature)),
      );
    }
  }

  void _showAddProductFlow(BuildContext context) async {
    final categories = [
      Category(id: '1', name: 'Clothing', icon: '👕'),
      Category(id: '2', name: 'Footwear', icon: '👟'),
      Category(id: '3', name: 'Accessories', icon: '🎒'),
    ];
    Category? selectedCategory = await showDialog<Category>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Category'),
        children: categories.map((cat) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, cat),
          child: Row(
            children: [
              Text(cat.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(cat.name),
            ],
          ),
        )).toList(),
      ),
    );
    if (selectedCategory != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24,
          ),
          child: _AddProductForm(category: selectedCategory),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.add_box, 'label': 'Add Product'},
      {'icon': Icons.delete, 'label': 'Remove Product'},
      {'icon': Icons.list_alt, 'label': 'View Products'},
      {'icon': Icons.search, 'label': 'Search Products'},
      {'icon': Icons.filter_list, 'label': 'Filter Products'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: features.map((feature) {
            return GestureDetector(
              onTap: () => _showFeature(context, feature['label'] as String),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(feature['icon'] as IconData, size: 48, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        feature['label'] as String,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AddProductForm extends StatefulWidget {
  final Category category;
  const _AddProductForm({required this.category});

  @override
  State<_AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<_AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String imageUrl = '';
  String price = '';
  String stock = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Product to ${widget.category.name}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Product Name'),
              onChanged: (v) => name = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Image URL'),
              onChanged: (v) => imageUrl = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter image URL' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (v) => price = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              onChanged: (v) => stock = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter stock' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (v) => description = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added (mock)!')),
                    );
                  }
                },
                child: const Text('Add Product'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
