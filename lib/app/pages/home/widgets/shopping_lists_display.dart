import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/app/pages/home/widgets/show_select_list.dart';
import 'package:merkar/data/entities/shopping_list.dart';

Widget shoppingListsDisplay(List<ShoppingList> list) {
  if (list.length == 0) {
    return Center(child: Text(Constant.noCategoriesAvailable));
  }
  return Expanded(
    child: ListView.builder(
      //SCROLL IN LIST
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${list[index].name}'),
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            print(list[index].name);
            Navigator.pushNamed(
              context,
              showSelectList.routeName,
              arguments: list[index],
            );
          },
        );
      },
    ),
  );
}
