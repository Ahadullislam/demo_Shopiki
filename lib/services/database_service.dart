import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Category Methods
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addCategory(Category category) {
    return _db.collection('categories').add(category.toMap());
  }

  Future<void> updateCategory(Category category) {
    return _db.collection('categories').doc(category.id).update(category.toMap());
  }

  Future<void> deleteCategory(String id) {
    return _db.collection('categories').doc(id).delete();
  }

  // Product Methods
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addProduct(Product product) {
    return _db.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(Product product) {
    return _db.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) {
    return _db.collection('products').doc(id).delete();
  }

  // Order Methods
  Stream<List<Order>> getOrders() {
    return _db.collection('orders').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Order.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateOrder(Order order) {
    return _db.collection('orders').doc(order.id).update(order.toMap());
  }

  // User Methods
  Stream<List<AppUser>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => AppUser.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> updateUser(AppUser user) {
    return _db.collection('users').doc(user.id).update(user.toMap());
  }
}
