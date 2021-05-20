import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/data/entities/product.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'select_my_favorites_view_model.dart';

class SelectMyFavoritesPage extends StatefulWidget {
  static const routeName = "/select_my_favorites_page";

  @override
  _SelectMyFavoritesPageState createState() => _SelectMyFavoritesPageState();
}

class _SelectMyFavoritesPageState extends State<SelectMyFavoritesPage> {
  SelectMyFavoritesViewModel viewModel =
      serviceLocator<SelectMyFavoritesViewModel>();
  TextEditingController _search_textController = TextEditingController();
  final _keySearchP = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    viewModel.loadData();

    return ChangeNotifierProvider<SelectMyFavoritesViewModel>.value(
        value: viewModel,
        child: Consumer<SelectMyFavoritesViewModel>(
            builder: (context, model, child) => Scaffold(
                  appBar: AppBar(
                    title: Text(Strings.title_sugger_products),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(Constant.normalspace),
                        child: Form(
                          key: _keySearchP,
                          child: SizedBox(
                            height: 30,
                            width: 270,
                            child: TextField(
                              controller: _search_textController,
                              decoration: InputDecoration(
                                labelText: 'Buscar Actual...',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                //hintText: ,
                              ),
                              onChanged: onItemChanged,
                            ),
                          ),
                        ),
                      ),
                      IconButton(icon: Icon(Icons.search), onPressed: () {}),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: (viewModel.defaultProducts == null)
                        ? Text('Loading...')
                        : _showProductsList(viewModel.defaultProducts!),
                  ),
                )));
  }

  onItemChanged(String value) {
    viewModel.defaultProducts = viewModel.filterDefaultProducts!
        .where((product) =>
            product.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  Widget _showProductsList(List<Product> defaultProducts) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        itemCount: defaultProducts.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text("${defaultProducts[index].name}"),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? value) {
              viewModel.selectProduct(index, value == true);
            },
            value: defaultProducts[index].selected,
            activeColor: Colors.cyan,
            checkColor: Colors.green,
          );
        });
  }
}
