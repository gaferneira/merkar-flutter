import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/repositories/products_repository.dart';

class FavoriteListViewModel extends ChangeNotifier {
  final ProductsRepository repository;

  FavoriteListViewModel({
    @required this.repository,
  });

  List<Product> userProducts;
  String error;

  Future<void> loadData() async {
    repository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
