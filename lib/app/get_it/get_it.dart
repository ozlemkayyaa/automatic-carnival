import 'package:get_it/get_it.dart';
import 'package:weather_app/app/config/config.dart';
import 'package:weather_app/app/data/datasources/local/weather_local_datasources.dart';
import 'package:weather_app/app/data/datasources/models/local_models/weather_local_model.dart';
import 'package:weather_app/app/data/datasources/models/local_models/weather_local_overview_model.dart';
import 'package:weather_app/app/data/datasources/remote/weather_remote_datasources.dart';
import 'package:weather_app/app/data/repositories/weather_repositories.dart';
import 'package:weather_app/app/presentation/home/cubit/home_cubit.dart';
import 'package:weather_app/app/presentation/settings/cubit/settings_cubit.dart';
import 'package:weather_app/app/presentation/splash/cubit/splash_cubit.dart';
import 'package:weather_app/core/network/network_manager.dart';
import 'package:weather_app/core/notification/notification_service.dart';
import 'package:weather_app/core/router/app_router.dart';
import 'package:weather_app/core/services/location_service.dart';
import 'package:weather_app/objectbox.g.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  setupNetworkManager();
  await setupObjectBox();
  setupRepository();
  setupDataSource();
  setupCubit();
  setupLocator();
  setupModel();
}

Future<void> setupObjectBox() async {
  if (!GetIt.I.isRegistered<Store>()) {
    final store = await openStore();
    getIt.registerSingleton<Store>(store);
  }
}

void setupRepository() {
  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDatasources: getIt<WeatherRemoteDatasources>(),
      localDatasources: getIt<WeatherLocalDatasources>(),
    ),
  );
}

void setupNetworkManager() {
  // Base URL'ini API dokümanına göre ayarla
  getIt.registerLazySingleton<NetworkManager>(
    () => NetworkManager(
      baseUrl: ApiConfig.baseUrl,
    ),
  );
}

void setupDataSource() {
  getIt.registerLazySingleton<WeatherRemoteDatasources>(
    () => WeatherRemoteDatasourcesImpl(networkManager: getIt<NetworkManager>()),
  );

  final weatherLocalBox = getIt<Store>().box<WeatherLocalModel>();
  final weatherOverviewBox = getIt<Store>().box<WeatherOverviewLocalModel>();
  getIt.registerLazySingleton<WeatherLocalDatasources>(
    () => WeatherLocalDatasourcesImpl(
        weatherBox: weatherLocalBox, overviewBox: weatherOverviewBox),
  );
}

void setupCubit() {
  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(weatherRepository: getIt<WeatherRepository>()),
  );
  getIt.registerLazySingleton<SplashCubit>(
    () => SplashCubit(
      weatherRepository: getIt<WeatherRepository>(),
      homeCubit: getIt<HomeCubit>(),
      objectBoxStore: getIt<Store>(),
    ),
  );

  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(
      homeCubit: getIt<HomeCubit>(),
    ),
  );
}

void setupLocator() {
  getIt.registerLazySingleton<LocationService>(() => LocationService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
}

void setupModel() {
  getIt.registerSingleton<AppRouter>(AppRouter());
}
