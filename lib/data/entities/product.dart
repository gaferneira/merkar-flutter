class Product {
  String defaultId;
  String id;
  String path;
  final String name;
  final String price;
  final String category;

  bool selected = false;

  Product({this.name, this.price, this.category}) : super();

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        price: json["price"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "category": category,
      };
}
