import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class RegisterTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final bool isConformPassword;
  final TextInputType keyboardType;

  const RegisterTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.isConformPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  bool _obscure = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.isPassword || widget.isConformPassword ? _obscure : false,
      keyboardType: widget.keyboardType,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: _focusNode.hasFocus ? ColorManager.darkAccent : Colors.grey,
        ),
        filled: true,
        fillColor: ColorManager.white,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorManager.darkAccent1,
            width: 1.2.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorManager.darkAccent,
            width: 1.8.w,
          ),
        ),
        suffixIcon: (widget.isPassword)
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: SvgPicture.asset(
                  _obscure ? SvgAssets.eyeClosed : SvgAssets.eyeOpen,
                  width: 28.w,
                  height: 28.spMin,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.onError,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
      ),
      onTapOutside: (_) => _focusNode.unfocus(),
    );
  }
}