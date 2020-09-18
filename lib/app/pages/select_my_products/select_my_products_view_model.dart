import 'package:flutter/material.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/products_repository.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class SelectMyProductsViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListRepository;
  final ProductsRepository productsRepository;

  SelectMyProductsViewModel(
      {@required this.shoppingListRepository,
      @required this.productsRepository});

  ShoppingList shoppingList;

  List<Product> userProducts;
  List<ListProduct> shoppingProducts;

  String error;

  Future<void> loadData(ShoppingList shoppingList) async {
    this.shoppingList = shoppingList;

    // Get user products
    productsRepository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      updateList();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });

    // Get shopping list products
    shoppingListRepository.fetchProducts(shoppingList).listen((data) {
      shoppingProducts = data;
      error = null;
      updateList();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  void updateList() {
    if (shoppingProducts != null && userProducts != null) {
      for (var i = 0; i < shoppingProducts.length; i++) {
        var product = shoppingProducts[i];
        for (var j = 0; j < userProducts.length; j++) {
          var userProduct = userProducts[j];
          if (product.id == userProduct.id) {
            userProduct.selected = true;
            break;
          }
        }
      }
    }

    notifyListeners();
  }

  Future<void> selectProduct(int index, bool selected) async {
    var product = userProducts[index];
    if (selected) {
      var productList = ListProduct(
          category: product.category,
          name: product.name,
          price: product.price,
          quantity: 1);
      shoppingListRepository.saveProduct(productList, shoppingList);
    } else {
      shoppingListRepository.removeProduct(product.id, shoppingList);
    }
  }
}
