import 'package:dartz/dartz.dart';

abstract class LoginRepository {
  Future<Either<String, bool>> signUp(String email, String password);
  Future<Either<String, bool>> signIn(String email, String password);
  Future<bool> signOut();
  Stream<bool> onLoginStatusChanged();
}
