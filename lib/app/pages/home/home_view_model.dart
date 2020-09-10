import 'package:flutter/material.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListsRepository;

  HomePageViewModel({@required this.shoppingListsRepository});

  List<ShoppingList> list;
  String error;

  void loadData() async {
    shoppingListsRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
