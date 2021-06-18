import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:merkar/app/core/storage/storage_view_model.dart';
import 'package:merkar/app/pages/purchases/statistics/statistics_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/pages/products/product_list/product_list_view_model.dart';
import 'app/pages/products/select_products/select_products_view_model.dart';
import 'app/pages/home/home_view_model.dart';
import 'app/pages/login/auth_view_model.dart';
import 'app/pages/login/register/register_view_model.dart';
import 'app/pages/login/reset_password/reset_password_view_model.dart';
import 'app/pages/login/sign_in/login_view_model.dart';
import 'app/pages/products/new_product/create_new_product_view_model.dart';
import 'app/pages/purchases/purchase_history/purchase_history_view_model.dart';
import 'app/pages/purchases/purchase_history_show_info/purchase_history_show_info_view_model.dart';
import 'app/pages/shopping/select_my_products/select_my_products_view_model.dart';
import 'app/pages/shopping/shopping_list/shopping_list_view_model.dart';
import 'data/local/local_data_source.dart';
import 'data/remote/firestore_data_source.dart';
import 'data/repositories/login_repository.dart';
import 'data/repositories/login_repository_impl.dart';
import 'data/repositories/products_repository.dart';
import 'data/repositories/products_repository_impl.dart';
import 'data/repositories/purchases_repository.dart';
import 'data/repositories/purchases_repository_impl.dart';
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

  serviceLocator.registerFactory(() => StorageViewModel(
    repository: serviceLocator(),
  ));

  serviceLocator.registerFactory(() => LoginViewModel(
        repository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => RegisterViewModel(
        repository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => ResetPasswordViewModel(
        repository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => HomePageViewModel(
        shoppingListsRepository: serviceLocator(),
        loginRepository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => ShoppingListViewModel(
      repository: serviceLocator(), purchasesRepository: serviceLocator()));

  serviceLocator.registerFactory(
      () => ProductsListViewModel(repository: serviceLocator()));

  serviceLocator.registerFactory(() => SelectProductsViewModel(
        productsRepository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => SelectMyProductsViewModel(
      shoppingListRepository: serviceLocator(),
      productsRepository: serviceLocator()));

  serviceLocator.registerFactory(
      () => CreateNewProductsViewModel(productsRepository: serviceLocator()));

  serviceLocator.registerFactory(() =>
      PurchaseHistoryViewModel(purchaseHistoryRepository: serviceLocator()));

  serviceLocator.registerFactory(() => PurchaseHistoryShowInfoViewModel(
      purchaseHistoryRepository: serviceLocator()));

  serviceLocator.registerFactory(() => StatisticsViewModel(
      purchaseHistoryRepository: serviceLocator()));
}

void createRepositories() {
  serviceLocator.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
        networkInfo: serviceLocator(), firestoreDataSource: serviceLocator()),
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
