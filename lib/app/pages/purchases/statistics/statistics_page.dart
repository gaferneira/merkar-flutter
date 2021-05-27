import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merkar/app/core/resources/strings.dart';
import 'package:merkar/app/pages/purchases/purchase_history/purchase_history_page.dart';
import 'package:merkar/app/pages/purchases/statistics/widgets/pie_chart_view.dart';
import 'package:merkar/app/pages/purchases/statistics/statistics_view_model.dart';
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
    return ChangeNotifierProvider<StatisticsViewModel>.value(
      value: viewModel,
      child: Consumer<StatisticsViewModel>(
        builder: (context, model, child)=>DefaultTabController(
          length: 4,
          child: Scaffold(
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
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.today),text: Strings.day,),
                  Tab(icon: Icon(Icons.calendar_view_week),text: Strings.week,),
                  Tab(icon: Icon(Icons.calendar_view_month),text: Strings.month,),
                  Tab(icon: Icon(Icons.calendar_today),text: Strings.year,),
                ],
              ),
            ),
            body:TabBarView(
              children: [
               (viewModel.list!=null && viewModel.list!.isNotEmpty)? PieChartView(colorList: viewModel.colorList, dataMap:viewModel.createDataMapForLists(0),
                    total: viewModel.total):Center(child: Text("No hay datos")),
              (viewModel.list!=null && viewModel.list!.isNotEmpty)? PieChartView(colorList: viewModel.colorList, dataMap:viewModel.createDataMapForLists(1),
                  total: viewModel.total):Center(child: Text("No hay datos")),
                (viewModel.list!=null && viewModel.list!.isNotEmpty)? PieChartView(colorList: viewModel.colorList, dataMap:viewModel.createDataMapForLists(2),
                    total: viewModel.total):Center(child: Text("No hay datos")),
                (viewModel.list!=null && viewModel.list!.isNotEmpty)? PieChartView(colorList: viewModel.colorList, dataMap:viewModel.createDataMapForLists(3),
                    total: viewModel.total):Center(child: Text("No hay datos")),
              ],
            ),

          ),
        ),
      ),
    );
  }

}
