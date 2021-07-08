import 'package:flutter/material.dart';
import 'package:merkar/app/widgets/primary_button.dart';
import '../../../core/extensions/extended_string.dart';
import '../../../core/resources/app_styles.dart';
import '../../../core/resources/strings.dart';
import '../../shopping/shopping_list/shopping_list_page.dart';
import '../../../widgets/confirmDismissDialog.dart';
import '../../../../data/entities/shopping_list.dart';

Widget shoppingListsDisplay(BuildContext context,
  List<ShoppingList> list, final ValueChanged<int> onRemoveItem,
    final ValueChanged <String> onUpdateName) {
  String? nameList;
  final formListKey = GlobalKey<FormState>();
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
                trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert,color: Colors.white), // add this line
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                          child: Container(
                              width: 100,
                              height: 30,
                              child: Text(
                                "Renombrar",
                              )), value: 'change_name'),

                    ],
                    onSelected: (action_select) async {
                      switch (action_select) {
                        case 'change_name':
                         showDialog(
                             barrierDismissible: true,
                             context: context,
                             builder: (context) => AlertDialog(
                           shape: AppStyles.borderRadiusDialog,
                           title: Text(Strings.label_rename_list),
                           content: Form(
                             key: formListKey,
                             child: Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Column(
                                 mainAxisSize: MainAxisSize.min,
                                 children: <Widget>[
                                   TextFormField(
                                     initialValue: list[index].name,
                                     autofocus: true,
                                     decoration: InputDecoration(labelText: Strings.list_name),
                                     onChanged: (value) {
                                     },
                                     onSaved: (value) {
                                       nameList = value.toString().capitalize();
                                     },
                                     validator: (value) {
                                       if (value?.isNotEmpty == true) {
                                         return null;
                                       }
                                       return Strings.error_required_field;
                                     },
                                   ),
                                   PrimaryButton(title: Strings.label_save,
                                       onPressed: () {
                                         if (formListKey.currentState?.validate() == true) {
                                           formListKey.currentState!.save();
                                           String value='${nameList!},$index';
                                           onUpdateName(value);
                                           Navigator.of(context).pop(context);
                                         }
                                       }),
                                 ],
                               ),
                             ),
                           ),
                         )
                         );
                          break;
                      }
                    }),
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