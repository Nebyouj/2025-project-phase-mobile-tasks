import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/product/domain/entities/product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/create_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/delete_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/update_product.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_all_products.dart';
import 'package:ecommerce_app/features/product/domain/usecases/view_product.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product-bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ViewAllProducts>(),
  MockSpec<ViewProductUseCase>(),
  MockSpec<CreateProductUseCase>(),
  MockSpec<UpdateProductUseCase>(),
  MockSpec<DeleteProductUseCase>(),
])
void main() {
  late ProductBloc bloc;
  late MockViewAllProducts mockViewAllProducts;
  late MockViewProductUseCase mockViewProduct;
  late MockCreateProductUseCase mockCreateProduct;
  late MockUpdateProductUseCase mockUpdateProduct;
  late MockDeleteProductUseCase mockDeleteProduct;

  setUp(() {
    mockViewAllProducts = MockViewAllProducts();
    mockViewProduct = MockViewProductUseCase();
    mockCreateProduct = MockCreateProductUseCase();
    mockUpdateProduct = MockUpdateProductUseCase();
    mockDeleteProduct = MockDeleteProductUseCase();

    bloc = ProductBloc(
      viewAllProducts: mockViewAllProducts,
      viewProduct: mockViewProduct,
      createProduct: mockCreateProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
    );
  });

  const testProduct = Product(
    id: '1',
    name: 'Test Shoe',
    description: 'Comfortable running shoe',
    price: 99.99,
    imageUrl: 'test.png',
  );

  // -------------------------------
  // View All Products
  // -------------------------------
  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState, LoadedAllProductsState] when products are loaded successfully',
    build: () {
      when(mockViewAllProducts(any))
          .thenAnswer((_) async => const Right([testProduct]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAllProductsEvent()),
    expect: () => [
      LoadingState(),
      const LoadedAllProductsState([testProduct]),
    ],
    verify: (_) => verify(mockViewAllProducts(any)).called(1),
  );

  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState, ErrorState] when loading products fails',
    build: () {
      when(mockViewAllProducts(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadAllProductsEvent()),
    expect: () => [
      LoadingState(),
      const ErrorState('Failed to load products'),
    ],
  );

  // -------------------------------
  // View Single Product
  // -------------------------------
  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState, LoadedSingleProductState] when single product is fetched successfully',
    build: () {
      when(mockViewProduct(any))
          .thenAnswer((_) async => const Right(testProduct));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
    expect: () => [
      LoadingState(),
      const LoadedSingleProductState(testProduct),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState, ErrorState] when fetching single product fails',
    build: () {
      when(mockViewProduct(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetSingleProductEvent('1')),
    expect: () => [
      LoadingState(),
      const ErrorState('Failed to load product'),
    ],
  );

  // -------------------------------
  // Create Product
  // -------------------------------
  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState] then reload products when product is created successfully',
    build: () {
      when(mockCreateProduct(any))
          .thenAnswer((_) async => const Right(null));
      when(mockViewAllProducts(any))
          .thenAnswer((_) async => const Right([testProduct]));
      return bloc;
    },
    act: (bloc) => bloc.add(const CreateProductEvent(testProduct)),
    expect: () => [
      LoadingState(),
      const LoadedAllProductsState([testProduct]),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState, ErrorState] when creating product fails',
    build: () {
      when(mockCreateProduct(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const CreateProductEvent(testProduct)),
    expect: () => [
      LoadingState(),
      const ErrorState('Failed to create product'),
    ],
  );

  // -------------------------------
  // Update Product
  // -------------------------------
  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState] and reload products after successful update',
    build: () {
      when(mockUpdateProduct(any))
          .thenAnswer((_) async => const Right(null));
      when(mockViewAllProducts(any))
          .thenAnswer((_) async => const Right([testProduct]));
      return bloc;
    },
    act: (bloc) => bloc.add(const UpdateProductEvent(testProduct)),
    expect: () => [
      LoadingState(),
      const LoadedAllProductsState([testProduct]),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState, ErrorState] when updating product fails',
    build: () {
      when(mockUpdateProduct(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const UpdateProductEvent(testProduct)),
    expect: () => [
      LoadingState(),
      const ErrorState('Failed to update product'),
    ],
  );

  // -------------------------------
  // Delete Product
  // -------------------------------
  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState] and reload products after successful delete',
    build: () {
      when(mockDeleteProduct(any))
          .thenAnswer((_) async => const Right(null));
      when(mockViewAllProducts(any))
          .thenAnswer((_) async => const Right([testProduct]));
      return bloc;
    },
    act: (bloc) => bloc.add(const DeleteProductEvent('1')),
    expect: () => [
      LoadingState(),
      const LoadedAllProductsState([testProduct]),
    ],
  );

  blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState, ErrorState] when deleting product fails',
    build: () {
      when(mockDeleteProduct(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(const DeleteProductEvent('1')),
    expect: () => [
      LoadingState(),
      const ErrorState('Failed to delete product'),
    ],
  );
}
