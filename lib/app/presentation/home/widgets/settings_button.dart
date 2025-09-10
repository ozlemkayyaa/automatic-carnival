import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_icons.dart';

class SettingsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double iconSize;
  final double buttonSize;

  const SettingsButton({
    super.key,
    required this.onPressed,
    this.iconSize = 24.0,
    this.buttonSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.7),
                child: Image.asset(
                  AppIcons.setting.assetPath,
                  width: iconSize,
                  height: iconSize,
                  color: AppColors.settings,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
