
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../../core/resources/constants.dart';

class PieChartView extends StatefulWidget {
  final Map<String, double> dataMap;
  final List<Color> colorList;
  final num total;

  const PieChartView({Key? key, required this.dataMap, required this.colorList,required this.total}) : super(key: key);
  @override
  _PieChartViewState createState() => _PieChartViewState();
}

class _PieChartViewState extends State<PieChartView> {

  @override
  void initState() {
    super.initState();
  }

  int key = 0;

  @override
  Widget build(BuildContext context) {
    final chart = PieChart(
      key: ValueKey(key),
      dataMap: widget.dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: Constant.chartLegendSpacing,
      chartRadius: MediaQuery.of(context).size.width / 1.5 > 300
          ? 300
          : MediaQuery.of(context).size.width / 1.5,
      colorList: widget.colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      centerText:  widget.total.toString(),
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: true,
      ),
      ringStrokeWidth: Constant.ringStrokeWidth,
      emptyColor: Colors.grey,
    );

    return Container(
      child: LayoutBuilder(
        builder: (_, constraints) {
          if (constraints.maxWidth >= 600) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: chart,
                ),

              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: chart,
                    margin: EdgeInsets.symmetric(
                      vertical: 32,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}