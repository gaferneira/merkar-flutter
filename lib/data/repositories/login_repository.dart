import 'package:dartz/dartz.dart';
import 'package:merkar/data/entities/user_data.dart';

abstract class LoginRepository {
  Future<Either<String, bool>> signUp(
      String name, String email, String password);
  Future<Either<String, bool>> signIn(String email, String password);
  Future<Either<String, bool>> recoverPassword(String email);
  Future<bool> signOut();
  Stream<bool> onLoginStatusChanged();
  Future<UserData> getUserData();
}
