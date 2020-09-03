import 'package:merkar/data/entities/product.dart';

import '../entities/product.dart';

abstract class ProductsRepository {
  Stream<List<Product>> fetchByList(String listId);
}
