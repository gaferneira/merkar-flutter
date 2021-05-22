import 'package:flutter/material.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'new_shopping_list_view_model.dart';

String? nameList;
final formListKey = GlobalKey<FormState>();
NewShoppingListViewModel viewModel =
serviceLocator<NewShoppingListViewModel>();

Future<void> NewShoppingListPage(BuildContext context) {

  return showDialog(
    context: context,
    builder: (context)=>AlertDialog(
          title: Text(Strings.label_create_new_list),
        content: StatefulBuilder(
           builder : (BuildContext context, StateSetter setState)=>_fromNewList(viewModel, context)
    ),
      ),
  );

}

  Widget _fromNewList(
      NewShoppingListViewModel viewModel, BuildContext context) {
    return Form(
      key: formListKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(labelText: "Nombre de la lista"),
              onChanged: (value) {
                _showDefaultSugger(value);
              },
              onSaved: (value) {
                nameList = value.toString().capitalize();
              },
              validator: (value) {
                if (value?.isNotEmpty == true) {
                  return null;
                }
                return "Llene este campo";
              },
            ),
            ElevatedButton(
              child: Text(Strings.label_save),
              onPressed: () {
                _saveNewList(context);
              },
            )
          ],
        ),
      ),
    );
  }

  void _saveNewList(BuildContext context) {
    if (formListKey.currentState?.validate() == true) {
      formListKey.currentState!.save();
      Navigator.pop(context);
      viewModel.saveList(nameList, context);
    }
  }

  void _showDefaultSugger(String value) {
    //Search a suggered name to a old list of shoppinglist
  }

