// ignore_for_file: avoid_print, deprecated_member_use, unrelated_type_equality_checks

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/datasources/models/local_models/weather_local_overview_model.dart';
import '../../../data/repositories/weather_repositories.dart';
import '../../home/cubit/home_cubit.dart';
import 'splash_state.dart';
import 'package:objectbox/objectbox.dart';

class SplashCubit extends Cubit<SplashState> {
  final WeatherRepository weatherRepository;
  final HomeCubit homeCubit;
  final Store objectBoxStore;

  // Default koordinatlar: Londra
  static const double _defaultLat = 51.5074;
  static const double _defaultLon = -0.1278;

  SplashCubit({
    required this.weatherRepository,
    required this.homeCubit,
    required this.objectBoxStore,
  }) : super(SplashState.initial());

  Future<void> init() async {
    // Yükleme sürecine başlandığını bildir
    emit(state.copyWith(
        isLoading: true, errorMessage: '', isInitialized: false));

    double lat;
    double lon;

    // ObjectBox içerisindeki en son kaydedilmiş hava durumu verisini al
    final weatherBox = objectBoxStore.box<WeatherOverviewLocalModel>();
    final savedWeather =
        weatherBox.getAll().isNotEmpty ? weatherBox.getAll().last : null;

    if (savedWeather != null) {
      // Kayıtlı veri varsa, onun koordinatlarını kullan
      lat = savedWeather.lat;
      lon = savedWeather.lon;
      print("Kayıtlı veriye göre istek atılıyor: lat=$lat, lon=$lon");
    } else {
      // Kayıtlı veri yoksa konum izinlerini kontrol et
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // İzin yoksa default koordinatlar (Londra) kullanılacak
        print(
            'Konum izni verilmedi. Default koordinatlar (Londra) kullanılacak.');
        lat = _defaultLat;
        lon = _defaultLon;
      } else {
        // İzin varsa mevcut konumu al
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        lat = position.latitude;
        lon = position.longitude;
      }
    }

    bool hasInternet = await _checkInternetConnection();

    if (!hasInternet) {
      print("İnternet bağlantısı yok. Güncellenmiş veri alınamadı.");
    } else {
      // API'ye kayıtlı veya güncel koordinatlarla istek at
      await weatherRepository.getWeather(lat, lon);
    }
    await homeCubit.init();

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(isLoading: false, isInitialized: true));
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
