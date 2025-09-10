// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class DailyTemperature extends Equatable {
  double? minimum;
  double? maximum;
  double? daytime;
  double? nighttime;
  double? evening;
  double? morning;

  DailyTemperature({
    this.minimum,
    this.maximum,
    this.daytime,
    this.nighttime,
    this.evening,
    this.morning,
  });

  factory DailyTemperature.fromJson(Map<String, dynamic> json) {
    return DailyTemperature(
      minimum: (json['minimum'] as num?)?.toDouble(),
      maximum: (json['maximum'] as num?)?.toDouble(),
      daytime: (json['daytime'] as num?)?.toDouble(),
      nighttime: (json['nighttime'] as num?)?.toDouble(),
      evening: (json['evening'] as num?)?.toDouble(),
      morning: (json['morning'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props =>
      [minimum, maximum, daytime, nighttime, evening, morning];
}
