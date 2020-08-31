import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/category.dart';

abstract class LocalDataSource {
  Future<List<Category>> getAllCategories();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<List<Category>> getAllCategories() {
    List<Category> myList = List<Category>(3);
    myList[0] = Category(name: "one");
    myList[1] = Category(name: "two");
    myList[2] = Category(name: "three");

    return Future.value(myList);
  }
}
