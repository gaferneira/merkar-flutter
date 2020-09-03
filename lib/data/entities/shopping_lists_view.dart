import 'package:equatable/equatable.dart';

class ShoppingList extends Equatable {
  final String name;

  ShoppingList({
    this.name,
  }) : super([name]);

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      ShoppingList(name: json["name"]);

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
