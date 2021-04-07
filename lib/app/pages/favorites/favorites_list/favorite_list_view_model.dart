import 'package:flutter/material.dart';

import 'package:merkar/data/entities/product.dart';
import '../../../../data/repositories/shopping_lists_repository.dart';

class FavoriteListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;

  FavoriteListViewModel({required this.repository,});

  late List<Product> userProducts;
  late List<Product> filterUserProducts;
  String? error;

  Future<void> loadData() async {
    repository.fetchItems().listen((data) {
      userProducts = data;
      filterUserProducts = userProducts;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
