import 'package:flutter/material.dart';
import '../../core/resources/strings.dart';
import '../../../data/entities/error/failures.dart';
import '../../../data/entities/shopping_list.dart';
import '../../../data/repositories/shopping_lists_repository.dart';
import '../../../data/repositories/login_repository.dart';
import '../shopping/shopping_list/shopping_list_page.dart';

class HomePageViewModel extends ChangeNotifier {
  final ShoppingListsRepository shoppingListsRepository;
  final LoginRepository loginRepository;

  HomePageViewModel(
      {required this.shoppingListsRepository, required this.loginRepository});

  List<ShoppingList>? list;

  String? error;
  String? username;
  String? userEmail;

  void loadData() async {
    var userData = await loginRepository.getUserData();
    this.username = userData.name;
    this.userEmail = userData.email;

    shoppingListsRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }

  void saveList(String? name, BuildContext context) async {
    final result = await shoppingListsRepository.save(ShoppingList(name: name));
    Navigator.pop(context);
    result.fold(
            (failure) => {_mapFailureToMessage(failure)},
            (value) => {
          Navigator.pushNamed(
            context,
            ShoppingListPage.routeName,
            arguments: value,
          )
        });
  }

  Future<void> removeList(int index) async{
    shoppingListsRepository.remove(list![index]);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return Strings.SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return Strings.CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
