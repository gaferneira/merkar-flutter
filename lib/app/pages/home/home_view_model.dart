import 'package:flutter/material.dart';
import '../../../data/entities/shopping_list.dart';
import '../../../data/repositories/shopping_lists_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListsRepository;

  HomePageViewModel({required this.shoppingListsRepository});

  List<ShoppingList>? list;
  List<ShoppingList>? filter_list;
  String? error;

  void loadData() async {
    shoppingListsRepository.fetchItems().listen((data) {
      list = data;
      filter_list = List.from(data);
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  void changeTheme() {
    notifyListeners();
  }
}
