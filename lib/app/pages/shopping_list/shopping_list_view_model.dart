import 'package:flutter/material.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class ShoppingListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;

  ShoppingListViewModel({@required this.repository});

  ShoppingList shoppingList;
  List<ListProduct> unselectedList;
  List<ListProduct> selectedList;
  String error;

  Future<void> loadData(ShoppingList shoppingList) async {
    this.shoppingList = shoppingList;
    repository.fetchProducts(shoppingList).listen((data) {
      updateList(data);
      error = null;
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  void updateList(List<ListProduct> list) {
    unselectedList = List<ListProduct>();
    selectedList = List<ListProduct>();

    list.forEach((product) {
      if (product.selected) {
        selectedList.add(product);
      } else {
        unselectedList.add(product);
      }
    });

    notifyListeners();
  }

  Future<void> selectProduct(int index) async {
    var product = unselectedList[index];
    product.selected = true;
    this.selectedList.add(product);
    repository.saveProduct(product, shoppingList);
  }

  Future<void> unselectProduct(int index) async {
    var product = selectedList[index];
    product.selected = false;
    this.selectedList.remove(product);
    repository.saveProduct(product, shoppingList);
  }
}
