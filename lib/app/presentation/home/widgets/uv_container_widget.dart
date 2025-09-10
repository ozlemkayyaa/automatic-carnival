import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/weather_format_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class UVContainerWidget extends StatelessWidget {
  const UVContainerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final weather = state.weather;
        final String uvText = weather.formattedUV;
        return Container(
          height: context.width * 0.09,
          width: context.width * 0.2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textColor),
            borderRadius: BorderRadius.circular(20),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                AppStrings.uv,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w500),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color:
                        state.isDayTime ? AppColors.uvDay : AppColors.uvNight,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    uvText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
