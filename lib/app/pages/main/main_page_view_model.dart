import 'package:flutter/material.dart';
import '../../../data/repositories/login_repository.dart';

class MainPageViewModel extends ChangeNotifier {
  final LoginRepository loginRepository;

  MainPageViewModel({required this.loginRepository});

  String? userName;
  String? userEmail;

  void loadData() async {
    var userData = await loginRepository.getUserData();
    this.userName = userData.name;
    this.userEmail = userData.email;
    print('User Name: $userName');
  }
}