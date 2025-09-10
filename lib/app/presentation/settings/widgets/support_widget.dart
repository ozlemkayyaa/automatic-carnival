// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../widgets/buttons/settings_outlined_button.dart';

class SupportWidget extends StatelessWidget {
  const SupportWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.support,
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 12),
        SettingsOutlinedButton(
          onPressed: () {
            print("Terms Of Use Pressed");
          },
          title: AppStrings.termsOfUse,
          icon: Icons.description,
        ),
        const SizedBox(height: 12),
        SettingsOutlinedButton(
          onPressed: () {
            print("Privacy Policy Pressed");
          },
          title: AppStrings.privacyPolicy,
          icon: Icons.privacy_tip,
        ),
      ],
    );
  }
}
