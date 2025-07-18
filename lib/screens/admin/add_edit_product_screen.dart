import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/database_service.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  late int _stock;
  late String _category;
  late String _imageUrl;
  XFile? _imageFile;
  PlatformFile? _platformFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0.0;
    _stock = widget.product?.stock ?? 0;
    _category = widget.product?.category ?? '';
    _imageUrl = widget.product?.imageURL ?? '';
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _platformFile = result.files.first;
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  Future<String> _uploadImage(String productId) async {
    if (_platformFile == null && _imageFile == null) {
      return _imageUrl;
    }
    try {
      final ref = FirebaseStorage.instance.ref('product_images/$productId');
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(_platformFile!.bytes!);
      } else {
        uploadTask = ref.putFile(File(_imageFile!.path));
      }
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      final db = DatabaseService();
      final productId = widget.product?.id ?? const Uuid().v4();
      final imageUrl = await _uploadImage(productId);
      if (widget.product == null) {
        await db.addProduct(
          Product(
            id: productId,
            name: _name,
            description: _description,
            price: _price,
            stock: _stock,
            category: _category,
            imageURL: imageUrl,
          ),
        );
      } else {
        await db.updateProduct(
          Product(
            id: widget.product!.id,
            name: _name,
            description: _description,
            price: _price,
            stock: _stock,
            category: _category,
            imageURL: imageUrl,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _imageFile == null && _platformFile == null && _imageUrl.isEmpty
                          ? Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 50),
                            )
                          : _platformFile != null
                              ? Image.memory(_platformFile!.bytes!, height: 100)
                              : _imageFile != null
                                  ? Image.file(File(_imageFile!.path), height: 100)
                                  : Image.network(_imageUrl, height: 100),
                      TextButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text('Pick Image'),
                        onPressed: _pickImage,
                      ),
                      TextFormField(
                        initialValue: _name,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a name' : null,
                        onSaved: (value) => _name = value!,
                      ),
                      TextFormField(
                        initialValue: _description,
                        decoration: const InputDecoration(labelText: 'Description'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a description' : null,
                        onSaved: (value) => _description = value!,
                      ),
                      TextFormField(
                        initialValue: _price.toString(),
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a price' : null,
                        onSaved: (value) => _price = double.parse(value!),
                      ),
                      TextFormField(
                        initialValue: _stock.toString(),
                        decoration: const InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter the stock' : null,
                        onSaved: (value) => _stock = int.parse(value!),
                      ),
                      TextFormField(
                        initialValue: _category,
                        decoration: const InputDecoration(labelText: 'Category'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a category' : null,
                        onSaved: (value) => _category = value!,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submit,
                        child: Text(widget.product == null ? 'Add' : 'Update'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
