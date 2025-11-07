// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class CustomAnimatedToggle<T> extends StatefulWidget {
  final List<T> values;
  final T initialValue;
  final ValueChanged<T> onChanged;
  final Widget Function(T value, bool isSelected) iconBuilder;
  final double height;
  final double indicatorWidth;
  final Color? borderColor;
  final Color? backgroundColor;

  const CustomAnimatedToggle({
    super.key,
    required this.values,
    required this.initialValue,
    required this.onChanged,
    required this.iconBuilder,
    this.height = 52,
    this.indicatorWidth = 60,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  State<CustomAnimatedToggle<T>> createState() => _CustomAnimatedToggleState<T>();
}

class _CustomAnimatedToggleState<T> extends State<CustomAnimatedToggle<T>> {
  late T _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final defaultBorder = Theme.of(context).colorScheme.outline.withOpacity(0.4);

    return AnimatedToggleSwitch<T>.size(
      current: _currentValue,
      values: widget.values,
      iconOpacity: 1,
      height: widget.height.h,
      indicatorSize: Size(widget.indicatorWidth.w, widget.height.w),
      borderWidth: 1.8,
      styleBuilder: (value) => ToggleStyle(
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        indicatorColor: Theme.of(context).colorScheme.surface,
        borderColor: widget.borderColor ?? defaultBorder,
      ),
      customIconBuilder: (context, local, global) {
        final isSelected = local.value == _currentValue;
        return widget.iconBuilder(local.value, isSelected);
      },
      onChanged: (value) {
        setState(() => _currentValue = value);
        widget.onChanged(value);
      },
    );
  }
}
