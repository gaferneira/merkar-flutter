import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/data/entities/error/failures.dart';
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

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return Constant.SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return Constant.CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
