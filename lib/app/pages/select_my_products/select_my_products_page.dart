import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/strings.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import 'select_my_products_view_model.dart';

class SelectMyProductsPage extends StatefulWidget {
  static const routeName = "/select_my_products_page";

  @override
  _SelectMyProductsPageState createState() => _SelectMyProductsPageState();
}

class _SelectMyProductsPageState extends State<SelectMyProductsPage> {
  SelectMyProductsViewModel viewModel =
      serviceLocator<SelectMyProductsViewModel>();

  @override
  Widget build(BuildContext context) {
    viewModel.loadData();

    return ChangeNotifierProvider<SelectMyProductsViewModel>(
        create: (context) => viewModel,
        child: Consumer<SelectMyProductsViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Text(Strings.title_my_products),
                  ),
                  body: SingleChildScrollView(
                    child: (viewModel.list == null)
                        ? Text('Loading...')
                        : _showProductsList(viewModel.list),
                  ),
                )));
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
          title: Text("${listProducts[index].name}"),
          onTap: () {},
        );
      },
    );
  }
}
