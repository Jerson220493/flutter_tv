import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/app/domain/repositories/authentication_repository.dart';
// import 'package:tv/app/domain/repositories/connectivity_reporsitory.dart';
import 'package:tv/app/presentation/routes/routes.dart';
import 'package:tv/main.dart';

import '../../../../domain/repositories/connectivity_reporsitory.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final connectivityRepository = context.read<ConnectivityRepository>();
    final authenticationRepository = context.read<AuthenticationRepository>();

    final hasInternet = await connectivityRepository.hasInternet;
    if (hasInternet) {
      // esto comprueba si tiene internet

      final isSignedIn = await authenticationRepository.isSignedIn;
      if (isSignedIn) {
        final user = await authenticationRepository.getUserData();
        if (mounted) {
          if (user != null) {
            _goTo(Routes.home);
          } else {
            _goTo(Routes.home);
          }
        }
      } else if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.signIn);
      }
    } else {
      Navigator.pushReplacementNamed(context, Routes.ofLine);
    }
  }

  void _goTo(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
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
