import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  FirebaseAuth _auth;
  User _curretUser;

  LoginRepositoryImpl() {
    _auth = FirebaseAuth.instance;
  }

  @override
  User getCurrentUser() {
    _curretUser = _auth.currentUser;
    return _curretUser;
  }

  @override
  Stream<bool> onLoginStatusChanged() {
    return _auth.authStateChanges().map<bool>((user) => user != null);
  }

  @override
  Future<Either<String, bool>> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(result.user != null);
    } on FirebaseException catch (e) {
      return left(e.message);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    _auth.signOut();
    return true;
  }

  @override
  Future<Either<String, bool>> signUp(
      String name, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return right(result.user != null);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> recoverPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return right(true);
    } catch (e) {
      return left(e.toString());
    }
  }
}
