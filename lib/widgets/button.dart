import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/config/theme/custom_theme.dart';
import 'package:wilde_buren/models/enums/button_size.dart';
import 'package:wilde_buren/models/enums/button_type.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.type = ButtonType.primary,
    this.size = ButtonSize.md,
    this.icon,
    this.iconSize = 10,
  });

  final String title;
  final Function()? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool disabled;
  final ButtonSize size;
  final String? icon;
  final double? iconSize;

  Color getBackgroundColor(type) {
    switch (type) {
      case ButtonType.primary:
        return CustomColors.secondary;
      case ButtonType.secondary:
        return CustomColors.light200;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.danger:
        return CustomColors.error;
      default:
        return CustomColors.secondary;
    }
  }

  Color getTextColor(type) {
    switch (type) {
      case ButtonType.primary:
        return CustomColors.light;
      case ButtonType.secondary:
        return CustomColors.dark;
      case ButtonType.outline:
        return CustomColors.primary;
      default:
        return CustomColors.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size == ButtonSize.md ? double.infinity : null,
      height: size == ButtonSize.md ? 46 : 36,
      child: Opacity(
        opacity: disabled ? 0.5 : 1,
        child: Material(
          color: getBackgroundColor(type),
          clipBehavior: Clip.antiAlias,
          shape: SmoothRectangleBorder(
            borderRadius: BorderRadius.circular(size == ButtonSize.md ? 12 : 8),
            smoothness: 0.7,
            side: type == ButtonType.outline
                ? const BorderSide(
                    color: CustomColors.light500,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: disabled ? null : onPressed,
            child: isLoading
                ? const Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(CustomColors.light),
                        )))
                : icon != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: CustomTheme(context)
                                .themeData
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: getTextColor(type),
                                  fontWeight: type == ButtonType.outline
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset(
                            icon!,
                            colorFilter: ColorFilter.mode(
                                getTextColor(type), BlendMode.srcIn),
                            width: iconSize,
                          ),
                        ],
                      )
                    : Text(
                        title,
                        style: CustomTheme(context)
                            .themeData
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: getTextColor(type),
                              fontWeight: type == ButtonType.outline
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                      ),
          ),
        ),
      ),
    );
  }
}
