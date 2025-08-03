import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String catogory,
    required double rating,
    required String description,
    required double price,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          catogory: catogory,
          rating: rating,
          description: description,
          price: price,
          imageUrl: imageUrl,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      catogory: json['catogory'],
      rating: json['rating'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'catogory': catogory,
      'rating': rating,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      catogory: catogory,
      rating: rating,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );
  }

  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      catogory: entity.catogory,
      rating: entity.rating,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
    );
  }
}
