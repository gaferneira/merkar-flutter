import 'package:flutter/material.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/login_repository.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListsRepository;
  final LoginRepository loginRepository;

  HomePageViewModel(
      {@required this.shoppingListsRepository, @required this.loginRepository});

  List<ShoppingList> list;
  String error;

  String displayName;
  String displayEmail;

  void loadData() async {
    shoppingListsRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });

    final userData = await loginRepository.getUserData();
    displayName = userData.name;
    displayEmail = userData.email;
    notifyListeners();
  }
}
