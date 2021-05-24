import 'package:flutter/material.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/core/widgets/internal_button.dart';

Future<void> newShoppingListDialog(
    BuildContext context, final ValueChanged<String> saveNewList) {
  String? nameList;
  final formListKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(Strings.label_create_new_list),
      content: Form(
        key: formListKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(labelText: "Nombre de la lista"),
                onChanged: (value) {
                  //_showDefaultSuggested(value);
                },
                onSaved: (value) {
                  nameList = value.toString().capitalize();
                },
                validator: (value) {
                  if (value?.isNotEmpty == true) {
                    return null;
                  }
                  return "Llene el nombre";
                },
              ),
              InternalButton(title: Strings.label_save,
                  onPressed: () {
                      if (formListKey.currentState?.validate() == true) {
                      formListKey.currentState!.save();
                      saveNewList(nameList!);
                      }
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
