import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class CreateProductUseCase extends Usecase<void, Product> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<void> call(Product product) async {
    await repository.insertProduct(product);
  }
}
