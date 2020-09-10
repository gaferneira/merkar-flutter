class ShoppingList {
  String id;
  String path;
  final String name;

  ShoppingList({this.name, this.id}) : super();

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      ShoppingList(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}
