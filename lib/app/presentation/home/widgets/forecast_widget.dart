import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/app_colors.dart';
import '../../../data/datasources/models/remote_models/weather_models/daily_weather.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/weather_format_extension.dart';

class ForecastWidget extends StatelessWidget {
  final List<DailyWeather> forecasts;

  const ForecastWidget({
    super.key,
    required this.forecasts,
  });

  String getFormattedDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDay = DateTime(date.year, date.month, date.day);
    final diffDays = forecastDay.difference(today).inDays;

    if (diffDays == 0) {
      return "Today";
    } else if (diffDays == 1) {
      return "Tomorrow";
    } else {
      const weekDayAbbr = {
        1: "Mon",
        2: "Tue",
        3: "Wed",
        4: "Thu",
        5: "Fri",
        6: "Sat",
        7: "Sun",
      };
      return weekDayAbbr[forecastDay.weekday] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Sıcaklık birimini WeatherResponseModel içinden alabilirsin.
        final String temperatureUnit = state.weather.tempratureUnit ?? "";

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.9), width: 1),
              bottom:
                  BorderSide(color: Colors.white.withOpacity(0.9), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: forecasts.map((forecast) {
              final date = forecast.dtTxt != null
                  ? DateTime.parse(forecast.dtTxt!).toLocal()
                  : DateTime.now();

              // Örneğin, "daytime" sıcaklığını kullanıyoruz.
              final double? forecastTemp = forecast.temperature?.daytime;
              final String displayTemp =
                  forecastTemp != null ? forecastTemp.toCelsiusString : "--";

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getFormattedDay(date),
                    style: TextStyle(
                      color: AppColors.textColor.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$displayTemp°$temperatureUnit",
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ).symmetricPadding(vertical: 8);
            }).toList(),
          ),
        );
      },
    ).symmetricPadding(horizontal: 16);
  }
}
