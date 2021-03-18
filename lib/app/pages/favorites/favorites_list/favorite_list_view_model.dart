import 'package:flutter/material.dart';

import '../../../../data/entities/list_product.dart';
import '../../../../data/entities/shopping_list.dart';
import '../../../../data/repositories/purchases_repository.dart';
import '../../../../data/repositories/shopping_lists_repository.dart';
import 'favorite_list_page.dart';

class FavoriteListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;
  final PurchasesRepository purchasesRepository;

  FavoriteListViewModel(
      {required this.repository, required this.purchasesRepository});

  late ShoppingList shoppingList;
  late List<ListProduct> unselectedList;
  late List<ListProduct> selectedList;
  String? error;

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
    unselectedList = <ListProduct>[];
    selectedList = <ListProduct>[];

    list.forEach((product) {
      if (product.selected!) {
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

  double _calculateTotalPrice(List<ListProduct>? list) {
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
