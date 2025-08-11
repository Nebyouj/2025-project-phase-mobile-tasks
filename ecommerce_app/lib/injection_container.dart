
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/network/socket_manager.dart';
import 'features/auth/data/datasources/auth_remote_data_sources.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/log_in.dart';
import 'features/auth/domain/usecases/log_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chats/data/datasources/chat_remote_data_source.dart';
import 'features/chats/data/datasources/chat_remote_data_source_impl.dart';
import 'features/chats/data/repositories/chat_repository_impl.dart';
import 'features/chats/domain/repositories/chat_repository.dart';
import 'features/chats/domain/usecases/create_chat.dart';
import 'features/chats/domain/usecases/get_all_users.dart';
import 'features/chats/domain/usecases/get_chats.dart';
import 'features/chats/domain/usecases/get_messages.dart';
import 'features/chats/domain/usecases/send_message.dart';
import 'features/chats/presentation/bloc/chat_bloc.dart';
import 'features/product/data/datasources/product_local_data_source.dart';
import 'features/product/data/datasources/product_local_data_source_impl.dart';
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/datasources/product_remote_data_source_impl.dart';
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/create_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/view_all_products.dart';
import 'features/product/domain/usecases/view_product.dart';
import 'features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External (register these first)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<WebSocketService>(() => WebSocketService());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! Features - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()), // http.Client injected
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl(), // AuthRemoteDataSource
      sl(), // FlutterSecureStorage
    ),
  );
  sl.registerLazySingleton(() => LogIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => LogOut(sl()));
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signupUseCase: sl(),
      logoutUseCase: sl(),
      repository: sl(),
    ),
  );

  //! Features - Chats
  sl.registerLazySingleton<ChatRemoteDataSource>(
  () => ChatRemoteDataSourceImpl(sl<FlutterSecureStorage>(), sl<WebSocketService>()),
);
  sl.registerLazySingleton<ChatRepository>(
  () => ChatRepositoryImpl(sl<ChatRemoteDataSource>(), sl<FlutterSecureStorage>()),
);

  sl.registerLazySingleton(() => GetChats(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => CreateChat(sl()));
  sl.registerLazySingleton(() => GetAllUsers(sl()));
sl.registerFactory(
  () => ChatBloc(
    getChats: sl(),
    getMessages: sl(),
    sendMessage: sl(),
    createChat: sl(),
    messageStream: sl<ChatRepository>().listenToMessages(),
    typingStream: sl<ChatRepository>().listenToTypingStatus(),
    getAllUsers: sl(),
  ),
);
  //! Features - Product
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDatasourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => ViewAllProducts(sl()));
  sl.registerLazySingleton(() => ViewProductUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerFactory(
    () => ProductBloc(
      viewAllProducts: sl(),
      viewProduct: sl(),
      createProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
    ),
  );
}

