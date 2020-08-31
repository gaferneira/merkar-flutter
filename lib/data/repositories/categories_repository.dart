import 'package:dartz/dartz.dart';
import 'package:merkar/data/entities/error/failures.dart';

import '../entities/category.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<Category>>> getList();
}
