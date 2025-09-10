// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Uv extends Equatable {
  double? index;
  String? level;

  Uv({this.index, this.level});

  factory Uv.fromJson(Map<String, dynamic> json) {
    return Uv(
      index: (json['index'] as num?)?.toDouble(),
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'level': level,
    };
  }

  @override
  List<Object?> get props => [index, level];
}
