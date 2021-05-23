import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import 'purchase_history_show_info_view_model.dart';

class PurchaseHistoryShowInfoPage extends StatefulWidget {
  static const routeName = "/show_info_purchase";
  @override
  _PurchaseHistoryShowInfoPageState createState() =>
      _PurchaseHistoryShowInfoPageState();
}

class _PurchaseHistoryShowInfoPageState
    extends State<PurchaseHistoryShowInfoPage> {
  List<ListProduct>? productsPurchase;
  PurchaseHistoryShowInfoViewModel viewModel =
      serviceLocator<PurchaseHistoryShowInfoViewModel>();
  late Purchase purchase;

  @override
  Widget build(BuildContext context) {
    purchase = ModalRoute.of(context)!.settings.arguments as Purchase;
    viewModel.getProducts(purchase);

    return ChangeNotifierProvider<PurchaseHistoryShowInfoViewModel>.value(
      value: viewModel,
      child: Consumer<PurchaseHistoryShowInfoViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(title: Text(purchase.name!)),
          body: SingleChildScrollView(
            // scrollDirection: Axis.vertical,
            //physics: NeverScrollableScrollPhysics(),
            child: Column(children: <Widget>[
              Text("Fecha: ${purchase.date}"),
              Text("Total: ${purchase.total}"),
              Divider(),
              Text("Productos"),
              (viewModel.listProducts == null)
                  ? Text('Loading...')
                  : _showProductsList(viewModel.listProducts!),
            ]),
          ),
        ),
      ),
    );
  }
}
/*
  @override
  Widget build(BuildContext context) {
    initialState(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(purchase.name),
      ),
      body: SingleChildScrollView(
        child: (viewModel.listProducts == null)
            ? Text('Loading...')
            : _showProductsList(viewModel.listProducts),
      ),
    );
  }*/

Widget _showProductsList(List<ListProduct> listProduct) {
  return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: listProduct.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: AppStyles.listDecoration(index.toDouble()/listProduct.length),
            child: ListTile(
              title: Text("${listProduct[index].name}"),
              /* controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool value) {
                  //viewModel.selectProduct(index, value);
                },
                value: listProduct[index].selected,
                activeColor: Colors.cyan,
                checkColor: Colors.green,*/
            ),
          ),
        );
      });
}
