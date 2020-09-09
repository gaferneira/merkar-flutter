import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';
import 'package:merkar/data/entities/shopping_list.dart';

import '../../../../data/entities/shopping_list.dart';

class showSelectList extends StatefulWidget {
  static const routeName = '/showselectlist';
  @override
  _showSelectListState createState() => _showSelectListState();
}

class _showSelectListState extends State<showSelectList> {
  @override
  Widget build(BuildContext context) {
    final list = ModalRoute.of(context).settings.arguments as ShoppingList;
    return Scaffold(
      appBar: AppBar(
        title: Text('${list.name}'),
      ),
      body: SingleChildScrollView(),
    );
  }
}
