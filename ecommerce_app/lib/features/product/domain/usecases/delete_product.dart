import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/product_repository.dart';

class DeleteProductUseCase extends Usecase<void, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failures, void>> call(String id) {
    return repository.deleteProduct(id);
  }
}
