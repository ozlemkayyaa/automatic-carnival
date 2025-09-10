import 'package:objectbox/objectbox.dart';
import 'package:weather_app/app/data/datasources/models/remote_models/weather_overview_model.dart';

@Entity()
class WeatherOverviewLocalModel {
  int id;
  double lat;
  double lon;
  String tz;
  String date;
  String units;
  String weatherOverview;

  WeatherOverviewLocalModel({
    this.id = 0,
    required this.lat,
    required this.lon,
    required this.tz,
    required this.date,
    required this.units,
    required this.weatherOverview,
  });

  /// Remote modelden yerel modele dönüşüm
  factory WeatherOverviewLocalModel.fromRemote(WeatherOverviewModel remote) {
    return WeatherOverviewLocalModel(
      lat: remote.lat ?? 0,
      lon: remote.lon ?? 0,
      tz: remote.tz ?? "Unknown",
      date: remote.date ?? "",
      units: remote.units ?? "",
      weatherOverview: remote.weatherOverview ?? "",
    );
  }

  /// Yerel modelden remote modele dönüşüm
  WeatherOverviewModel toRemote() {
    return WeatherOverviewModel(
      lat: lat,
      lon: lon,
      tz: tz,
      date: date,
      units: units,
      weatherOverview: weatherOverview,
    );
  }
}
