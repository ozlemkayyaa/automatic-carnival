import 'dart:convert';
import 'package:weather_app/app/data/datasources/local/weather_local_datasources.dart';
import 'package:weather_app/app/data/datasources/models/local_models/weather_local_model.dart';
import 'package:weather_app/app/data/datasources/models/local_models/weather_local_overview_model.dart';
import 'package:weather_app/app/data/datasources/remote/weather_remote_datasources.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_overview_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_response_model.dart';
import 'package:weather_app/core/network/api_response_model.dart';
import 'package:weather_app/core/result/result.dart';

// Importlar: Remote model içerisindeki nested modelleri de kullanıyoruz.
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/clouds_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/coord_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/daily_weather.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/rain_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/uv_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/weather_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/wind_model.dart';

abstract class WeatherRepository {
  Future<DataResult<WeatherResponseModel>> getWeather(double lat, double lon);
  Future<DataResult<WeatherOverviewModel>> getWeatherOverview(String place);
  Future<WeatherResponseModel?> getSavedWeather();
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasources remoteDatasources;
  final WeatherLocalDatasources localDatasources;

  WeatherRepositoryImpl({
    required this.remoteDatasources,
    required this.localDatasources,
  });

  @override
  Future<DataResult<WeatherResponseModel>> getWeather(
      double lat, double lon) async {
    try {
      // Öncelikle remote API çağrısını gerçekleştiriyoruz.
      final ApiResponseModel<WeatherResponseModel> apiResponse =
          await remoteDatasources.getWeather(lat, lon);

      if (apiResponse.isSuccess && apiResponse.data != null) {
        final remoteWeather = apiResponse.data!;
        // Remote'dan gelen veriyi local modele dönüştürüp kaydediyoruz.
        final localModel = WeatherLocalModel.fromRemote(remoteWeather);
        await localDatasources.saveWeatherData(localModel);

        return SuccessDataResult<WeatherResponseModel>(
          data: remoteWeather,
          message: "Hava durumu başarıyla alındı ve kaydedildi.",
        );
      } else {
        // Remote çağrısı başarısızsa local veriyi deniyoruz.
        final localData = await localDatasources.getLatestWeatherData();
        if (localData != null) {
          final weatherResponse = _mapLocalToRemote(localData);
          return SuccessDataResult<WeatherResponseModel>(
            data: weatherResponse,
            message:
                "Remote çağrısı başarısız, hava durumu local veriden alındı.",
          );
        }
        return ErrorDataResult<WeatherResponseModel>(
          message: apiResponse.error?.message ?? "Bilinmeyen hata oluştu.",
        );
      }
    } catch (e) {
      // Exception durumunda da local veriye fallback yapabiliriz.
      final localData = await localDatasources.getLatestWeatherData();
      if (localData != null) {
        final weatherResponse = _mapLocalToRemote(localData);
        return SuccessDataResult<WeatherResponseModel>(
          data: weatherResponse,
          message:
              "Beklenmeyen hata oluştu, ancak local veriden hava durumu alındı.",
        );
      }
      return ErrorDataResult<WeatherResponseModel>(
        message: "Beklenmeyen bir hata oluştu: $e",
      );
    }
  }

  @override
  Future<DataResult<WeatherOverviewModel>> getWeatherOverview(
      String place) async {
    try {
      final ApiResponseModel<WeatherOverviewModel> apiResponse =
          await remoteDatasources.getWeatherOverview(place);

      if (apiResponse.isSuccess && apiResponse.data != null) {
        // Remote veriyi yerel modele dönüştürüp kaydetmek isteyebilirsin.
        final remoteOverview = apiResponse.data!;
        final localOverview =
            WeatherOverviewLocalModel.fromRemote(remoteOverview);
        await localDatasources.saveWeatherOverviewData(localOverview);

        return SuccessDataResult<WeatherOverviewModel>(
          data: remoteOverview,
          message: "Overview başarıyla alındı.",
        );
      } else {
        // Eğer remote çağrısı başarısızsa, local veriden de çekebilirsin.
        final localData = await localDatasources.getLatestWeatherOverviewData();
        if (localData != null) {
          return SuccessDataResult<WeatherOverviewModel>(
            data: localData.toRemote(),
            message: "Remote çağrısı başarısız, overview local veriden alındı.",
          );
        }
        return ErrorDataResult<WeatherOverviewModel>(
          message: apiResponse.error?.message ?? "Bilinmeyen hata oluştu.",
        );
      }
    } catch (e) {
      return ErrorDataResult<WeatherOverviewModel>(
        message: "Beklenmeyen bir hata oluştu: $e",
      );
    }
  }

  @override
  Future<WeatherResponseModel?> getSavedWeather() async {
    // Local datasource üzerinden kaydedilmiş veriyi getir.
    final localData = await localDatasources.getLatestWeatherData();
    if (localData != null) {
      return _mapLocalToRemote(
          localData); // Daha önce repository'de kullandığımız dönüşüm fonksiyonu.
    }
    return null;
  }

  /// Local modele kaydedilen veriyi, WeatherResponseModel'e dönüştürür.
  WeatherResponseModel _mapLocalToRemote(WeatherLocalModel local) {
    return WeatherResponseModel(
      dt: local.dt,
      dtTxt: local.dtTxt,
      temperature: local.temperature,
      tempratureFeelsLike: local.temperatureFeelsLike,
      dewPointTemprature: local.dewPointTemperature,
      tempratureUnit: local.temperatureUnit,
      pressure: local.pressure,
      pressureUnit: local.pressureUnit,
      humidity: local.humidity,
      humidityUnit: local.humidityUnit,
      visibility: local.visibility,
      visibilityUnit: local.visibilityUnit,
      probabilityOfPrecipitation: local.probabilityOfPrecipitation,
      probabilityOfPrecipitationUnit: local.probabilityOfPrecipitationUnit,
      uv: local.uvJson != null
          ? Uv.fromJson(jsonDecode(local.uvJson as String))
          : null,
      clouds: local.cloudsJson != null
          ? Clouds.fromJson(jsonDecode(local.cloudsJson as String))
          : null,
      rain: local.rainJson != null
          ? Rain.fromJson(jsonDecode(local.rainJson as String))
          : null,
      snow: local.snowJson != null
          ? Rain.fromJson(jsonDecode(local.snowJson as String))
          : null,
      wind: local.windJson != null
          ? Wind.fromJson(jsonDecode(local.windJson as String))
          : null,
      coord: local.cloudsJson != null
          ? Coord.fromJson(jsonDecode(local.coordJson as String))
          : null,
      weather: local.weatherJson != null
          ? (jsonDecode(local.weatherJson!) as List)
              .map((e) => Weather.fromJson(e))
              .toList()
          : [],
      daily: local.dailyJson != null
          ? (jsonDecode(local.dailyJson!) as List)
              .map((e) => DailyWeather.fromJson(e))
              .toList()
          : null,
    );
  }
}
