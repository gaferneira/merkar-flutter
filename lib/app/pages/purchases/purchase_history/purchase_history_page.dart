import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/extensions/extended_string.dart';
import 'package:merkar/app/core/resources/app_styles.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/widgets/widgets.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

import '../purchase_history_show_info/purchase_history_show_info_page.dart';
import 'purchase_history_view_model.dart';

class PurchaseHistoryPage extends StatefulWidget {
  static const routeName = "/purchasehistory";
  @override
  _PurchaseHistoryPageState createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  PurchaseHistoryViewModel viewModel =
      serviceLocator<PurchaseHistoryViewModel>();
  final keyFormPurchaseList = GlobalKey<FormState>();
  TextEditingController _text_searchController = TextEditingController();
  onItemChangedSelect(String value) {
    viewModel.list = viewModel.filterList!
        .where((shopping_list) =>
            shopping_list.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    viewModel.notifyListeners();
  }

  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider<PurchaseHistoryViewModel>.value(
      //create: (context) => viewModel,
      value: viewModel,
      child: Consumer<PurchaseHistoryViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffKey,
          appBar: AppBar(
            title: Text('Historial'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(Constant.normalspace),
                child: Form(
                  key: keyFormPurchaseList,
                  child: SizedBox(
                    height: 30,
                    width: 270,
                    child: TextFormField(
                      controller: _text_searchController,
                      decoration: InputDecoration(
                        labelText: "Buscar ...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                      ),
                      onChanged: onItemChangedSelect,
                    ),
                  ),
                ),
              ),
              IconButton(icon: Icon(Icons.search), onPressed: () {}),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(

                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      (viewModel.list == null)
                          ? Center(child: LoadingWidget())
                          : purchaseHistoryDisplay(viewModel.list!),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Widget purchaseHistoryDisplay(List<Purchase> list) {
    if (list.length == 0) {
      return Center(child: Text(Strings.noCategoriesAvailable));
    }
    return Expanded(
      child: listProducts(list),
    );
  }

  Widget listProducts(List<Purchase> list) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: AppStyles.listDecoration(index.toDouble()/list.length),
            child: ListTile(
              title: Text(list[index].name?.capitalize() ?? ""),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                print(list[index].name);
                print(list[index].total);
                Navigator.pushNamed(
                  context,
                  PurchaseHistoryShowInfoPage.routeName,
                  arguments: list[index],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
