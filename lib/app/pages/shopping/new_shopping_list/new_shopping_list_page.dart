import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/converString.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'new_shopping_list_view_model.dart';

class NewShoppingListPage extends StatefulWidget {
  static const routeName = "/newlist";

  @override
  _NewShoppingListPageState createState() => _NewShoppingListPageState();
}

class _NewShoppingListPageState extends State<NewShoppingListPage> {
  String nameList;
  final formListKey = GlobalKey<FormState>();

  NewShoppingListViewModel viewModel =
      serviceLocator<NewShoppingListViewModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewShoppingListViewModel>.value(
      value: viewModel,
      child: Consumer<NewShoppingListViewModel>(
        builder: (context, model, child) => FadeInUp(
          child: Scaffold(
            appBar: AppBar(
              title: Text(Strings.label_create_new_list),
            ),
            body: _fromNewList(viewModel, context),
          ),
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
              decoration: InputDecoration(labelText: "Nombre de la lista"),
              onSaved: (value) {
                nameList = ConvertString().capitalize(value.toString());
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Llene este campo";
                }
                return null;
              },
            ),
            RaisedButton(
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
    if (formListKey.currentState.validate()) {
      formListKey.currentState.save();
      viewModel.saveList(nameList, context);
    }
  }

  String capitalize(String string) {
    if (string == null) {
      throw ArgumentError.notNull('string');
    }

    if (string.isEmpty) {
      return string;
    }

    return string[0].toUpperCase() + string.substring(1);
  }
}
