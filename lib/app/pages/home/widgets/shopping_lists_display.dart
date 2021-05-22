import 'package:flutter/material.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/shopping/shopping_list/shopping_list_page.dart';
import 'package:merkar/data/entities/shopping_list.dart';

Widget shoppingListsDisplay(List<ShoppingList> list) {
  if (list.length == 0) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(Constant.normalspace),
        child: Center(child: Text(Strings.noCategoriesAvailable)),
      ),
    );
  }
  return  listProducts(list);
}

Widget listProducts(List<ShoppingList> list) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
        return Container(
          color: index.isOdd ? Colors.white : Colors.black12,
          height: 100.0,
          child: ListTile(
            title: Text(list[index].name!.capitalize()),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(
                context,
                ShoppingListPage.routeName,
                arguments: list[index],
              );
            },
          ),
        );
      },
      childCount: list.length,
    ),
  );
}
