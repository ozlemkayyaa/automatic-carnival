import 'package:weather_app/app/data/datasources/models/remote_models/weather_response_model.dart';
import 'package:intl/intl.dart';

extension WeatherFormatting on WeatherResponseModel {
  String get formattedDateTime {
    if (dtTxt == null) return "N/A";
    final dateTime = DateTime.parse(dtTxt!).toLocal();
    final formattedDate = DateFormat("dd.MM.yyyy").format(dateTime);
    final formattedTime = DateFormat("HH:mm").format(dateTime);
    final dayName = DateFormat("EEEE").format(dateTime);
    return "$dayName, $formattedDate - $formattedTime";
  }

  DateTime? get _parsedDateTime {
    if (dtTxt == null) return null;
    return DateTime.parse(dtTxt!).toLocal();
  }

  String get formattedTime {
    if (_parsedDateTime == null) return "N/A";
    return DateFormat("HH:mm").format(_parsedDateTime!);
  }

  String get formattedDay {
    if (_parsedDateTime == null) return "N/A";
    return DateFormat("EEEE").format(_parsedDateTime!);
  }

  String get formattedDayLow {
    if (_parsedDateTime == null) return "N/A";
    return DateFormat("EE").format(_parsedDateTime!);
  }

  String get formattedDate {
    if (_parsedDateTime == null) return "N/A";
    return DateFormat("dd.MM.yy").format(_parsedDateTime!);
  }

  String get temperatureInCelsius {
    if (temperature == null) return "N/A";
    return (temperature! - 273.15).round().toString();
  }

  String get formattedWindSpeed {
    if (wind?.speed == null) return "N/A";
    return (wind!.speed!).toStringAsFixed(1);
  }

  String get formattedUV {
    if (uv?.index == null) return "N/A";
    return (uv!.index!).round().toString();
  }

  String get formattedRain {
    if (rain?.amount == null) return "N/A";
    int probability = (rain!.amount! * 20).round();
    if (probability > 100) probability = 100;
    return "$probability";
  }
}

extension KelvinToCelsius on double {
  String get toCelsiusString => (this - 273.15).round().toString();
}

extension DateTimeExtensions on DateTime {
  bool get isDayTime => hour >= 6 && hour < 18;
}
