// ignore_for_file: unrelated_type_equality_checks, avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/app/get_it/get_it.dart';
import 'package:weather_app/core/router/app_router.dart';

final class AppFunction {
  static final appRouter = getIt.get<AppRouter>();

  static Future<bool> checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print('Connectivity result: $connectivityResult');
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      return true; // İnternet var
    }
    return false; // İnternet yok
  }
}
