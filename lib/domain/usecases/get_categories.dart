import 'package:dartz/dartz.dart';
import 'package:merkar/domain/base/usecase.dart';
import 'package:merkar/domain/entities/category.dart';
import 'package:merkar/domain/entities/error/failures.dart';
import 'package:merkar/domain/repositories/categories_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  final CategoriesRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<Category>>> call(NoParams params) async {
    return await repository.getList();
  }
}
