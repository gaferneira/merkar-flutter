import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/repositories/products_repository.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class SelectMyProductsViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListRepository;
  final ProductsRepository productsRepository;

  SelectMyProductsViewModel(
      {@required this.shoppingListRepository,
      @required this.productsRepository});

  List<Product> list;
  String error;

  Future<void> loadData() async {
    productsRepository.fetchItems().listen((data) {
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
