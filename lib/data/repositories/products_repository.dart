import 'package:dartz/dartz.dart';

import '../entities/error/failures.dart';
import '../entities/product.dart';

abstract class ProductsRepository {
  Stream<List<Product>> fetchDefaultProducts();
  Stream<List<Product>> fetchItems();
  Future<Either<Failure, Product>> save(Product item);
  Future<Either<Failure, bool>> remove(Product item);
 }
