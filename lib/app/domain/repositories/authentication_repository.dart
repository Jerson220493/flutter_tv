import 'package:tv/app/domain/either.dart';
import 'package:tv/app/domain/enums.dart';
import 'package:tv/app/domain/models/user.dart';

abstract class AuthenticationRepository {
  Future<bool> get isSignedIn;
  Future<User?> getUserData();
  Future<void> signOut();

  Future<Either<signInFailure, User>> signIn(
    String username,
    String password,
  );
}
