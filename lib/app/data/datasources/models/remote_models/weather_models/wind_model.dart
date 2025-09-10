// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Wind extends Equatable {
  double? speed;
  int? windDeg;
  double? gust;
  String? direction;
  double? gustSpeed;
  String? speedUnit;

  Wind(
      {this.speed,
      this.windDeg,
      this.gust,
      this.direction,
      this.gustSpeed,
      this.speedUnit});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json['speed'] as num?)?.toDouble(),
      windDeg: json['wind_deg'] as int?,
      gust: (json['gust'] as num?)?.toDouble(),
      direction: json['direction'] as String?,
      gustSpeed: (json['gust_speed'] as num?)?.toDouble(),
      speedUnit: json['speed_unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'speed': speed,
        'wind_deg': windDeg,
        'gust': gust,
        'direction': direction,
        'gust_speed': gustSpeed,
        'speed_unit': speedUnit,
      };

  @override
  List<Object?> get props => [
        speed,
        windDeg,
        gust,
        direction,
        gustSpeed,
        speedUnit,
      ];
}
