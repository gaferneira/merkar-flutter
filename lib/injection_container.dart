import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app/pages/home/bloc/home_bloc.dart';
import 'app/pages/new_category/bloc/new_category_bloc.dart';
import 'data/datasources/local_data_source.dart';
import 'data/repositories/categories_repository_impl.dart';
import 'data/utils/network/network_info.dart';
import 'domain/repositories/categories_repository.dart';
import 'domain/usecases/get_categories.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Home
  // Bloc
  sl.registerFactory(() => HomeBloc(
        getCategoriesUseCase: sl(),
      ));
  sl.registerFactory(() => NewCategoryBloc());

  // Use cases
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
