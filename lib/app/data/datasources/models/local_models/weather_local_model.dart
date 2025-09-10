import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import '../remote_models/weather_response_model.dart';

@Entity()
class WeatherLocalModel {
  int id;
  int? dt;
  String? dtTxt;
  double? temperature;
  double? temperatureFeelsLike;
  double? dewPointTemperature;
  String? temperatureUnit;
  int? pressure;
  String? pressureUnit;
  int? humidity;
  String? humidityUnit;
  int? visibility;
  String? visibilityUnit;
  int? probabilityOfPrecipitation;
  String? probabilityOfPrecipitationUnit;

  // Nested verileri JSON string olarak saklamak için alanlar:
  String? uvJson;
  String? cloudsJson;
  String? rainJson;
  String? snowJson;
  String? windJson;
  String? coordJson;

  // Diğer listeler:
  String? weatherJson;
  String? dailyJson;

  WeatherLocalModel({
    this.id = 0,
    this.dt,
    this.dtTxt,
    this.temperature,
    this.temperatureFeelsLike,
    this.dewPointTemperature,
    this.temperatureUnit,
    this.pressure,
    this.pressureUnit,
    this.humidity,
    this.humidityUnit,
    this.visibility,
    this.visibilityUnit,
    this.probabilityOfPrecipitation,
    this.probabilityOfPrecipitationUnit,
    this.uvJson,
    this.cloudsJson,
    this.rainJson,
    this.snowJson,
    this.windJson,
    this.coordJson,
    this.weatherJson,
    this.dailyJson,
  });

  /// Mapping fonksiyonu: Remote modelden WeatherLocalModel'e dönüşüm
  factory WeatherLocalModel.fromRemote(WeatherResponseModel remote) {
    return WeatherLocalModel(
      dt: remote.dt,
      dtTxt: remote.dtTxt,
      temperature: remote.temperature,
      temperatureFeelsLike: remote.tempratureFeelsLike,
      dewPointTemperature: remote.dewPointTemprature,
      temperatureUnit: remote.tempratureUnit,
      pressure: remote.pressure,
      pressureUnit: remote.pressureUnit,
      humidity: remote.humidity,
      humidityUnit: remote.humidityUnit,
      visibility: remote.visibility,
      visibilityUnit: remote.visibilityUnit,
      probabilityOfPrecipitation: remote.probabilityOfPrecipitation,
      probabilityOfPrecipitationUnit: remote.probabilityOfPrecipitationUnit,
      uvJson: remote.uv != null ? jsonEncode(remote.uv!.toJson()) : null,
      cloudsJson:
          remote.clouds != null ? jsonEncode(remote.clouds!.toJson()) : null,
      rainJson: remote.rain != null ? jsonEncode(remote.rain!.toJson()) : null,
      snowJson: remote.snow != null ? jsonEncode(remote.snow!.toJson()) : null,
      windJson: remote.wind != null ? jsonEncode(remote.wind!.toJson()) : null,
      coordJson:
          remote.coord != null ? jsonEncode(remote.coord!.toJson()) : null,
      weatherJson: remote.weather != null
          ? jsonEncode(remote.weather!.map((w) => w.toJson()).toList())
          : null,
      dailyJson: remote.daily != null
          ? jsonEncode(remote.daily!.map((d) => d.toJson()).toList())
          : null,
    );
  }
}
