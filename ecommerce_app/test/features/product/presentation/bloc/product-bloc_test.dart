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
import 'package:mockito/mockito.dart';

class MockViewAllProducts extends Mock implements ViewAllProducts {}

class MockViewProduct extends Mock implements ViewProductUseCase {}

class MockCreateProduct extends Mock implements CreateProductUseCase {}

class MockUpdateProduct extends Mock implements UpdateProductUseCase {}

class MockDeleteProduct extends Mock implements DeleteProductUseCase {}

void main() {
  late ProductBloc bloc;
  late MockViewAllProducts mockViewAllProducts;
  late MockViewProduct mockViewProduct;
  late MockCreateProduct mockCreateProduct;
  late MockUpdateProduct mockUpdateProduct;
  late MockDeleteProduct mockDeleteProduct;

  setUp(() {
    mockViewAllProducts = MockViewAllProducts();
    mockViewProduct = MockViewProduct();
    mockCreateProduct = MockCreateProduct();
    mockUpdateProduct = MockUpdateProduct();
    mockDeleteProduct = MockDeleteProduct();

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
    catogory: 'Test catogory',
    rating: 5.0,
    description: 'Comfortable running shoe',
    price: 99.99,
    imageUrl: 'test.png',
  );

    bloctest<ProductBloc, ProductState>(
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
    verify: (_) {
      verify(mockViewAllProducts(any));
    },
  );

    bloctest<ProductBloc, ProductState>(
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

    blocTest<ProductBloc, ProductState>(
    'should emit [LoadingState] and reload products after update',
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
      LoadingState(),
      const LoadedAllProductsState([testProduct]),
    ],
  );

}
