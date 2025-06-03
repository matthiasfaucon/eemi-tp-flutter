class Product {
  final String id;
  final String name;
  final String? description; // Rendre nullable
  final double price;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.description, // Rendu nullable, donc plus besoin de required
    required this.price,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'], // Peut être null
      price: (json['price'] is int) 
          ? json['price'].toDouble() 
          : json['price']?.toDouble() ?? 0.0, // Gestion des différents types de prix
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}