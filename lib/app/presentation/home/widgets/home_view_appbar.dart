import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/app_colors.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'settings_button.dart';
import '../../../../core/extensions/weather_format_extension.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/router/app_router.dart';

class HomeViewAppBar extends StatelessWidget {
  const HomeViewAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final weather = state.weather;
        final String formattedTime = weather.formattedTime;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedTime,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: AppColors.textColor,
              ),
            ),
            SettingsButton(
              onPressed: () {
                AppFunction.appRouter.push(const SettingsRoute());
              },
            ),
          ],
        );
      },
    );
  }
}
