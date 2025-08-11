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
      final decodedList = json.decode(jsonString) as List<dynamic>;
      return Future.value(decodedList
          .map((json) => ProductModel.fromJson(json))
          .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final jsonList = products.map((product) => product.toJson()).toList();
    await sharedPreferences.setString(cachedProducts, json.encode(jsonList));
  }
}
