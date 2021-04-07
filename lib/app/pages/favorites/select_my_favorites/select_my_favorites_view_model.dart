import 'package:flutter/material.dart';
import '../../../../data/entities/list_product.dart';
import '../../../../data/entities/product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../data/repositories/products_repository.dart';
import '../../../../data/repositories/shopping_lists_repository.dart';

class SelectMyFavoritesViewModel extends ChangeNotifier {

  final ProductsRepository productsRepository;

  SelectMyFavoritesViewModel(
      {required this.productsRepository});

  late ShoppingList shoppingList;

  List<Product>? defaultProducts;
  List<Product>? userProducts;
  List<Product>? filterDefaultProducts;

  String? error;

  Future<void> loadData(ShoppingList shoppingList) async {
    productsRepository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      updateList();
      filterDefaultProducts = defaultProducts;
    }, onError: (e) {
      error = e;
      notifyListeners();
    });

    // Get shopping list products
    productsRepository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      updateList();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
    updateList();
  }

  void updateList() {
    if (userProducts != null && defaultProducts != null) {
      defaultProducts?.forEach((product) {
        product.selected = false;
      });

      userProducts?.forEach((product) {
        defaultProducts?.forEach((userProduct) {
          if (product.name == userProduct.name) {
            userProduct.selected = true;
          }
        });
      });
    }
  }

  Future<void> selectProduct(int index, bool selected) async {
    var product = defaultProducts![index];
    if (selected) {
      var productList = Product(
//          id: product.id,
        category: product.category,
        name: product.name,
        price: product.price,

        //        quantity: 1,
        //      total: product.price,
        //    selected: false
      );
      productsRepository.save(productList);
    } else {
      //eliminar de productos del user
      // productsRepository.remove(product);
    }
  }
}
