import 'package:weather_app/app/data/datasources/models/remote_models/weather_models/clouds_model.dart';

class WeatherStatusHelper {
  String getWeatherStatus({
    required Clouds clouds,
    required String? weatherCondition,
  }) {
    final condition = weatherCondition?.toLowerCase();
    final cloudiness = clouds.cloudiness ?? 0;

    if (condition != null) {
      if (condition.contains('rain')) {
        return "It's Rainy";
      }
      if (condition.contains('snow')) {
        return "It's Snowy";
      }
      if (condition.contains('thunderstorm')) {
        return "There's a Thunderstorm";
      }
      if (condition.contains('drizzle')) {
        return "It's Drizzling";
      }
      if (condition.contains('fog') || condition.contains('mist')) {
        return "It's Foggy";
      }
      if (condition.contains('clear')) {
        if (cloudiness <= 10) {
          return "It's Sunny and Clear";
        }
      }
      if (condition.contains('clouds')) {}
    }

    if (cloudiness <= 10) {
      return "It's Sunny Out";
    } else if (cloudiness > 10 && cloudiness <= 50) {
      return "It's Partly Cloudy";
    } else if (cloudiness > 50 && cloudiness <= 90) {
      return "It's Mostly Cloudy";
    } else {
      return "It's Overcast";
    }
  }
}
