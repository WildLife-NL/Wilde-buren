import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/config/theme/custom_theme.dart';
import 'package:wilde_buren/config/theme/size_setter.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
  });

  final String title;
  final String description;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: [
          SizedBox(height: SizeSetter.getOnboardingTopSpacing()),
          SvgPicture.asset(
            icon,
            colorFilter:
                const ColorFilter.mode(CustomColors.primary, BlendMode.srcIn),
            height: 90,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: CustomTheme(context).themeData.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: CustomTheme(context).themeData.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
