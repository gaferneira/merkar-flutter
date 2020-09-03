import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String name;
  final String price;
  final String category;
  final String quantity;

  Product({this.name, this.price, this.category, this.quantity})
      : super([name]);

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        price: json["price"],
        category: json["category"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "category": category,
        "quantity": quantity,
      };
}
