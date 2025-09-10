import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../data/datasources/models/remote_models/weather_models/daily_weather.dart';
import '../../../widgets/dotted/dotted_widget.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/index.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        // Eğer errorMessage boş değilse custom snackbar göster
        if (state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              // İsteğe bağlı: snackbar'da action ekleyebilirsin
              action: SnackBarAction(
                label: 'Kapat',
                textColor: Colors.white,
                onPressed: () {
                  // Snackbar kapatıldığında yapılacak işlemler
                },
              ),
            ),
          );
          // Snackbar gösterildikten sonra hata mesajını temizleyelim
          context.read<HomeCubit>().clearErrorMessage();
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final weather = state.weather;
          final List<DailyWeather> firstFourForecasts =
              weather.daily?.take(4).toList() ?? [];

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage.isNotEmpty) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  decoration: backgroundColor(state),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      const HomeViewAppBar().symmetricPadding(horizontal: 16),
                      const CityWidget().symmetricPadding(horizontal: 16),
                      const DateWidget().symmetricPadding(horizontal: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TempratureWidget()
                                    .symmetricPadding(horizontal: 16),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Expanded(
                                      child: weatherStatusText(state, context),
                                    ),
                                    const UVContainerWidget(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: context.width * 0.15),
                            child: const SizedBox(
                              child: DottedCircle(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      if (state.weather.daily != null &&
                          state.weather.daily!.isNotEmpty)
                        ForecastWidget(
                          forecasts: firstFourForecasts,
                        ),
                      const InfoCardWidget(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Column weatherStatusText(HomeState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (state.weatherStatus ?? "")
          .split(' ')
          .map(
            (word) => Text(
              word,
              style: TextStyle(
                fontSize: context.width * 0.1,
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ).symmetricPadding(horizontal: 16),
          )
          .toList(),
    );
  }

  BoxDecoration backgroundColor(HomeState state) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: state.isDayTime
            ? [AppColors.morning, AppColors.morning2]
            : [AppColors.night, AppColors.night2],
      ),
    );
  }
}
