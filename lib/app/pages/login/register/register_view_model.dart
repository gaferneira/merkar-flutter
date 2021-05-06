import 'package:flutter/widgets.dart';
import 'package:merkar/data/repositories/login_repository.dart';

class RegisterViewModel with ChangeNotifier {
  final LoginRepository repository;

  var loading = false;

  String? error;

  RegisterViewModel({required this.repository});

  Future<void> signUp(
      BuildContext context, String name, String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      final response = await repository.signUp(name, email, password);
      loading = false;
      response.fold((l) => {error = l}, (r) => {manageResponse(context, r)});
      notifyListeners();
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  void manageResponse(BuildContext context, bool success) {
    if (!success) {
      error = "No user found";
    } else {
      error = null;
      Navigator.pop(context);
    }
  }

  Future signOut() async {
    await repository.signOut();
    notifyListeners();
  }
}
