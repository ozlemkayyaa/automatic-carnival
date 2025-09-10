// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/settings_cubit.dart';
import 'custom_city_picker.dart';

class CityPickerModal extends StatelessWidget {
  final Function(String, String) onCitySelected;

  const CityPickerModal({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return CustomCityPicker(
      onCitySelected: (cityName, countryCode) async {
        bool hasInternet =
            await context.read<SettingsCubit>().checkInternetConnection();
        if (!hasInternet) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("İnternet bağlantınız yok, seçim iptal edildi."),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }
        onCitySelected(cityName, countryCode);
      },
    );
  }
}
