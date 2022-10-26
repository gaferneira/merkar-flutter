import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import '../../../core/extensions/extended_string.dart';
import '../../../core/resources/strings.dart';
import '../../../widgets/primary_button.dart';

Future<void> newShoppingListDialog(
    BuildContext context, final ValueChanged<String> saveNewList) {
  String? nameList;
  final formListKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: AppStyles.borderRadiusDialog,
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
                decoration: InputDecoration(labelText: Strings.list_name),
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
                  return Strings.error_required_field;
                },
              ),
              PrimaryButton(title: Strings.label_save,
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
