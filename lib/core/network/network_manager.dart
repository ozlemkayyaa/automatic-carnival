import 'package:dio/dio.dart';
import 'package:weather_app/core/network/api_error_model.dart';
import 'package:weather_app/core/network/api_response_model.dart';

class NetworkManager {
  final Dio _dio;

  NetworkManager({Dio? dio, required String baseUrl})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {
                // TODO: YOUR_API_KEY kısmını kendi API anahtarınızla değiştirin
                'x-rapidapi-key': 'YOUR_API_KEY',
                // TODO: YOUR_API_HOST kısmını kendi API hostunuzla değiştirin
                'x-rapidapi-host': 'YOUR_API_HOST',
              },
            )) {
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      requestHeader: true,
    ));
  }

  /// **Genel GET isteği**
  Future<ApiResponseModel<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic data)? converter,
  }) async {
    try {
      final response =
          await _dio.get(endpoint, queryParameters: queryParameters);

      if (converter != null) {
        final T model = converter(response.data);
        return ApiResponseModel.success(model);
      } else {
        return ApiResponseModel.success(response.data);
      }
    } on DioException catch (e) {
      return ApiResponseModel.error(_handleDioError(e));
    } catch (e) {
      return ApiResponseModel.error(
          ApiErrorModel(message: "Bilinmeyen bir hata oluştu."));
    }
  }

  /// **Dio hatalarını ApiErrorModel'e dönüştürme**
  ApiErrorModel _handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          return ApiErrorModel(message: "Geçersiz istek.", statusCode: 400);
        case 404:
          return ApiErrorModel(
              message: "İstenilen veri bulunamadı.", statusCode: 404);
        case 500:
          return ApiErrorModel(
              message: "Sunucu hatası, lütfen daha sonra tekrar deneyin.",
              statusCode: 500);
        default:
          return ApiErrorModel(
            message: e.response?.statusMessage ?? "Bilinmeyen bir hata oluştu.",
            statusCode: e.response?.statusCode,
          );
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiErrorModel(
          message:
              "Bağlantı zaman aşımına uğradı. Lütfen internetinizi kontrol edin.");
    } else {
      return ApiErrorModel(
          message: "İnternet bağlantısı yok veya bilinmeyen bir hata oluştu.");
    }
  }
}
