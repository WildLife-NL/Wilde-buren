import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wilde_buren/config/theme/asset_icons.dart';
import 'package:wilde_buren/config/theme/size_setter.dart';
import 'package:wilde_buren/models/enums/button_type.dart';
import 'package:wilde_buren/views/onboarding/widgets/onboarding_content.dart';
import 'package:wilde_buren/widgets/button.dart';

class StartPage extends StatelessWidget {
  const StartPage({
    required this.onNext,
    required this.onPrev,
    super.key,
  });

  final Function() onNext;
  final Function() onPrev;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeSetter.getHorizontalScreenPadding()),
      child: Column(
        children: [
          const OnboardingContent(
            title: 'Wilde Buren',
            description: 'Welkom bij de Wilde Buren applicatie',
            icon: AssetIcons.house,
          ),
          Button(
            title: 'Volgende',
            onPressed: onNext,
            type: ButtonType.primary,
            icon: AssetIcons.chevronRight,
          ),
          const SizedBox(height: 6),
          Button(
            title: 'Terug',
            onPressed: onPrev,
            type: ButtonType.secondary,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
