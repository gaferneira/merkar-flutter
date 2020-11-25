import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/repositories/products_repository.dart';

class SelectMyFavoritesViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;

  SelectMyFavoritesViewModel({@required this.productsRepository});

  List<Product> defaultProducts;
  List<Product> userProducts;

  String error;

  Future<void> loadData() async {
    productsRepository.fetchDefaultProducts().listen((data) {
      defaultProducts = data;
      error = null;
      updateList();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
    productsRepository.fetchItems().listen((data) {
      userProducts = data;
      error = null;
      updateList();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
    updateList();
    // notifyListeners();
  }

  void updateList() {
    if (userProducts != null && defaultProducts != null) {
      defaultProducts.forEach((product) {
        product.selected = false;
      });

      userProducts.forEach((product) {
        defaultProducts.forEach((userProduct) {
          if (product.name == userProduct.name) {
            userProduct.selected = true;
          }
        });
      });
    }

    notifyListeners();
  }

  Future<void> selectProduct(int index, bool selected) async {
    var product = defaultProducts[index];
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
