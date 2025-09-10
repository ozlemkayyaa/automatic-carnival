enum AppIcons {
  drop,
  meter,
  rainy,
  setting,
  windy,
}

extension AppIconsExtension on AppIcons {
  String get fileName {
    switch (this) {
      case AppIcons.drop:
        return 'drop';
      case AppIcons.meter:
        return 'meter';
      case AppIcons.rainy:
        return 'rainy';
      case AppIcons.setting:
        return 'setting';
      case AppIcons.windy:
        return 'windy';
    }
  }

  String get assetPath => 'assets/icons/$fileName.png';
}
