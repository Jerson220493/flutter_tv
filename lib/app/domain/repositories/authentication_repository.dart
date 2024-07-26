import 'package:tv/app/domain/models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;
  Future<User> getUserData();
}
