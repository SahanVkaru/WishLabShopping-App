class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final int reviewCount;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'image': image,
    };
  }
}
