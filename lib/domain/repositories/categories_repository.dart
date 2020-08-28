import 'package:dartz/dartz.dart';
import 'package:merkar/domain/entities/category.dart';
import 'package:merkar/domain/entities/error/failures.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<Category>>> getList();
}
