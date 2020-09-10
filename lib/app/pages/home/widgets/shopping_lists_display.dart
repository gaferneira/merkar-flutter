import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/pages/home/widgets/show_select_list.dart';
import 'package:merkar/data/entities/shopping_list.dart';

Widget shoppingListsDisplay(List<ShoppingList> list) {
  if (list.length == 0) {
    return Center(child: Text(Constant.noCategoriesAvailable));
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
    itemCount: list.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text('${list[index].name}'),
        trailing: Icon(Icons.arrow_right),
        onTap: () {
          print(list[index].name);
          Navigator.pushNamed(
            context,
            ShowSelectList.routeName,
            arguments: list[index],
          );
        },
      );
    },
  );
}
