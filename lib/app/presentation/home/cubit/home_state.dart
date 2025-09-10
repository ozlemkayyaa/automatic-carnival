import 'package:equatable/equatable.dart';
import '../../../data/datasources/models/remote_models/weather_overview_model.dart';
import '../../../data/datasources/models/remote_models/weather_response_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String errorMessage;
  final WeatherResponseModel weather;
  final WeatherOverviewModel? overview;
  final bool isDayTime;
  final String? weatherStatus;

  final String cityName;

  const HomeState({
    required this.isLoading,
    required this.errorMessage,
    required this.weather,
    this.overview,
    this.isDayTime = true,
    this.weatherStatus = "",
    this.cityName = "Unknown Location",
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    WeatherResponseModel? weather,
    WeatherOverviewModel? overview,
    bool? isDayTime,
    String? weatherStatus,
    String? cityName,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      weather: weather ?? this.weather,
      overview: overview ?? this.overview,
      isDayTime: isDayTime ?? this.isDayTime,
      weatherStatus: weatherStatus ?? this.weatherStatus,
      cityName: cityName ?? this.cityName,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        weather,
        overview,
        isDayTime,
        cityName,
        weatherStatus,
      ];
}
