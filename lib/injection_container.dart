import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:merkar/app/pages/home/home_page_view_model.dart';
import 'package:merkar/app/pages/new_category/new_category_page_view_model.dart';
import 'package:merkar/data/remote/firestore_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/local/local_data_source.dart';
import 'data/repositories/categories_repository.dart';
import 'data/repositories/categories_repository_impl.dart';
import 'data/utils/network/network_info.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Home
  // ViewModels
  serviceLocator.registerFactory(() => HomePageViewModel(
        categoriesRepository: serviceLocator(),
      ));

  serviceLocator.registerFactory(() => NewCategoryPageViewModel());

  // Repository
  serviceLocator.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
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
