import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class ViewAllProducts
    extends Usecase<Either<Failures, List<Product>>, NoParams> {
  final ProductRepository repository;

  ViewAllProducts(this.repository);

  @override
  Future<Either<Failures, List<Product>>> call(NoParams params) async {
    return await repository.getAllProducts();
  }
}


