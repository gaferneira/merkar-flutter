import 'package:flutter/material.dart';
import 'package:merkar/app/pages/shopping_list/shopping_list_page.dart';
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
    //calculate the total
    print(product.price);
    double price = double.parse(product.price);

    this.selectedList.add(product);
    repository.saveProduct(product, shoppingList);
  }

  Future<void> unselectProduct(int index) async {
    var product = selectedList[index];
    product.selected = false;
    //calculate total
    print(product.price);
    double price = double.parse(product.price);
    this.selectedList.remove(product);
    repository.saveProduct(product, shoppingList);
  }

  Future<void> updateProduct(ListProduct product, String oldTotal) async {
    print("Update product shopping list: ${product.total}");
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
    await repository.createPurchaseHistory(detail, selectedList);
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
