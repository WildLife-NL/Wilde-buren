import 'package:flutter/material.dart';
import 'package:wilde_buren/config/theme/size_setter.dart';

class BottomNavigationBarIndicator extends StatelessWidget {
  const BottomNavigationBarIndicator({
    super.key,
    this.selectedIndex = 0,
    required this.indicatorWidth,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  final Duration animationDuration;
  final int selectedIndex;
  final double indicatorWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: animationDuration,
      curve: Curves.easeInOut,
      bottom: SizeSetter.getBottomNavigationBarHeight() -
          (SizeSetter.getBottomNavigationBarHeight() / 1.25),
      left: selectedIndex * indicatorWidth,
      child: Container(
        width: indicatorWidth,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Container(
            color: Colors.white,
            width: 60,
            height: 3,
          ),
        ),
      ),
    );
  }
}
