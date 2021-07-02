class ShoppingList {
  String? id;
  String? path;
  final String? name;
  String? total_items;
  String? total_selected;

  ShoppingList({this.name, this.id, this.total_items,this.total_selected}) : super();

  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
      ShoppingList(name: json["name"],
          total_items: json["total_items"],
          total_selected: json["total_selected"]);

  Map<String, dynamic> toJson() => {"name": name,
    "total_items": total_items,
    "total_selected": total_selected,
  };
}
