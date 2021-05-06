import 'package:flutter/material.dart';

import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class FavoriteListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;

  FavoriteListViewModel({
    required this.repository,
  });

  late List<Product> userProducts;
  late List<Product> filterUserProducts;
  String? error;

  Future<void> loadData(ShoppingList shoppingList) async {
    repository.fetchItems().listen((data) {
      userProducts = data.cast<Product>();
      filterUserProducts = userProducts;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
