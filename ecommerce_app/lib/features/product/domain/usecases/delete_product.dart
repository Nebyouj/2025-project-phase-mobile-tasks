import '../repositories/product_repository.dart';
import 'usecase.dart';

class DeleteProductUseCase extends Usecase<void, String> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<void> call(String id) async {
    await repository.deleteProduct(id);
  }
}
