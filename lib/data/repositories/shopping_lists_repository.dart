import '../entities/shopping_lists_view.dart';

abstract class ShoppingListsRepository {
  Stream<List<ShoppingList>> fetchLists();
}
