import 'package:flutter/widgets.dart';
import 'package:merkar/data/repositories/login_repository.dart';

class ResetPasswordViewModel with ChangeNotifier {
  final LoginRepository repository;

  var loading = false;

  String error;

  ResetPasswordViewModel({@required this.repository});

  Future<void> recoverPassword(String email, BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      final response = await repository.recoverPassword(email);
      loading = false;
      response.fold((l) => {error = l}, (r) => {Navigator.of(context).pop()});
      notifyListeners();
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
