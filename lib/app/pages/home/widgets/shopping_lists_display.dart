import 'package:flutter/material.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/shopping/shopping_list/shopping_list_page.dart';
import 'package:merkar/data/entities/shopping_list.dart';

Widget shoppingListsDisplay(
    List<ShoppingList> list, final ValueChanged<int> onRemoveItem) {
  if (list.isEmpty) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(Constant.normalspace),
        child: Center(child: Text(Strings.noCategoriesAvailable)),
      ),
    );
  }
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Dismissible(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration:
                  AppStyles.listDecoration(index.toDouble() / list.length),
              height: 75.0,
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
            ),
          ),
          background: Container(
            color: Colors.red,
            child: Icon(Icons.cancel),
          ),
          key: Key(list[index].id!),
          onDismissed: (direction) => {onRemoveItem(index)},
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: AppStyles.borderRadiusDialog,
                  // contentPadding: EdgeInsets.only(top: 10.0),
                  title: Center(child: const Text(Strings.confirm)),
                  content: const Text("Estás seguro de eliminar el Elemento?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(Strings.calcel),
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(Strings.delete)),
                  ],
                );
              },
            );
          },
        );
      },
      childCount: list.length,
    ),
  );
}
