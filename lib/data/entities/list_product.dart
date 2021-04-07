class ListProduct {
  String? id;
  String? path;
  final String? name;
  final String? category;
  String price = '0';
  int quantity = 1;
  String total = '0';
  bool? selected;

  ListProduct(
      {this.id,
      this.name,
      required this.price,
      this.category,
      required this.quantity,
      required this.total,
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
