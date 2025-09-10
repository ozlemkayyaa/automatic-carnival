import 'package:objectbox/objectbox.dart';
import 'package:weather_app/app/data/datasources/models/local_models/weather_local_model.dart';
import 'package:weather_app/app/data/datasources/models/local_models/weather_local_overview_model.dart';

abstract class WeatherLocalDatasources {
  Future<void> saveWeatherData(WeatherLocalModel data);
  Future<WeatherLocalModel?> getLatestWeatherData();

  Future<void> saveWeatherOverviewData(WeatherOverviewLocalModel overview);
  Future<WeatherOverviewLocalModel?> getLatestWeatherOverviewData();
}

class WeatherLocalDatasourcesImpl implements WeatherLocalDatasources {
  final Box<WeatherLocalModel> weatherBox;
  final Box<WeatherOverviewLocalModel> overviewBox;

  WeatherLocalDatasourcesImpl({
    required this.weatherBox,
    required this.overviewBox,
  });

  @override
  Future<void> saveWeatherData(WeatherLocalModel data) async {
    // Eğer sadece en son veriyi saklayacaksak, mevcut tüm kayıtları temizleyelim:
    final allRecords = weatherBox.getAll();
    if (allRecords.isNotEmpty) {
      weatherBox.removeAll();
    }

    // Yeni veriyi ekleyelim:
    weatherBox.put(data);
  }

  @override
  Future<WeatherLocalModel?> getLatestWeatherData() async {
    // En son kaydedilen weather verisini al.
    final allWeather = weatherBox.getAll();
    if (allWeather.isNotEmpty) {
      // Örneğin, id'si en büyük olan veriyi döndür.
      allWeather.sort((a, b) => b.id.compareTo(a.id));
      return allWeather.first;
    }
    return null;
  }

  @override
  Future<void> saveWeatherOverviewData(
      WeatherOverviewLocalModel overview) async {
    // Overview verisini kaydet.
    overviewBox.put(overview);
  }

  @override
  Future<WeatherOverviewLocalModel?> getLatestWeatherOverviewData() async {
    // En son kaydedilen overview verisini getir.
    final allOverview = overviewBox.getAll();
    if (allOverview.isNotEmpty) {
      // Örneğin, id'si en büyük olan veriyi döndür.
      allOverview.sort((a, b) => b.id.compareTo(a.id));
      return allOverview.first;
    }
    return null;
  }
}
