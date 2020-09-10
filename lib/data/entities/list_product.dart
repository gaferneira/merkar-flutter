class ListProduct {
  String id;
  String path;
  final String name;
  final String price;
  final String category;
  final int quantity;
  final String total;

  ListProduct({this.name, this.price, this.category, this.quantity, this.total})
      : super();

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
        name: json["name"],
        price: json["price"],
        category: json["category"],
        quantity: json["quantity"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "category": category,
        "quantity": quantity,
        "total": total,
      };
}
