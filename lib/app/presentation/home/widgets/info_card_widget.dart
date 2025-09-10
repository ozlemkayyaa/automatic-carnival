import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/weather_format_extension.dart';
import '../../../constants/app_icons.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/container/custom_container.dart';
import '../../../widgets/text/custom_rich_text.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final weather = state.weather;
        final String windSpeedText = weather.formattedWindSpeed;
        final String rainText = weather.formattedRain;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const CustomContainer(
                      icon: AppIcons.windy,
                      text: AppStrings.wind,
                    ),
                    CustomRichText(
                      value: windSpeedText,
                      unit: AppStrings.kmH,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const CustomContainer(
                      icon: AppIcons.drop,
                      text: AppStrings.humidity,
                    ),
                    CustomRichText(
                      value: "${weather.humidity ?? "N/A"}",
                      unit: weather.humidityUnit ?? "",
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const CustomContainer(
                      icon: AppIcons.rainy,
                      text: AppStrings.rain,
                    ),
                    CustomRichText(
                      value: rainText,
                      unit: AppStrings.percentage,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const CustomContainer(
                        icon: AppIcons.meter, text: AppStrings.pressure),
                    CustomRichText(
                      value: "${weather.pressure ?? "N/A"}",
                      unit: weather.pressureUnit ?? "",
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
