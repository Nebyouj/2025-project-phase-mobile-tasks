import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDatasourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  ProductRemoteDatasourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body);
      return decodedJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> insertProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/products/$id'));

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }
}
