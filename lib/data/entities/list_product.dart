class ListProduct {
  String id;
  String path;
  final String name;
  final String category;
  String price;
  int quantity;
  String total;
  bool selected;

  ListProduct(
      {this.id,
      this.name,
      this.price,
      this.category,
      this.quantity,
      this.total,
      this.selected})
      : super();

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
        name: json["name"],
        price: json["price"],
        category: json["category"],
        quantity: json["quantity"],
        total: json["total"],
        selected: json["selected"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "category": category,
        "quantity": quantity,
        "total": total,
        "selected": selected,
      };
}
