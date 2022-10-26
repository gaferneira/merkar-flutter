import 'package:flutter/widgets.dart';
import 'package:merkar/app/core/resources/strings.dart';
import '../../../../data/repositories/login_repository.dart';

class LoginViewModel with ChangeNotifier {
  final LoginRepository repository;

  var loading = false;

  String? error;

  LoginViewModel({required this.repository});

  Future<void> signIn(String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      final response = await repository.signIn(email, password);
      loading = false;
      response.fold(
          (l) => {error = l},
          (r) => {
                if (!r) {error = Strings.no_user_found} else {error = null}
              });
      notifyListeners();
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future signOut() async {
    await repository.signOut();
    notifyListeners();
  }

  void signInWithGoogle() async {
    repository.signInWithGoogle().then((result) {
      if (result != null) {
        error = result;
        notifyListeners();
      }
    });
  }
}
