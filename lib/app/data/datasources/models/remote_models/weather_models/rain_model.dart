// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Rain extends Equatable {
  int? amount;
  String? unit;

  Rain({this.amount, this.unit});

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      amount: json['amount'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'unit': unit,
    };
  }

  @override
  List<Object?> get props => [amount, unit];
}
