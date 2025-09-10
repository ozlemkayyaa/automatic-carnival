// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class WeatherOverviewModel extends Equatable {
  double? lat;
  double? lon;
  String? tz;
  String? date;
  String? units;
  String? weatherOverview;

  WeatherOverviewModel({
    required this.lat,
    required this.lon,
    required this.tz,
    required this.date,
    required this.units,
    required this.weatherOverview,
  });

  factory WeatherOverviewModel.fromJson(Map<String, dynamic> json) {
    return WeatherOverviewModel(
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      tz: json['tz'] as String?,
      date: json['date'] as String?,
      units: json['units'] as String?,
      weatherOverview: json['weather_overview'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'tz': tz,
        'date': date,
        'units': units,
        'weather_overview': weatherOverview,
      };

  @override
  List<Object?> get props => [
        lat,
        lon,
        tz,
        date,
        units,
        weatherOverview,
      ];
}
