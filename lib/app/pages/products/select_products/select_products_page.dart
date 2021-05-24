import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/widgets/loading_widget.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'select_products_view_model.dart';

class SelectProductsPage extends StatefulWidget {
  static const routeName = "/select_products_page";

  @override
  _SelectProductsPageState createState() => _SelectProductsPageState();
}

class _SelectProductsPageState extends State<SelectProductsPage> {
  SelectProductsViewModel viewModel = serviceLocator<SelectProductsViewModel>();
  TextEditingController _searchTextController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    viewModel.loadData();

    return ChangeNotifierProvider<SelectProductsViewModel>.value(
        value: viewModel,
        child: Consumer<SelectProductsViewModel>(
            builder: (context, model, child) => Scaffold(
                appBar: AppBar(
                  title: Center(
                    child: Form(
                      key: _keyForm,
                      child: Container(
                        width: 270,
                        height: 36,
                        child: TextField(
                          controller: _searchTextController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search,
                                color: Theme.of(context).primaryColor),
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0.0),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            hintText: Strings.label_search,
                          ),
                          onChanged: (value) => viewModel.searchByText(value),
                        ),
                      ),
                    ),
                  ),
                ),
                body: CustomScrollView(
                  slivers: (viewModel.defaultProducts == null)
                      ? [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return LoadingWidget();
                              },
                              childCount: 1,
                            ),
                            // : _showProductsList(viewModel.defaultProducts!),
                          )
                        ]
                      : _sliverList(viewModel.defaultProducts!),
                ))));
  }

  List<Widget> _sliverList(List<Product> list) {
    var productsMap = groupBy(list, (Product obj) => obj.category);
    var widgetList = <Widget>[];
    var keys = productsMap.keys.sorted((a, b) => a!.compareTo(b!));
    for (int index = 0; index < keys.length; index++) {
      var category = keys.elementAt(index)!;
      var products = productsMap[keys.elementAt(index)]!;
      widgetList
        ..add(SliverAppBar(
          leading: Container(),
          title: Text(category),
          pinned: true,
        ))
        ..add(SliverFixedExtentList(
          itemExtent: 50.0,
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                decoration: AppStyles.checklistDecoration(
                    index.toDouble() / products.length),
                child: CheckboxListTile(
                    title: Text(
                        "${products[index].name}: ${products[index].unit} x ${products[index].price}"),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      viewModel.selectProduct(products[index], value == true);
                    },
                    value: products[index].selected),
              ),
            );
          }, childCount: products.length),
        ));
    }
    return widgetList;
  }
}
