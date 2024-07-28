import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tv/app/data/repositories_implementation/authentication_repository_imp.dart';
import 'package:tv/app/data/repositories_implementation/connectivity_repository_imp.dart';
import 'package:tv/app/domain/repositories/authentication_repository.dart';
import 'package:tv/app/domain/repositories/connectivity_reporsitory.dart';
import 'package:tv/app/my_app.dart';

void main() {
  runApp(
    Injector(
      authenticationRepository: AuthenticationRepositoryImp(),
      connectivityRepository: ConnectivityRepositoryImp(),
      child: MyApp(),
    ),
  );
}

class Injector extends InheritedWidget {
  const Injector({
    super.key,
    required super.child,
    required this.authenticationRepository,
    required this.connectivityRepository,
  });

  final ConnectivityRepository connectivityRepository;
  final AuthenticationRepository authenticationRepository;

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(_) => false;

  static Injector of(BuildContext context) {
    final injector = context.dependOnInheritedWidgetOfExactType<Injector>();
    assert(injector != null, 'Injector could not be found');
    return injector!;
  }
}
