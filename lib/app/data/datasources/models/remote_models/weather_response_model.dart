// ignore_for_file: must_be_immutable
import 'package:equatable/equatable.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/clouds_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/coord_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/daily_weather.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/rain_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/uv_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/weather_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/wind_model.dart';

class WeatherResponseModel extends Equatable {
  int? dt;
  String? dtTxt;
  double? temperature;
  double? tempratureFeelsLike;
  double? dewPointTemprature;
  String? tempratureUnit;
  int? pressure;
  String? pressureUnit;
  int? humidity;
  String? humidityUnit;
  int? visibility;
  String? visibilityUnit;
  int? probabilityOfPrecipitation;
  String? probabilityOfPrecipitationUnit;
  Uv? uv;
  Clouds? clouds;
  Rain? rain;
  Rain? snow;
  Wind? wind;
  Coord? coord;
  List<Weather>? weather;
  List<DailyWeather>? daily;

  WeatherResponseModel({
    this.dt,
    this.dtTxt,
    this.temperature,
    this.tempratureFeelsLike,
    this.dewPointTemprature,
    this.tempratureUnit,
    this.pressure,
    this.pressureUnit,
    this.humidity,
    this.humidityUnit,
    this.visibility,
    this.visibilityUnit,
    this.probabilityOfPrecipitation,
    this.probabilityOfPrecipitationUnit,
    this.uv,
    this.clouds,
    this.rain,
    this.snow,
    this.wind,
    this.coord,
    this.weather,
    this.daily,
  });

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>?;
    final coord = json['coord'] as Map<String, dynamic>?;
    final current = json['current'] as Map<String, dynamic>?;

    List<DailyWeather>? daily;
    if (json['daily'] != null) {
      daily = (json['daily'] as List)
          .map((e) => DailyWeather.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return WeatherResponseModel(
      dt: current != null ? current['dt'] as int? : json['dt'] as int?,
      dtTxt: current != null
          ? current['dt_txt'] as String?
          : json['dt_txt'] as String?,
      temperature:
          current != null ? (current['temperature'] as num?)?.toDouble() : null,
      tempratureFeelsLike: main != null
          ? (main['temprature_feels_like'] as num?)?.toDouble()
          : null,
      tempratureUnit: main != null ? main['temprature_unit'] as String? : null,
      pressure: current != null ? current['pressure'] as int? : null,
      pressureUnit:
          current != null ? current['pressure_unit'] as String? : null,
      humidity: current != null ? current['humidity'] as int? : null,
      humidityUnit:
          current != null ? current['humidity_unit'] as String? : null,
      visibility: json['visibility_distance'] as int?,
      visibilityUnit: json['visibility_unit'] as String?,
      uv: current != null && current['uv'] != null
          ? Uv.fromJson(current['uv'])
          : null,
      clouds: current != null && current['clouds'] != null
          ? Clouds.fromJson(current['clouds'])
          : null,
      rain: current != null && current['rain'] != null
          ? Rain.fromJson(current['rain'])
          : null,
      snow: json['snow'] != null ? Rain.fromJson(json['snow']) : null,
      wind: current != null && current['wind'] != null
          ? Wind.fromJson(current['wind'])
          : null,
      weather: (json['weather'] as List?)
              ?.map((v) => Weather.fromJson(v))
              .toList() ??
          [],
      coord: coord != null ? Coord.fromJson(coord) : null,
      daily: daily,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // Üst düzey alanlar
    data['dt'] = dt;
    data['dt_txt'] = dtTxt;

    // API'deki "main" nesnesi altındaki alanlar
    final main = <String, dynamic>{};
    main['temprature'] = temperature;
    main['temprature_feels_like'] = tempratureFeelsLike;
    // Eğer dew point değeri varsa; API'de bu alan varsa ekleyin.
    main['temprature_unit'] = tempratureUnit;
    main['pressure'] = pressure;
    main['pressure_unit'] = pressureUnit;
    main['humidity'] = humidity;
    main['humidity_unit'] = humidityUnit;
    data['main'] = main;

    // Visibility alanları
    data['visibility_distance'] = visibility;
    data['visibility_unit'] = visibilityUnit;

    // Diğer opsiyonel alanlar
    if (uv != null) {
      data['uv'] = uv?.toJson();
    }
    if (clouds != null) {
      data['clouds'] = clouds?.toJson();
    }
    if (rain != null) {
      data['rain'] = rain?.toJson();
    }
    if (snow != null) {
      data['snow'] = snow?.toJson();
    }
    if (wind != null) {
      data['wind'] = wind?.toJson();
    }
    if (weather != null) {
      data['weather'] = weather?.map((v) => v.toJson()).toList();
    }
    if (coord != null) {
      data['coord'] = coord?.toJson();
    }
    if (daily != null) {
      data['daily'] = daily?.map((e) => e.toJson()).toList();
    }

    return data;
  }

  @override
  List<Object?> get props => [
        dt,
        dtTxt,
        temperature,
        tempratureFeelsLike,
        dewPointTemprature,
        tempratureUnit,
        pressure,
        pressureUnit,
        humidity,
        humidityUnit,
        visibility,
        visibilityUnit,
        probabilityOfPrecipitation,
        probabilityOfPrecipitationUnit,
        uv,
        clouds,
        rain,
        snow,
        wind,
        weather,
        coord,
        daily
      ];

  WeatherResponseModel copyWith({
    int? dt,
    String? dtTxt,
    double? temperature,
    double? tempratureFeelsLike,
    double? dewPointTemprature,
    String? tempratureUnit,
    int? pressure,
    String? pressureUnit,
    int? humidity,
    String? humidityUnit,
    int? visibility,
    String? visibilityUnit,
    int? probabilityOfPrecipitation,
    String? probabilityOfPrecipitationUnit,
    Uv? uv,
    Clouds? clouds,
    Rain? rain,
    Rain? snow,
    Wind? wind,
    Coord? coord,
    List<Weather>? weather,
    List<DailyWeather>? daily,
  }) {
    return WeatherResponseModel(
      dt: dt ?? this.dt,
      dtTxt: dtTxt ?? this.dtTxt,
      temperature: temperature ?? this.temperature,
      tempratureFeelsLike: tempratureFeelsLike ?? this.tempratureFeelsLike,
      dewPointTemprature: dewPointTemprature ?? this.dewPointTemprature,
      tempratureUnit: tempratureUnit ?? this.tempratureUnit,
      pressure: pressure ?? this.pressure,
      pressureUnit: pressureUnit ?? this.pressureUnit,
      humidity: humidity ?? this.humidity,
      humidityUnit: humidityUnit ?? this.humidityUnit,
      visibility: visibility ?? this.visibility,
      visibilityUnit: visibilityUnit ?? this.visibilityUnit,
      probabilityOfPrecipitation:
          probabilityOfPrecipitation ?? this.probabilityOfPrecipitation,
      probabilityOfPrecipitationUnit:
          probabilityOfPrecipitationUnit ?? this.probabilityOfPrecipitationUnit,
      uv: uv ?? this.uv,
      clouds: clouds ?? this.clouds,
      rain: rain ?? this.rain,
      snow: snow ?? this.snow,
      wind: wind ?? this.wind,
      coord: coord ?? this.coord,
      weather: weather ?? this.weather,
      daily: daily ?? this.daily,
    );
  }
}
