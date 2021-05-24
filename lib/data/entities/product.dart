class Product {
  String? id;
  String? path;
  final String? name;
  final String price;
  final String? category;
  final String? unit;

  bool selected = false;

  Product({this.name, required this.price, this.category,this.unit}) : super();

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        price: json["price"],
        category: json["category"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "category": category,
        "unit": unit,
      };
}
