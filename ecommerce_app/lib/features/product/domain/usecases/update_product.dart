import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductUseCase extends Usecase<void, Product> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failures, void>> call(Product product) {
    return repository.updateProduct(product);
  }
}
