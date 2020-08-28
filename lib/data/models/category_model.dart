import 'package:merkar/domain/entities/category.dart';
import 'package:meta/meta.dart';

class NumberTriviaModel extends Category {
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
