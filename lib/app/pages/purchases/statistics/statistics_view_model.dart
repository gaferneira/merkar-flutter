
import 'package:flutter/material.dart';
import 'package:merkar/data/entities/list_product.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:merkar/data/repositories/purchases_repository.dart';

class StatisticsViewModel extends ChangeNotifier {
  final PurchasesRepository purchaseHistoryRepository;
  StatisticsViewModel({required this.purchaseHistoryRepository});

  List<Purchase>? list;
  String? error;
  Map<String, double> dataMap={};
  List<Color> colorList = [
  ];
  num total=0;

  void loadData() async {
    purchaseHistoryRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });

  }
  Map<String, double> createDataMapForLists(int option){
    dataMap={};
    total=0;
    if(list != null){
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      switch (option){
         case 0://comparar por día
            for(int i=0;i<list!.length;i++) {
              if (DateTime.parse(list![i].date!) == date) {
                int tempTotal = double.parse(list![i].total!).round();
                dataMap.putIfAbsent(
                    list![i].name!, () => tempTotal.roundToDouble());
                Color _randomColor = ([...Colors.primaries]..shuffle()).first;
                colorList.add(_randomColor);
                total += num.parse(list![i].total!);
              }
            }
              break;
        case 1:
          for(int i=0;i<list!.length;i++) {
            if (weekForDate(DateTime.parse(list![i].date!)) == weekForDate(date)) {
              int tempTotal = double.parse(list![i].total!).round();
              dataMap.putIfAbsent(
                  list![i].name!, () => tempTotal.roundToDouble());
              Color _randomColor = ([...Colors.primaries]..shuffle()).first;
              colorList.add(_randomColor);
              total += num.parse(list![i].total!);
            }
          }
          break;

      case 2:
            for(int i=0;i<list!.length;i++) {
              if (DateTime.parse(list![i].date!).month == date.month) {
                int tempTotal = double.parse(list![i].total!).round();
                dataMap.putIfAbsent(
                    list![i].name!, () => tempTotal.roundToDouble());
                Color _randomColor = ([...Colors.primaries]..shuffle()).first;
                colorList.add(_randomColor);
                total += num.parse(list![i].total!);
              }
            }
            break;

        case 3:
          for(int i=0;i<list!.length;i++) {
            if (DateTime.parse(list![i].date!).year == date.year) {
              int tempTotal = double.parse(list![i].total!).round();
              dataMap.putIfAbsent(
                  list![i].name!, () => tempTotal.roundToDouble());
              Color _randomColor = ([...Colors.primaries]..shuffle()).first;
              colorList.add(_randomColor);
              total += num.parse(list![i].total!);
            }
          }
          break;
        }
     // print(dataMap);
    }
    if(dataMap.isEmpty) {
      dataMap.putIfAbsent(
          'No hay datos', () => 0.0);
      colorList.add(Colors.red);
    }
    return dataMap;
  }
  int weekForDate(DateTime someDate){
    final date = someDate;
    final startOfYear = new DateTime(date.year, 1, 1, 0, 0);
    final firstMonday = startOfYear.weekday;
    final daysInFirstWeek = 8 - firstMonday;
    final diff = date.difference(startOfYear);
    var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
// It might differ how you want to treat the first week
    if(daysInFirstWeek > 3) {
      weeks += 1;
    }
    return weeks;
  }

}
