class Product {
  final String id;
  final String name;
  final String imageURL;
  final double price;
  final int stock;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
  });
  // TODO: Add fromMap/toMap for Firestore
}
