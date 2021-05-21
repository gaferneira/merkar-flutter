import 'package:flutter/material.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/shopping/shopping_list/shopping_list_page.dart';
import 'package:merkar/data/entities/shopping_list.dart';

Widget shoppingListsDisplay(List<ShoppingList> list) {
  if (list.length == 0) {
    return Padding(
      padding: const EdgeInsets.all(Constant.normalspace),
      child: Center(child: Text(Strings.noCategoriesAvailable)),
    );
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
        title: Text(list[index].name!.capitalize()),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
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
