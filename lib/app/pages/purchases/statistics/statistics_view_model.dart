import 'dart:math';

import 'package:flutter/material.dart';
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
  void createDataMapForLists(){

    if(list != null){
      for(int i=0;i<list!.length;i++){
        double tempTotal = double.parse(list![i].total!);
        dataMap.putIfAbsent(list![i].name!,()=> tempTotal.roundToDouble());
          Color _randomColor = ([...Colors.primaries]..shuffle()).first;
          colorList.add(_randomColor);

      }
      print(dataMap);
    }
    }

}
