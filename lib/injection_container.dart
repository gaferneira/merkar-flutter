import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:merkar/app/pages/login/auth_view_model.dart';
import 'package:merkar/app/pages/new_product/create_new_product_view_model.dart';
import 'package:merkar/app/pages/select_my_products/select_my_products_view_model.dart';
import 'package:merkar/data/repositories/login_repository.dart';
import 'package:merkar/data/repositories/login_repository_impl.dart';
import 'package:merkar/data/repositories/purchases_repository.dart';
import 'package:merkar/data/repositories/purchases_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/pages/home/home_view_model.dart';
import 'app/pages/login/login_view_model.dart';
import 'app/pages/new_shopping_list/new_shopping_list_view_model.dart';
import 'app/pages/shopping_list/shopping_list_view_model.dart';
import 'data/local/local_data_source.dart';
import 'data/remote/firestore_data_source.dart';
import 'data/repositories/products_repository.dart';
import 'data/repositories/products_repository_impl.dart';
import 'data/repositories/shopping_lists_repository.dart';
import 'data/repositories/shopping_lists_repository_impl.dart';
import 'data/utils/network/network_info.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  createViewModels();
  createRepositories();

  // Data sources
  serviceLocator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => FirestoreDataSource());

  //! Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}

void createViewModels() {
  serviceLocator.registerFactory(() => AuthViewModel(
        repository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => LoginViewModel(
        repository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => HomePageViewModel(
        shoppingListsRepository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => ShoppingListViewModel(
      repository: serviceLocator(), purchasesRepository: serviceLocator()));

  serviceLocator.registerFactory(
      () => NewShoppingListViewModel(repository: serviceLocator()));

  serviceLocator.registerFactory(() => SelectMyProductsViewModel(
      shoppingListRepository: serviceLocator(),
      productsRepository: serviceLocator()));

  serviceLocator.registerFactory(
      () => CreateNewProductsViewModel(productsRepository: serviceLocator()));

  //TODO implement
  //serviceLocator.registerFactory(() => PurchasesViewModel(repository: serviceLocator()));
}

void createRepositories() {
  serviceLocator.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(),
  );

  serviceLocator.registerLazySingleton<ShoppingListsRepository>(
    () => ShoppingListsRepositoryImpl(
        networkInfo: serviceLocator(), firestoreDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
        networkInfo: serviceLocator(), firestoreDataSource: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<PurchasesRepository>(
    () => PurchasesRepositoryImpl(
        networkInfo: serviceLocator(), firestoreDataSource: serviceLocator()),
  );
}
