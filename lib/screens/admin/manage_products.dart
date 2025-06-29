import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';

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
      {'icon': Icons.edit, 'label': 'Adjustment or Edit Product'},
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
  final Product? product;
  const _AddProductForm({required this.category, this.product});

  @override
  State<_AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<_AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String imageUrl;
  late String price;
  late String stock;
  late String description;
  bool isLoading = false;
  String? errorMessage;
  XFile? pickedImage;
  PlatformFile? pickedFile;
  String? uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    name = widget.product?.name ?? '';
    imageUrl = widget.product?.imageURL ?? '';
    price = widget.product?.price.toString() ?? '';
    stock = widget.product?.stock.toString() ?? '';
    description = widget.product?.description ?? '';
    uploadedImageUrl = imageUrl.isNotEmpty ? imageUrl : null;
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          pickedFile = result.files.single;
          pickedImage = null;
        });
      }
    } else {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          pickedImage = picked;
          pickedFile = null;
        });
      }
    }
  }

  Future<String?> _uploadImage(String productId) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('product_images/$productId.jpg');
      UploadTask uploadTask;
      if (kIsWeb && pickedFile != null && pickedFile!.bytes != null) {
        uploadTask = ref.putData(pickedFile!.bytes!);
      } else if (pickedImage != null) {
        uploadTask = ref.putFile(File(pickedImage!.path));
      } else {
        return uploadedImageUrl ?? imageUrl;
      }
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      setState(() { errorMessage = 'Image upload failed: $e'; });
      return null;
    }
  }

  Future<void> _addOrEditProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final id = widget.product?.id ?? const Uuid().v4();
      String? finalImageUrl = await _uploadImage(id);
      if (finalImageUrl == null || finalImageUrl.isEmpty) {
        setState(() { errorMessage = 'Please provide a product image.'; });
        return;
      }
      final product = Product(
        id: id,
        name: name,
        imageURL: finalImageUrl,
        price: double.tryParse(price) ?? 0,
        stock: int.tryParse(stock) ?? 0,
        category: widget.category.name,
        description: description,
        visible: widget.product?.visible ?? true,
        visibleAt: widget.product?.visibleAt,
      );
      await FirebaseFirestore.instance.collection('Products').doc(id).set(product.toMap());
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.product == null ? 'Product added successfully!' : 'Product updated successfully!')),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to save product: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.product == null ? 'Add' : 'Edit'} Product to ${widget.category.name}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: imageUrl,
              decoration: InputDecoration(
                labelText: 'Image URL or Upload Image',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: isLoading ? null : () async {
                    await _pickImage();
                    if ((pickedImage != null || (pickedFile != null && pickedFile!.bytes != null))) {
                      final id = widget.product?.id ?? const Uuid().v4();
                      String? uploadedUrl = await _uploadImage(id);
                      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
                        setState(() {
                          imageUrl = uploadedUrl;
                          uploadedImageUrl = uploadedUrl;
                        });
                      }
                    }
                  },
                ),
              ),
              onChanged: (v) => setState(() { imageUrl = v; uploadedImageUrl = v; }),
              validator: (v) => v == null || v.isEmpty ? 'Enter image URL or upload an image' : null,
            ),
            if ((uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty))
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Center(
                  child: Image.network(uploadedImageUrl!, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image)),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: name,
              decoration: const InputDecoration(labelText: 'Product Name'),
              onChanged: (v) => name = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: price,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (v) => price = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter price' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: stock,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
              onChanged: (v) => stock = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter stock' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: description,
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (v) => description = v,
              validator: (v) => v == null || v.isEmpty ? 'Enter description' : null,
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _addOrEditProduct,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.product == null ? 'Add Product' : 'Save Changes'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
