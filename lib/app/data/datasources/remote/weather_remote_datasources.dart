// ignore_for_file: avoid_print

import 'package:weather_app/app/config/config.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_overview_model.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_response_model.dart';
import 'package:weather_app/core/network/api_error_model.dart';
import 'package:weather_app/core/network/api_response_model.dart';
import 'package:weather_app/core/network/network_manager.dart';

abstract class WeatherRemoteDatasources {
  Future<ApiResponseModel<WeatherResponseModel>> getWeather(
      double lat, double lon);

  Future<ApiResponseModel<WeatherOverviewModel>> getWeatherOverview(
      String place);
}

class WeatherRemoteDatasourcesImpl implements WeatherRemoteDatasources {
  final NetworkManager _networkManager;

  WeatherRemoteDatasourcesImpl({required NetworkManager networkManager})
      : _networkManager = networkManager;

  @override
  Future<ApiResponseModel<WeatherResponseModel>> getWeather(
      double lat, double lon) async {
    try {
      final String url = "${ApiConfig.fullInfo}?lat=$lat&lon=$lon&lang=en";

      var apiResponseModel = await _networkManager.get(url);

      if (apiResponseModel.isSuccess && apiResponseModel.data != null) {
        var weatherData = WeatherResponseModel.fromJson(apiResponseModel.data!);
        print("API Response: ${apiResponseModel.data}");
        print("API Error: ${apiResponseModel.error?.message}");
        return ApiResponseModel.success(weatherData);
      } else {
        return ApiResponseModel.error(apiResponseModel.error!);
      }
    } catch (e) {
      return ApiResponseModel.error(ApiErrorModel(
        message: "Beklenmeyen bir hata oluştu: $e",
        statusCode: null,
      ));
    }
  }

  @override
  Future<ApiResponseModel<WeatherOverviewModel>> getWeatherOverview(
      String place) async {
    try {
      const String url = ApiConfig.overview;
      // String place = "London,GB";
      final queryParameters = {'place': place};
      final apiResponseModel =
          await _networkManager.get(url, queryParameters: queryParameters);

      if (apiResponseModel.isSuccess && apiResponseModel.data != null) {
        final overviewData =
            WeatherOverviewModel.fromJson(apiResponseModel.data!);
        return ApiResponseModel.success(overviewData);
      } else {
        return ApiResponseModel.error(apiResponseModel.error!);
      }
    } catch (e) {
      return ApiResponseModel.error(ApiErrorModel(
        message: "Beklenmeyen bir hata oluştu: $e",
        statusCode: null,
      ));
    }
  }
}
