import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/view_all_products.dart';
import '../../domain/usecases/view_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ViewAllProducts viewAllProducts;
  final ViewProductUseCase viewProduct;
  final CreateProductUseCase createProduct;
  final UpdateProductUseCase updateProduct;
  final DeleteProductUseCase deleteProduct;

  ProductBloc({
    required this.viewAllProducts,
    required this.viewProduct,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(InitialState()) {
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<GetSingleProductEvent>(_onGetSingleProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadAllProducts(
      LoadAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    final result = await viewAllProducts(NoParams());
    result.fold(
      (failure) => emit(const ErrorState('Failed to load products')),
      (products) => emit(LoadedAllProductsState(products)),
    );
  }

  Future<void> _onGetSingleProduct(
      GetSingleProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    final result = await viewProduct(Params(id: event.id));
    result.fold(
      (failure) => emit(const ErrorState('Failed to load product')),
      (product) => emit(LoadedSingleProductState(product)),
    );
  }

  Future<void> _onCreateProduct(
      CreateProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    final result = await createProduct(Params(product: event.product));
    result.fold(
      (failure) => emit(const ErrorState('Failed to create product')),
      (_) => add(LoadAllProductsEvent()), // Reload products
    );
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    final result = await updateProduct(Params(product: event.product));
    result.fold(
      (failure) => emit(const ErrorState('Failed to update product')),
      (_) => add(LoadAllProductsEvent()),
    );
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(LoadingState());
    final result = await deleteProduct(Params(id: event.id));
    result.fold(
      (failure) => emit(const ErrorState('Failed to delete product')),
      (_) => add(LoadAllProductsEvent()),
    );
  }

}

