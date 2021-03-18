import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/core/strings.dart';
import '../../../../app/core/extensions/extended_string.dart';
import '../../../../app/widgets/widgets.dart';
import '../../../../data/entities/purchase.dart';
import '../../../../injection_container.dart';
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

  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffKey = GlobalKey<ScaffoldState>();
    return ChangeNotifierProvider<PurchaseHistoryViewModel>(
      create: (context) => viewModel,
      child: Consumer<PurchaseHistoryViewModel>(
        builder: (context, model, child) => Scaffold(
          key: _scaffKey,
          appBar: AppBar(
            title: Text('Historial'),
          ),
          body: SingleChildScrollView(
            child: Column(

                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (context, index) => Divider(
        color: Colors.black,
      ),
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
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
        );
      },
    );
  }
}
