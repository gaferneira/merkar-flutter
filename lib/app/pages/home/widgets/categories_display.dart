import 'package:flutter/material.dart';
import 'package:merkar/domain/entities/category.dart';

class CategoriesDisplay extends StatelessWidget {
  final List<Category> categories;

  const CategoriesDisplay({
    Key key,
    @required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            "Categorias",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${categories[index].name}'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
