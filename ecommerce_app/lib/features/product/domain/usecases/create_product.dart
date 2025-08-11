import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase extends Usecase<void, Product> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failures, void>> call(Product product) {
    return repository.insertProduct(product);
  }
}

