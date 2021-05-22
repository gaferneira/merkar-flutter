import 'package:flutter/material.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/shopping/shopping_list/shopping_list_page.dart';
import 'package:merkar/app/pages/shopping/shopping_list/shopping_list_view_model.dart';
import 'package:merkar/app/pages/shopping/widgets/alet_confirm.dart';
import 'package:merkar/data/entities/shopping_list.dart';

import '../../../../injection_container.dart';

ShoppingListViewModel viewModel = serviceLocator<ShoppingListViewModel>();
Widget shoppingListsDisplay(List<ShoppingList> list) {
  if (list.length == 0) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(Constant.normalspace),
        child: Center(child: Text(Strings.noCategoriesAvailable)),
      ),
    );
  }
  return  listShoppingList(list);
}

Widget listShoppingList(List<ShoppingList> list) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
        return Dismissible(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: AppStyles.listDecoration(index.toDouble()/list.length),
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
          background: Container(color: Colors.red,child: Icon(Icons.cancel),),
          key: Key(list[index].id!),
          onDismissed: (direction){
             Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text("$list[index].name Eliminada")));
            viewModel.removeList(list[index]);
            list.removeAt(index);
            viewModel.notifyListeners();
          },
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(Strings.confirm),
                  content: const Text("Estás seguro de eliminar el Elemento?"),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(Strings.delete)
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(Strings.calcel),
                    ),
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
