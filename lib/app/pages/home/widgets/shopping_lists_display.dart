import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/data/entities/shopping_list.dart';

Widget shoppingListsDisplay(List<ShoppingList> list) {
  if (list.length == 0) {
    return Center(child: Text(Constant.noCategoriesAvailable));
  }
  return Expanded(
    child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${list[index].name}'),
        );
      },
    ),
  );
}
