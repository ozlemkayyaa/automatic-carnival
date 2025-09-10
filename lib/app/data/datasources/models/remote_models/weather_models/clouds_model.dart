// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Clouds extends Equatable {
  int? cloudiness;
  String? unit;

  Clouds({this.cloudiness, this.unit});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      cloudiness: json['cloudiness'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cloudiness': cloudiness,
      'unit': unit,
    };
  }

  @override
  List<Object?> get props => [cloudiness, unit];
}
