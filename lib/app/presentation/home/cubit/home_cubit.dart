import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../data/datasources/models/remote_models/weather_models/clouds_model.dart';
import '../../../data/datasources/models/remote_models/weather_response_model.dart';
import '../../../data/repositories/weather_repositories.dart';
import 'home_state.dart';
import '../../../../core/extensions/weather_format_extension.dart';
import '../../../../core/helpers/weather_status_helper.dart';
import '../../../../core/notification/notification_service.dart';
import '../../../../core/services/location_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final WeatherRepository _weatherRepository;
  final LocationService _locationService = GetIt.I<LocationService>();
  final WeatherStatusHelper _weatherStatusHelper = WeatherStatusHelper();

  HomeCubit({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(
          HomeState(
            isLoading: false,
            errorMessage: "",
            weather: WeatherResponseModel(),
            isDayTime: true,
            weatherStatus: "",
          ),
        );

  Future<void> init() async {
    final savedWeather = await _weatherRepository.getSavedWeather();
    if (savedWeather != null) {
      _updateWeatherState(savedWeather);
      return;
    }
    await fetchWeather();
  }

  Future<void> fetchWeather({double? lat, double? lon}) async {
    final location = await _determineLocation(lat, lon);
    if (location == null) return;

    emit(state.copyWith(isLoading: true, errorMessage: ""));
    final response =
        await _weatherRepository.getWeather(location.$1, location.$2);

    if (response.success && response.data != null) {
      _updateWeatherState(response.data!);
    } else {
      _handleWeatherError(response.message);
    }
  }

  Future<(double, double)?> _determineLocation(double? lat, double? lon) async {
    if (lat != null && lon != null) return (lat, lon);
    final position = await _locationService.getCurrentLocation();
    return (position.latitude, position.longitude);
  }

  void _updateWeatherState(WeatherResponseModel weatherData) async {
    final cityName = extractCityFromTimezone(weatherData.coord?.timezone);
    final weatherCondition = (weatherData.weather?.isNotEmpty ?? false)
        ? weatherData.weather!.first.main
        : "";

    final weatherStatusMessage = _weatherStatusHelper.getWeatherStatus(
      clouds: weatherData.clouds ?? Clouds(cloudiness: 0),
      weatherCondition: weatherCondition,
    );

    await NotificationService().showWeatherNotification(
      temperature: weatherData.temperature?.toDouble() ?? 0,
      weatherStatus: weatherStatusMessage,
    );

    emit(state.copyWith(
      isLoading: false,
      weather: weatherData,
      isDayTime: DateTime.parse(weatherData.dtTxt ?? "").toLocal().isDayTime,
      cityName: cityName,
      weatherStatus: weatherStatusMessage,
      errorMessage: "",
    ));
  }

  void _handleWeatherError(String? message) async {
    final localWeather = await _weatherRepository.getSavedWeather();
    if (localWeather != null) {
      emit(state.copyWith(
        isLoading: false,
        weather: localWeather,
        errorMessage:
            "Veri çekilirken hata oluştu: $message. En son kaydedilen veriler gösteriliyor.",
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        weather: WeatherResponseModel(),
        errorMessage:
            "Veri çekilirken hata oluştu: $message. Varsayılan veriler gösteriliyor.",
      ));
    }
  }

  String extractCityFromTimezone(String? timezone) {
    if (timezone == null) return "Unknown Location";
    final parts = timezone.split('/');
    return parts.length >= 2 ? parts.last.replaceAll('_', ' ') : timezone;
  }

  Future<void> fetchWeatherOverview(String city, String countryCode) async {
    final response =
        await _weatherRepository.getWeatherOverview('$city,$countryCode');
    if (response.success && response.data != null) {
      emit(state.copyWith(overview: response.data));
    } else {
      emit(state.copyWith(
          errorMessage: response.message ?? "Overview verisi alınamadı."));
    }
  }

  Future<void> fetchWeatherForSelectedCity(
      String city, String countryCode) async {
    final place = '$city,$countryCode';
    final overviewResponse = await _weatherRepository.getWeatherOverview(place);
    if (!overviewResponse.success || overviewResponse.data == null) {
      emit(state.copyWith(errorMessage: overviewResponse.message));
      return;
    }

    final fullInfoResponse = await _weatherRepository.getWeather(
        overviewResponse.data!.lat!, overviewResponse.data!.lon!);
    if (!fullInfoResponse.success || fullInfoResponse.data == null) {
      emit(state.copyWith(errorMessage: fullInfoResponse.message));
      return;
    }

    emit(state.copyWith(
      overview: overviewResponse.data,
      weather: fullInfoResponse.data,
      errorMessage: "",
      cityName: city,
    ));
  }

  void clearErrorMessage() {
    emit(state.copyWith(errorMessage: ""));
  }
}
