import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/purchases/purchase_history/purchase_history_page.dart';
import 'package:merkar/app/pages/purchases/statistics/widgets/pie_chart_view.dart';
import 'package:merkar/app/pages/purchases/statistics/statistics_view_model.dart';
import 'package:merkar/app/widgets/loading_widget.dart';
import 'package:merkar/injection_container.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  static const routeName="/statistics";

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  StatisticsViewModel viewModel =
      serviceLocator<StatisticsViewModel>();
  final _scaffKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    viewModel.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.createDataMapForLists();
    return ChangeNotifierProvider<StatisticsViewModel>.value(
      value: viewModel,
      child: Consumer<StatisticsViewModel>(
        builder: (context, model, child)=>Scaffold(
          key: _scaffKey,
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.list_alt),
                onPressed: (){
                  Navigator.of(context).pushNamed(PurchaseHistoryPage.routeName);
                },
              ),
            ],
            title: Center(child: Text(Strings.statistics)),
          ),
          body:(viewModel.dataMap.isNotEmpty)? PieChartView(colorList: viewModel.colorList, dataMap:viewModel.dataMap):Text("No hay datos"),
        ),
      ),
    );
  }

  _buildPieChart(BuildContext context) {
    return Container();
  }
}
