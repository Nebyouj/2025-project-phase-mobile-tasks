import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/features/product/data/models/product_model.dart';

void main() {
  const productModel = ProductModel(
    id: '1',
    name: 'Shoe',
    description: 'Nice shoe',
    price: 100.0,
    imageUrl: 'http://image.com/shoe.jpg',
  );

  test('should convert ProductModel to JSON', () {
    final result = productModel.toJson();
    expect(result['name'], 'Shoe');
    expect(result['price'], 100.0);
  });

  test('should create ProductModel from JSON', () {
    final jsonMap = {
      'id': '1',
      'name': 'Shoe',
      'description': 'Nice shoe',
      'price': 100.0,
      'imageUrl': 'http://image.com/shoe.jpg'
    };

    final result = ProductModel.fromJson(jsonMap);
    expect(result, isA<ProductModel>());
    expect(result.name, 'Shoe');
  });
}
