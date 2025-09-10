// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'daily_temperature.dart';

class DailyWeather extends Equatable {
  int? dt;
  String? dtTxt;
  DailyTemperature? temperature;

  DailyWeather({
    this.dt,
    this.dtTxt,
    this.temperature,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    final temperatureData = json['temperature'] as Map<String, dynamic>?;
    return DailyWeather(
      dt: json['dt'] as int?,
      dtTxt: json['dt_txt'] as String?,
      temperature: temperatureData != null
          ? DailyTemperature.fromJson(temperatureData)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['dt_txt'] = dtTxt;
    if (temperature != null) {
      data['temperature'] = {
        'minimum': temperature!.minimum,
        'maximum': temperature!.maximum,
        'daytime': temperature!.daytime,
        'nighttime': temperature!.nighttime,
        'evening': temperature!.evening,
        'morning': temperature!.morning,
      };
    }
    return data;
  }

  @override
  List<Object?> get props => [dt, dtTxt, temperature];
}
