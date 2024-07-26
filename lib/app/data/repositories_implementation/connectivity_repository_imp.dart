import 'package:tv/app/domain/repositories/connectivity_reporsitory.dart';

class ConnectivityRepositoryImp implements ConnectivityRepository {
  @override
  Future<bool> get hasInternet {
    return Future.value(true);
  }
}
