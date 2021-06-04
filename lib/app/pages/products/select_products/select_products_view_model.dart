import 'package:flutter/material.dart';
import '../../../../data/entities/product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../data/repositories/products_repository.dart';

class SelectProductsViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;

  SelectProductsViewModel({required this.productsRepository});

  late ShoppingList shoppingList;

  List<Product>? defaultProducts;
  List<Product>? userProducts;
  List<Product>? filterDefaultProducts;
  var productsMap;

  var firstLoadTime = true;
  String? error;

  Future<void> loadData() async {
    firstLoadTime = true;
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

      if (firstLoadTime) {
        firstLoadTime = false;
        removeInitialUserProducts();
      }

      defaultProducts?.forEach((product) {
        product.selected = false;
      });

      defaultProducts?.forEach((product) {
        userProducts?.forEach((userProduct) {
          if (product.name == userProduct.name) {
            product.selected = true;
            userProduct.selected = true;
          }
        });
      });
    }
  }

  void removeInitialUserProducts() {
    var newList = <Product>[];
    defaultProducts?.forEach((product) {
      product.selected = false;
      var found = false;
      userProducts?.forEach((userProduct) {
        if (product.name == userProduct.name) {
          found = true;
        }
      });
      if (!found) {
        newList.add(product);
      }
    });

    defaultProducts = newList;
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

  void searchByText(String value) {
    defaultProducts = filterDefaultProducts!
        .where((product) =>
        product.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> removeProduct(Product product) async {
    defaultProducts?.remove(product);
    productsRepository.remove(product);
    notifyListeners();
  }
}
