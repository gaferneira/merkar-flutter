import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:merkar/app/core/extensions/numberFormat.dart';
import 'package:merkar/app/core/resources/app_colors.dart';
import 'package:merkar/app/core/resources/constants.dart';
import 'package:merkar/app/core/resources/strings.dart';
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
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0,left: 20.0,right: 0.0),
                  child: Text("Fecha: ${purchase.date}",
                  textAlign: TextAlign.start,),
                ),
              ),
              SizedBox(height: Constant.normalspacecontainer,),
              Text("Productos"),
              SizedBox(height: Constant.normalspace,),
              (viewModel.listProducts == null)
                  ? Text('Loading...')
                  : _showTable(viewModel.listProducts!),
               Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(
                       left: 55.0,top: 8.0,
                     ),
                     child: Text(Strings.label_total,
                     textAlign: TextAlign.left,
                     ),
                   ),
                   Expanded(
                     child: Padding(
                       padding: const EdgeInsets.only(
                         top: 8.0,right: 40.0
                       ),
                       child: Text((purchase.total!=null)? numberFormat(purchase.total!) : "",
                       textAlign: TextAlign.right),
                     ),
                   ),
                 ],
               ),
                 // : _showProductsList(viewModel.listProducts!),
            ]),
          ),
        ),
      ),
    );
  }
}

Widget _showTable(List<ListProduct> list){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FixedColumnWidth(60),
            2: FixedColumnWidth(80),
            3: FixedColumnWidth(100),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: _buildData(list),
        ),
  );
}
List<TableRow>_buildData(List<ListProduct> list){
  List<TableRow> tableRows=[];
  tableRows.add(
                TableRow(
                  children: <Widget>[
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        height: Constant.normalspacecontainer,
                        color: AppColors.primaryColor,
                        child: Center(
                          child: Text(Strings.label_product,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.secondaryLightColor),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        height: Constant.normalspacecontainer,
                        color: AppColors.primaryColor,
                        child: Center(
                          child: Text(Strings.label_quantity_r,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.secondaryLightColor),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        height: Constant.normalspacecontainer,
                        color: AppColors.primaryColor,
                        child: Center(
                          child: Text(Strings.label_price,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.secondaryLightColor),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.top,
                      child: Container(
                        height: Constant.normalspacecontainer,
                        color: AppColors.primaryColor,
                        child: Center(
                          child: Text(Strings.label_subtotal,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.secondaryLightColor),
                          ),
                        ),
                      ),
                    ),

                  ],
                )
  );
  for(int index=0; index<list.length;index++){
    tableRows.add(TableRow(
      children: <Widget>[
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            height: Constant.normalspacecontainer,
            child: Center(
              child: Text(list[index].name!,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            height: Constant.normalspacecontainer,
            child: Center(
              child: Text(list[index].quantity.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            height: Constant.normalspacecontainer,
            child: Center(
              child: Text(numberFormat(list[index].price),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.top,
          child: Container(
            height: Constant.normalspacecontainer,
            child: Center(
              child: Text(numberFormat(list[index].price*list[index].quantity),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    ));
  }
  return tableRows;
}

