import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/app_colors.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/weather_format_extension.dart';

class TempratureWidget extends StatelessWidget {
  const TempratureWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final weather = state.weather;
        final String temperatureInCelsius = weather.temperatureInCelsius;
        return Text(
          "$temperatureInCelsius°${weather.tempratureUnit ?? ""}",
          style: TextStyle(
            fontSize: context.height * 0.1,
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
