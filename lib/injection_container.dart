import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app/pages/home/home_view_model.dart';
import 'app/pages/new_shopping_list/new_shopping_list_view_model.dart';
import 'data/local/local_data_source.dart';
import 'data/remote/firestore_data_source.dart';
import 'data/repositories/shopping_lists_repository.dart';
import 'data/repositories/shopping_lists_repository_impl.dart';
import 'data/utils/network/network_info.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Home
  // ViewModels
  serviceLocator.registerFactory(() => HomePageViewModel(
        categoriesRepository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => NewShoppingListViewModel());

  // Repository
  serviceLocator.registerLazySingleton<ShoppingListsRepository>(
    () => ShoppingListsRepositoryImpl(
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
        firestoreDataSource: serviceLocator()),
  );

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
