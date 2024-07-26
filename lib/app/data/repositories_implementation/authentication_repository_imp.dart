import 'package:tv/app/domain/models/user.dart';
import 'package:tv/app/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImp implements AuthenticationRepository {
  @override
  Future<User> getUserData() {
    return Future.value(User());
  }

  @override
  Future<bool> get isSignedIn {
    return Future.value(true);
  }
}
