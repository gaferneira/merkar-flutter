import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/products_repository.dart';

class SelectMyFavoritesViewModel extends ChangeNotifier {
  final ProductsRepository productsRepository;

  SelectMyFavoritesViewModel({required this.productsRepository});

  late ShoppingList shoppingList;

  List<Product>? defaultProducts;
  List<Product>? userProducts;
  List<Product>? filterDefaultProducts;
  var productsMap;

  String? error;

  Future<void> loadData() async {
    productsRepository.fetchDefaultProducts().listen((data) {
      defaultProducts = data;
      _groupByCollection(data,'categoty');
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
          category: product.category, name: product.name, price: product.price);
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

  void _groupByCollection(List<Product> data,String groupByAttribute) {
    productsMap = groupBy(data, (Product obj) => obj.category);
    //forEach(productsMap, (List<String>category)=>print(category));
    print(productsMap);
  }

}
