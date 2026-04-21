import 'package:flutter/material.dart';

class IconSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double width;
  final double height;

  const IconSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.activeIcon,
    required this.inactiveIcon,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.width = 70,      // smaller default width
    this.height = 28,     // smaller default height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Thumb width is half the total width
    final thumbWidth = width * 0.5;
    // Thumb height is slightly smaller than total height to leave margin
    final thumbHeight = height - 4;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          color: value ? inactiveColor : activeColor,
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: thumbWidth,
                height: thumbHeight,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: thumbColor,
                  borderRadius: BorderRadius.circular(thumbHeight / 2),
                ),
                child: Icon(
                  value ?  inactiveIcon: activeIcon,
                  color: activeColor,
                  size: thumbHeight * 0.6, // scale icon nicely
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}