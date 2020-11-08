import 'package:flutter/material.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/purchases_repository.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

import 'shopping_list_page.dart';

class ShoppingListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;
  final PurchasesRepository purchasesRepository;

  ShoppingListViewModel(
      {@required this.repository, @required this.purchasesRepository});

  ShoppingList shoppingList;
  List<ListProduct> filterunselectedList;
  List<ListProduct> filterselectedList;
  List<ListProduct> unselectedList;
  List<ListProduct> selectedList;
  String error;

  Future<void> loadData(ShoppingList shoppingList) async {
    this.shoppingList = shoppingList;
    repository.fetchProducts(shoppingList).listen((data) {
      updateList(data);
      filterselectedList = selectedList;
      filterunselectedList = unselectedList;
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

  Future<void> updateProduct(ListProduct product, String oldTotal) async {
    await repository.saveProduct(product, shoppingList);
  }

  String totalPrice() {
    final total = _calculateTotalPrice(unselectedList) +
        _calculateTotalPrice(selectedList);
    return total.toString();
  }

  String totalShopping() => _calculateTotalPrice(selectedList).toString();

  double _calculateTotalPrice(List<ListProduct> list) {
    if (list != null && list.isNotEmpty) {
      final total = list
          .map((item) => item.quantity * double.parse(item.price))
          .reduce((value, element) => value + element);

      return total;
    }
    return 0;
  }

  Future<void> finishShopping(
      BuildContext context, SingingCharacter option, String detail) async {
    await purchasesRepository.create(detail, selectedList);
    switch (option) {
      case SingingCharacter.delete:
        repository.remove(shoppingList);
        break;
      case SingingCharacter.reset:
        selectedList.forEach((product) {
          product.selected = false;
          repository.saveProduct(product, shoppingList);
        });
        break;
      case SingingCharacter.nothing:
        break;
    }

    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
  }
}
