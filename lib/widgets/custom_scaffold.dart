import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/config/theme/custom_theme.dart';
import 'package:wilde_buren/config/theme/size_setter.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold(
      {super.key,
      required this.body,
      this.appBarTitle,
      this.appBackgroundColor = CustomColors.dark,
      this.appBarLeading,
      this.actions,
      this.appBarBackgroundColor = Colors.transparent,
      this.automaticallyImplyLeading = false,
      this.systemOverlayStyle = SystemUiOverlayStyle.light,
      this.extendBehindAppBar = false,
      this.appBar,
      this.floatingActionButton,
      this.drawer,
      this.useAppBar = true,
      this.bottomSafeArea = true,
      this.topSafeArea = true,
      this.floatingActionButtonLocation});
  final Widget body;
  final Widget? appBarTitle;
  final Widget? appBarLeading;
  final List<Widget>? actions;
  final Color appBarBackgroundColor;
  final Color appBackgroundColor;
  final bool automaticallyImplyLeading;
  final SystemUiOverlayStyle systemOverlayStyle;
  final bool extendBehindAppBar;
  final AppBar? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final bool useAppBar;
  final bool bottomSafeArea;
  final bool topSafeArea;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.useAppBar
          ? null
          : widget.appBar ??
              AppBar(
                title: widget.appBarTitle,
                backgroundColor: widget.appBarBackgroundColor,
                titleTextStyle:
                    CustomTheme(context).themeData.textTheme.headlineMedium,
                toolbarHeight: Platform.isIOS ? 55 : 85,
                centerTitle: true,
                elevation: 0,
                leading: widget.appBarLeading,
                actions: widget.actions,
                leadingWidth: 40 + SizeSetter.getHorizontalScreenPadding(),
                systemOverlayStyle: widget.systemOverlayStyle,
                automaticallyImplyLeading: widget.automaticallyImplyLeading,
                iconTheme: const IconThemeData(color: CustomColors.light),
              ),
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        top: widget.topSafeArea,
        bottom: widget.bottomSafeArea,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeSetter.getHorizontalScreenPadding()),
          child: widget.body,
        ),
      ),
    );
  }
}
