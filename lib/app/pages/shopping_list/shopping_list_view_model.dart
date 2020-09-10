import 'package:flutter/material.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class ShoppingListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;

  ShoppingListViewModel({@required this.repository});

  List<ListProduct> list;
  String error;

  Future<void> loadData(ShoppingList shoppingList) async {
    repository.fetchProducts(shoppingList).listen((data) {
      list = data;
      print(data.length);
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
