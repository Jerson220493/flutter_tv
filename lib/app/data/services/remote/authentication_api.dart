import 'dart:convert';

import 'package:tv/app/domain/either.dart';
import 'package:tv/app/domain/enums.dart';

import '../../http/http.dart';

class AuthenticationAPI {
  AuthenticationAPI(this._http);

  final Http _http;

  Either<signInFailure, String> _hangleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode!) {
        case 401:
          return Either.left(signInFailure.unauthorized);
        case 404:
          return Either.left(signInFailure.notFound);
        default:
          return Either.left(signInFailure.unknown);
      }
    }
    if (failure.exception is NetworkException) {
      return Either.left(signInFailure.network);
    }
    return Either.left(signInFailure.unknown);
  }

  Future<Either<signInFailure, String>> createRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
    );
    return result.when(
      _hangleFailure,
      (responseBody) {
        final json = Map<String, dynamic>.from(jsonDecode(responseBody));
        return Either.right(json['request_token'] as String);
      },
    );
  }

  Future<Either<signInFailure, String>> createSessionwithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
    );
    return result.when(
      _hangleFailure,
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );

        final newRequestToken = json['request_token'] as String;
        return Either.right(newRequestToken);
      },
    );
  }

  Future<Either<signInFailure, String>> createSession(
    String request_token,
  ) async {
    final result = await _http.request(
      '/authentication/session/new',
      method: HttpMethod.post,
      body: {'request_token': request_token},
    );

    return result.when(
      _hangleFailure,
      (responseBody) {
        final json = Map<String, dynamic>.from(
          jsonDecode(responseBody),
        );
        final sessionId = json['session_id'] as String;
        return Either.right(sessionId);
      },
    );
  }
}
