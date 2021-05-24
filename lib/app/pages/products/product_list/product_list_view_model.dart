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
    userProducts?.remove(product);
    repository.remove(product);
    notifyListeners();
  }

  searchByText(String value) {
    userProducts = filterUserProducts
        .where((product) =>
            product.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
