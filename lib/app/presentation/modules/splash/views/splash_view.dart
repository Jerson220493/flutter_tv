import 'package:flutter/material.dart';
import 'package:tv/app/data/repositories_implementation/connectivity_repository_imp.dart';
import 'package:tv/app/domain/repositories/connectivity_reporsitory.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // al ser connectivity reposity imp una implementacion de connectivity repository puede compartese igual y esta se puede instanciar
    ConnectivityRepository connectivityRepository = ConnectivityRepositoryImp();
    final hasInternet = await connectivityRepository.hasInternet;
    if (hasInternet) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
