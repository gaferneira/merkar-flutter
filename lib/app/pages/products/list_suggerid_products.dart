import 'package:flutter/material.dart';
import 'package:merkar/app/core/constants.dart';

class ListSuggeridProducts extends StatefulWidget {
  static const routeName = "/listsuggeridproducts";
  @override
  _ListSuggeridProductsState createState() => _ListSuggeridProductsState();
}

class _ListSuggeridProductsState extends State<ListSuggeridProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constant.tittle_products),
      ),
    );
  }
}
