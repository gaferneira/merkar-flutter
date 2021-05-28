import 'package:flutter/material.dart';
import '../../../../data/entities/list_product.dart';
import '../../../../data/entities/product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../data/repositories/products_repository.dart';
import '../../../../data/repositories/shopping_lists_repository.dart';

class SelectMyProductsViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListRepository;
  final ProductsRepository productsRepository;

  SelectMyProductsViewModel(
      {required this.shoppingListRepository, required this.productsRepository});

  late ShoppingList shoppingList;

  List<Product>? userProducts;
  List<Product>? filteruserProducts;
  List<ListProduct>? shoppingProducts;

  String? error;

  Future<void> loadData(ShoppingList shoppingList) async {
    this.shoppingList = shoppingList;

    // Get user products
    productsRepository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      updateList();
      filteruserProducts = userProducts;
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
      userProducts!.forEach((product) {
        product.selected = false;
      });

      shoppingProducts?.forEach((product) {
        userProducts?.forEach((userProduct) {
          if (product.id == userProduct.id) {
            userProduct.selected = true;
          }
        });
      });
    }

    notifyListeners();
  }

  Future<void> selectProduct(int index, Product product,bool selected) async {
    //var product = userProducts![index];
    userProducts![index].selected=selected;
    if (selected) {
      var productList = ListProduct(
          id: product.id,
          category: product.category,
          name: product.name,
          price: product.price,
          quantity: 1,
          total: product.price,
          unit: product.unit,
          selected: false);
      shoppingListRepository.saveProduct(productList, shoppingList);
    } else {
      shoppingListRepository.removeProduct(product.id!, shoppingList);
    }
    notifyListeners();
  }
}
