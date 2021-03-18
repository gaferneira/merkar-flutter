import 'package:dartz/dartz.dart';

import '../../data/entities/list_product.dart';
import '../../data/entities/purchase.dart';
import '../entities/error/failures.dart';

abstract class PurchasesRepository {
  //Purchase
  Future<Either<Failure, Purchase>> create(String detail, List<ListProduct> selectedList);
  Stream<List<Purchase>> fetchItems();
  Future<Either<Failure, bool>> remove(Purchase item);
  //Products
  Stream<List<ListProduct>> fetchProducts(Purchase item);
}
