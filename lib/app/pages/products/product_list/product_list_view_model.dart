import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/repositories/products_repository.dart';

class ProductsListViewModel extends ChangeNotifier {
  final ProductsRepository repository;

  ProductsListViewModel({
    required this.repository,
  });

  List<Product>? userProducts;
  List<Product> filterUserProducts = [];
  String? error;

  Future<void> loadData() async {
    repository.fetchItems().listen((data) {
      userProducts = data;
      filterUserProducts = userProducts ?? [];
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  Future<void> removeProduct(Product product) async {
    repository.remove(product);
    notifyListeners();
  }
}
