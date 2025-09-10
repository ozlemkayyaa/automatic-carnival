import 'package:flutter/material.dart';
import '../../../data/datasources/local/city_list.dart';

class CustomCityPicker extends StatelessWidget {
  final void Function(String cityName, String countryCode) onCitySelected;

  const CustomCityPicker({super.key, required this.onCitySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 500,
      child: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final cityMap = cities[index];
          return ListTile(
            title: Text("${cityMap['city']}, ${cityMap['countryCode']}"),
            onTap: () {
              final String cityName = (cityMap['city'] as String).trim();
              final String countryCode =
                  (cityMap['countryCode'] as String).trim();

              onCitySelected(cityName, countryCode);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
