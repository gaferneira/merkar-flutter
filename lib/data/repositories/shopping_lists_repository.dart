import '../entities/shopping_list.dart';

abstract class ShoppingListsRepository {
  Stream<List<ShoppingList>> fetchLists();
}
