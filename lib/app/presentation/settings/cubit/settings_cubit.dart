// ignore_for_file: unrelated_type_equality_checks

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/app/presentation/home/cubit/home_cubit.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final HomeCubit homeCubit;

  SettingsCubit({required this.homeCubit}) : super(SettingsState.initial());

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> selectCity(String cityName, String countryCode) async {
    bool hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      emit(state.copyWith(
          errorMessage: "İnternet bağlantısı yok. Seçim iptal edildi."));
      return;
    }

    String fullCity = "$cityName, $countryCode";
    emit(state.copyWith(
      selectedCity: fullCity,
      errorMessage: '',
    ));

    homeCubit.fetchWeatherForSelectedCity(cityName, countryCode);
  }
}
