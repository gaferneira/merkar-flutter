import 'package:flutter/material.dart';
import '../../../core/extensions/extended_string.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/strings.dart';
import '../../../pages/shopping/shopping_list/shopping_list_page.dart';
import '../../../widgets/confirmDismissDialog.dart';
import '../../../../data/entities/shopping_list.dart';

Widget shoppingListsDisplay(BuildContext context,
    List<ShoppingList> list, final ValueChanged<int> onRemoveItem,) {
  if (list.isEmpty) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(child: Text(
            Strings.home_no_items_available,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
        )),
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
              height: 60.0,
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(list[index].name!.capitalize(),
                      textAlign: TextAlign.left),
                    ),
                     Text('${list[index].total_selected}/${list[index].total_items}',
                         textAlign: TextAlign.right),
                  ],
                ),
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
          onDismissed: (direction)  {
            onRemoveItem(index);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text(Strings.deleted)));
          },
            confirmDismiss: (DismissDirection)=>ConfirmDismissDialog(context, DismissDirection),
        );
      },
      childCount: list.length,
    ),
  );
}
