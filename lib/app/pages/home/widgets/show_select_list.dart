import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/data/entities/product.dart';
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

    final List<Product> listProducts = List(1);
    return Scaffold(
      appBar: AppBar(
        title: Text('${list.name}'),
      ),
      body: SingleChildScrollView(
        child: _showProductsList(listProducts),
      ),
    );
  }

  Widget _showProductsList(List<Product> listProducts) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemCount: listProducts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("${listProducts[index]}"),
          onTap: () {},
        );
      },
    );
  }
}
