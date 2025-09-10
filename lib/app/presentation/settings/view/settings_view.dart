// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../home/cubit/home_cubit.dart';
import '../../home/cubit/home_state.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/city_picker_modal.dart';
import '../widgets/support_widget.dart';
import '../../../widgets/buttons/settings_outlined_button.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/router/app_router.dart';

@RoutePage()
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _showCityPicker(BuildContext context) async {
    final hasInternet =
        await context.read<SettingsCubit>().checkInternetConnection();
    if (!hasInternet) {
      _showNoInternetSnackbar(context);
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CityPickerModal(
          onCitySelected: (cityName, countryCode) async {
            context.read<SettingsCubit>().selectCity(cityName, countryCode);
            _fetchWeatherAndNavigate(context, cityName, countryCode);
          },
        );
      },
    );
  }

  void _showNoInternetSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "İnternet bağlantınız yok, seçim kaydedilmedi.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _fetchWeatherAndNavigate(
      BuildContext context, String city, String countryCode) async {
    final homeCubit = context.read<HomeCubit>();

    // Yüklenme durumunu göstermek için isLoading true yap
    homeCubit.emit(homeCubit.state.copyWith(isLoading: true));

    await homeCubit.fetchWeatherForSelectedCity(city, countryCode);

    // İşlem bittikten sonra isLoading false yap ve HomeView'a yönlendir
    homeCubit.emit(homeCubit.state.copyWith(isLoading: false));
    AppFunction.appRouter.replace(const HomeRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, homeState) {
          return Stack(
            children: [
              // Arkaplan ve içerik
              Container(
                decoration: _backgroundColor(homeState),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.general,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, settingsState) {
                        return SettingsOutlinedButton(
                          onPressed: () => _showCityPicker(context),
                          title: settingsState.selectedCity ??
                              AppStrings.changeCity,
                          icon: Icons.location_on_outlined,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const SupportWidget(),
                  ],
                ).symmetricPadding(horizontal: 16),
              ),

              // API isteği devam ederken gösterilecek yüklenme ekranı
              if (homeState.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.textColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            AppFunction.appRouter.push(const HomeRoute());
          },
          icon: const Icon(Icons.chevron_left_outlined),
          color: AppColors.textColor,
          iconSize: 32,
        ),
        const SizedBox(width: 80),
        const Text(
          AppStrings.settings,
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 32,
          ),
        ),
      ],
    );
  }

  BoxDecoration _backgroundColor(HomeState state) {
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
