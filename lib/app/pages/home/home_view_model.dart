import 'package:flutter/material.dart';

import '../../../data/entities/shopping_list.dart';
import '../../../data/repositories/login_repository.dart';
import '../../../data/repositories/shopping_lists_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListsRepository;
  final LoginRepository loginRepository;

  HomePageViewModel(
      {required this.shoppingListsRepository, required this.loginRepository});

  List<ShoppingList>? list;
  List<ShoppingList>? filter_list;
  String? error;

  String? username;
  String? userEmail;

  void loadData() async {
    var userData = await loginRepository.getUserData();
    this.username = userData.name;
    this.userEmail = userData.email;

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
