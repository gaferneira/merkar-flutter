import '../entities/category.dart';

abstract class CategoriesRepository {
  Stream<List<Category>> fetchAllCategories();
}
