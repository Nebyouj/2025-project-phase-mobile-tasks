import '../entities/product.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateProductUseCase extends Usecase<void, Product> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<void> call(Product product) async {
    await repository.updateProduct(product);
  }
}
