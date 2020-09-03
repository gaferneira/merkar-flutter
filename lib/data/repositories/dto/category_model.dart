import 'package:meta/meta.dart';

import '../../entities/shopping_list.dart';

class NumberTriviaModel extends ShoppingList {
  NumberTriviaModel({
    @required String name,
  }) : super(name: name);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
