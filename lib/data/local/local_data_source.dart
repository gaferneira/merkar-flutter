import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/shopping_list.dart';

abstract class LocalDataSource {
  Future<List<ShoppingList?>> getAllCategories();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences? sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ShoppingList?>> getAllCategories() {
    List<ShoppingList?> myList = List<ShoppingList?>.filled(3, null, growable: false);
    myList[0] = ShoppingList(name: "one");
    myList[1] = ShoppingList(name: "two");
    myList[2] = ShoppingList(name: "three");
    return Future.value(myList);
  }
}
