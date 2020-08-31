import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../entities/category.dart';
import '../entities/error/failures.dart';
import '../local/local_data_source.dart';
import '../utils/network/network_info.dart';
import 'categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CategoriesRepositoryImpl({
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Category>>> getList() async {
    final categories = await localDataSource.getAllCategories();
    await Future.delayed(Duration(milliseconds: 3000));
    return Right(categories);
  }
}
