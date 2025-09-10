// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Coord extends Equatable {
  double? lat;
  double? lon;
  String? timezone;
  int? timezoneOffset;

  Coord({
    this.lat,
    this.lon,
    this.timezone,
    this.timezoneOffset,
  });

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      timezone: json['timezone'] as String?,
      timezoneOffset: json['timezone_offset'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'timezone': timezone,
        'timezone_offset': timezoneOffset,
      };

  @override
  List<Object?> get props => [
        lat,
        lon,
        timezone,
        timezoneOffset,
      ];
}
