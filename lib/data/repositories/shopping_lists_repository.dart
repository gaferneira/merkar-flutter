import 'package:dartz/dartz.dart';
import '../entities/list_product.dart';
import '../entities/error/failures.dart';
import '../entities/shopping_list.dart';

abstract class ShoppingListsRepository {
  Stream<List<ShoppingList>> fetchItems();
  Future<Either<Failure, ShoppingList>> save(ShoppingList item);
  Future<Either<Failure, bool>> remove(ShoppingList item);
  //Products
  Stream<List<ListProduct>> fetchProducts(ShoppingList list);
  Future<Either<Failure, ListProduct>> saveProduct(ListProduct product, ShoppingList list);
  Future<Either<Failure, bool>> removeProduct(String productId, ShoppingList list);
  Future<void> updateTotalItems(String total_items, ShoppingList list);
  Future<void> updateTotalSelected(String total_selected, ShoppingList list);
}
