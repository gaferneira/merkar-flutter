import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/data/entities/shopping_list.dart';

Widget showList(List<ShoppingList> list) {
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
          trailing: Icon(Icons.adjust),
          onTap: () {
            _showList(list, index);
          },
        );
      },
    ),
  );
}

_showList(List list, int index) {
  //print("Mostrar vista de la lista: ${list[index].name}");
  return SimpleDialog(
    title: const Text('Lista'),
    children: <Widget>[
      Center(
        child: Text('Mostrar vista de la lista: ${list[index].name}'),
      ),
    ],
  );
}
