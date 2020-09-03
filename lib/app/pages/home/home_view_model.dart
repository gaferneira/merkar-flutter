import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/data/entities/error/failures.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class HomePageViewModel extends ChangeNotifier {
  final ShoppingListsRepository categoriesRepository;

  HomePageViewModel({@required this.categoriesRepository});

  bool showLoading = true;
  List<ShoppingList> categories;
  String error;

  /*
  void loadData() async {
    setShowLoading(true);
    var response = await categoriesRepository.getList();

    response.fold((failure) => error = _mapFailureToMessage(failure),
        (list) => categories = list);

    setShowLoading(false);
    notifyListeners();
  }
  */

  void setShowLoading(bool show) {
    showLoading = show;
    notifyListeners();
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
