import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class ViewProductUseCase extends Usecase<Product?, String> {
  final ProductRepository repository;

  ViewProductUseCase(this.repository);

  @override
  Future<Product?> call(String id) async {
    return await repository.fetchProductById(id);
  }
}
