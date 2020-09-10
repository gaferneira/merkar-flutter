import 'package:flutter/material.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class NewShoppingListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;

  NewShoppingListViewModel({@required this.repository});

  List<ListProduct> list;
  String error;

  void loadData(ShoppingList shoppingList) async {
    repository.fetchProducts(shoppingList).listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
