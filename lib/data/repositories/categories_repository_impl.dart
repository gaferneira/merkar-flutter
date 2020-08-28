import 'package:dartz/dartz.dart';
import 'package:merkar/data/datasources/local_data_source.dart';
import 'package:merkar/data/utils/network/network_info.dart';
import 'package:merkar/domain/entities/category.dart';
import 'package:merkar/domain/entities/error/failures.dart';
import 'package:merkar/domain/repositories/categories_repository.dart';
import 'package:meta/meta.dart';

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
    return Right(categories);
  }
}
