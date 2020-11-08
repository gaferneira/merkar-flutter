import 'package:flutter/material.dart';
import 'package:merkar/data/entities/purchase.dart';
import 'package:merkar/data/repositories/purchases_repository.dart';

class PurchaseHistoryViewModel extends ChangeNotifier {
  final PurchasesRepository PurchaseHistoryRepository;
  List<Purchase> filterList;
  PurchaseHistoryViewModel({@required this.PurchaseHistoryRepository});

  List<Purchase> list;
  String error;

  void loadData() async {
    PurchaseHistoryRepository.fetchItems().listen((data) {
      list = data;
      error = null;
      filterList = list;
      notifyListeners();
    }, onError: (e) {
      error = e;
      notifyListeners();
    });
  }
}
