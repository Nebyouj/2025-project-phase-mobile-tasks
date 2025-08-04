import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/product_model.dart';
import 'product_local_data_source.dart';

const cachedProducts = 'cachedProducts';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProductModel>> getCachedProducts() {
    final jsonString = sharedPreferences.getString(cachedProducts);
    if (jsonString != null) {
      final List<dynamic> decodedList = json.decode(jsonString);
      return Future.value(decodedList
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList());
    } else {
      throw CacheExecption();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) {
    final List<Map<String, dynamic>> jsonList =
        products.map((product) => product.toJson()).toList();
    return sharedPreferences.setString(cachedProducts, json.encode(jsonList));
  }
}
