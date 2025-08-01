import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class ViewAllProducts extends Usecase<List<Product>, NoParams>{
  final ProductRepository repository;

  ViewAllProducts(this.repository);

  @override
  Future<List<Product>> call(NoParams params) {
    return repository.getAllProducts();
  }
}
