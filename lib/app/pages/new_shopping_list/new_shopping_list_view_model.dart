import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/pages/shopping_list/shopping_list_page.dart';
import 'package:merkar/data/entities/error/failures.dart';
import 'package:merkar/data/entities/shopping_list.dart';
import 'package:merkar/data/repositories/shopping_lists_repository.dart';

class NewShoppingListViewModel extends ChangeNotifier {
  final ShoppingListsRepository repository;

  NewShoppingListViewModel({@required this.repository});

  void saveList(String name, BuildContext context) async {
    final result = await repository.save(ShoppingList(name: name));

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
