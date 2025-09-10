// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static const double _defaultLatitude = 51.5074;
  static const double _defaultLongitude = -0.1278;

  /// Kullanıcının konum izni olup olmadığını kontrol eder ve gerekiyorsa izin ister.
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Kullanıcının konum bilgisini döner.
  /// Eğer izin verilmez veya hata oluşursa, default (Londra) koordinatlarını döndürür.
  Future<Position> getCurrentLocation() async {
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      // Eğer izin yoksa, hata mesajı yerine default koordinatları döndürüyoruz.
      if (!kReleaseMode) {
        print('Konum izni verilmedi. Londra koordinatları kullanılacak.');
      }
      return _defaultPosition();
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      if (!kReleaseMode) {
        print(
            'Konum alınırken hata oluştu: $e. Londra koordinatları kullanılacak.');
      }
      return _defaultPosition();
    }
  }

  Position _defaultPosition() {
    return Position(
      latitude: _defaultLatitude,
      longitude: _defaultLongitude,
      timestamp: DateTime.now(),
      altitude: 0.0,
      accuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }
}
