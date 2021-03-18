import 'package:flutter/widgets.dart';
import '../../../data/repositories/login_repository.dart';

enum AuthStatus { Uninitialized, Authenticated, Unauthenticated }

class AuthViewModel extends ChangeNotifier {
  final LoginRepository repository;

  AuthStatus _status = AuthStatus.Uninitialized;

  AuthStatus get status => _status;

  AuthViewModel({required this.repository}) {
    repository.onLoginStatusChanged().listen((isLogged) {
      if (isLogged) {
        _status = AuthStatus.Authenticated;
      } else {
        _status = AuthStatus.Unauthenticated;
      }
      notifyListeners();
    });
  }
}
