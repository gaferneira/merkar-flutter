import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/products_repository.dart';

class SelectProductsViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;

  SelectProductsViewModel({required this.productsRepository});

  late ShoppingList shoppingList;

  List<Product>? defaultProducts;
  List<Product>? userProducts;
  List<Product>? filterDefaultProducts;
  var productsMap;

  String? error;

  Future<void> loadData() async {
    productsRepository.fetchDefaultProducts().listen((data) {
      defaultProducts = data;
      error = null;
      updateList();
      filterDefaultProducts = defaultProducts;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });

    // Get shopping list products
    productsRepository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      updateList();
      notifyListeners();

    }, onError: (e) {
      error = e;
      notifyListeners();
    });
    updateList();
    notifyListeners();
  }

  void updateList() {
    if (userProducts != null && defaultProducts != null) {
      defaultProducts?.forEach((product) {
        product.selected = false;
      });

      userProducts?.forEach((userProduct) {
        defaultProducts?.forEach((product) {
          if (product.name == userProduct.name) {
            product.selected = true;
            userProduct.selected = true;
          }
        });
      });
    }
  }

  Future<void> selectProduct(Product product, bool selected) async {
    if (selected) {
      var newProduct = Product(
          category: product.category, name: product.name, price: product.price,unit: product.unit);
      productsRepository.save(newProduct);
      product.selected = true;
    } else {
      //Delete user product
      userProducts?.forEach((userProduct) {
        if (product.name == userProduct.name) {
          productsRepository.remove(userProduct);
          product.selected = false;
        }
      });
    }
    notifyListeners();
  }

}
