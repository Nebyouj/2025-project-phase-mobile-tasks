import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewProductUseCase extends Usecase<Either<Failures, Product>, String> {
  final ProductRepository repository;

  ViewProductUseCase(this.repository);

  @override
  Future<Either<Failures, Product>> call(String id) async {
    return await repository.getProduct(id);
  }
}
