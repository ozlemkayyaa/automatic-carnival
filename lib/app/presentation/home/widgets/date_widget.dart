import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../../core/extensions/weather_format_extension.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final weather = state.weather;
        //final String formattedDay = weather.formattedDay;
        final String formattedDate = weather.formattedDate;
        return Row(
          children: [
            const Text(
              AppStrings.today,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}
