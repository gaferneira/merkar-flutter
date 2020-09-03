import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/repositories/products_repository.dart';

class NewShoppingListViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;

  NewShoppingListViewModel({@required this.productsRepository});

  List<Product> list;
  String error;

  void loadData(String listId) async {
    productsRepository.fetchByList(listId).listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
