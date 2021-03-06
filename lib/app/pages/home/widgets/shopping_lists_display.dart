import 'package:flutter/material.dart';
import 'package:merkar/app/core/converString.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/data/entities/shopping_list.dart';

import '../../shopping/shopping_list/shopping_list_page.dart';

Widget shoppingListsDisplay(List<ShoppingList> list) {
  if (list.length == 0) {
    return Center(child: Text(Strings.noCategoriesAvailable));
  }
  return Expanded(
    child: listProducts(list),
  );
}

Widget listProducts(List<ShoppingList> list) {
  return ListView.separated(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    separatorBuilder: (context, index) => Divider(
      color: Colors.black,
    ),
    //scroll the listView
    physics: const NeverScrollableScrollPhysics(),
    itemCount: list.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(ConvertString().capitalize('${list[index].name}')),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          print(list[index].name);
          Navigator.pushNamed(
            context,
            ShoppingListPage.routeName,
            arguments: list[index],
          );
        },
      );
    },
  );
}
