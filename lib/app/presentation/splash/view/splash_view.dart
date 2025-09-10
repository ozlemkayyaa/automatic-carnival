import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../constants/app_colors.dart';
import '../../../get_it/get_it.dart';
import '../../home/cubit/home_cubit.dart';
import '../../../data/repositories/weather_repositories.dart';
import '../cubit/splash_cubit.dart';
import '../cubit/splash_state.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/helpers/functions.dart';
import 'package:objectbox/objectbox.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.4;
    return BlocProvider(
      create: (context) => SplashCubit(
        weatherRepository: getIt.get<WeatherRepository>(),
        homeCubit: getIt.get<HomeCubit>(),
        objectBoxStore: getIt.get<Store>(),
      )..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
          if (state.isInitialized) {
            AppFunction.appRouter.replaceAll([const HomeRoute()]);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.splash,
          body: Center(
            child: Lottie.asset(
              "assets/lottie/splash_lottie.json",
              height: size,
              width: size,
            ),
          ),
        ),
      ),
    );
  }
}
