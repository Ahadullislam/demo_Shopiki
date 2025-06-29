class Product {
  final String id;
  final String name;
  final String imageURL;
  final double price;
  final int stock;
  final String category;
  final String description;
  final bool visible;
  final DateTime? visibleAt;

  Product({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    this.visible = true,
    this.visibleAt,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      imageURL: map['imageURL'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      stock: (map['stock'] ?? 0).toInt(),
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      visible: map['visible'] ?? true,
      visibleAt: map['visibleAt'] != null ? DateTime.tryParse(map['visibleAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageURL': imageURL,
      'price': price,
      'stock': stock,
      'category': category,
      'description': description,
      'visible': visible,
      'visibleAt': visibleAt?.toIso8601String(),
    };
  }
}
