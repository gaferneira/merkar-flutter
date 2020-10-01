class Purchase {
  String id;
  String path;
  final String name;
  final String date;
  final String total;
  final String totalProducts;

  Purchase({this.name, this.date, this.total, this.totalProducts, this.id})
      : super();

  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
      name: json["name"],
      date: json["date"],
      total: json["total"],
      totalProducts: json["totalProducts"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "total": total,
        "totalProducts": totalProducts
      };
}
