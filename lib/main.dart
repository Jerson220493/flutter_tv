import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tv/app/data/http/http.dart';
import 'package:tv/app/data/repositories_implementation/authentication_repository_imp.dart';
import 'package:tv/app/data/repositories_implementation/connectivity_repository_imp.dart';
import 'package:tv/app/data/services/remote/authentication_api.dart';
import 'package:tv/app/data/services/remote/internet_checkear.dart';
import 'package:tv/app/domain/repositories/authentication_repository.dart';
import 'package:tv/app/domain/repositories/connectivity_reporsitory.dart';
import 'package:tv/app/my_app.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ConnectivityRepository>(
            create: (_) => ConnectivityRepositoryImp(
                  Connectivity(),
                  InternetCheckear(),
                )),
        Provider<AuthenticationRepository>(
            create: (_) => AuthenticationRepositoryImp(
                  const FlutterSecureStorage(),
                  AuthenticationAPI(
                    Http(
                      client: http.Client(),
                      baseUrl: 'https://api.themoviedb.org/3',
                      apiKey: 'efd0634c28165f7be0156a0b55548243',
                    ),
                  ),
                )),
      ],
      child: MyApp(),
    ),
  );
}
