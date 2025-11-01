// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sports_in/core/constants/assets_manager.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final bool isPassword;
  final bool isConfirmPassword; 
  final TextInputType inputType;
  final IconData? prefixIcon;
  final String? prefixSvg;
  final String? Function(String?)? validator;
  // final  obscuringCharacter;

  const AuthTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.isPassword = false,
    this.isConfirmPassword = false, 
    this.inputType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.prefixSvg, 
  });

  @override
  State<AuthTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final showSuffix = widget.isPassword ;

    return TextFormField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      controller: widget.controller,
      // obscuringCharacter: widget.obscuringCharacter ?? '*',
      obscureText: widget.isPassword || widget.isConfirmPassword ? _obscure : false,
      keyboardType: widget.inputType,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label ?? widget.hintText,
        hintText: widget.label == null ? widget.hintText : null,
        prefixIcon: widget.prefixSvg != null
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  widget.prefixSvg!,
                  width: 14.w,
                  height: 14.w,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onError,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : (widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      widget.prefixIcon,
                      color: Theme.of(context).colorScheme.onError,
                      size: 16.w,
                    ),
                  )
                : null),
        suffixIcon: showSuffix
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: SvgPicture.asset(
                  _obscure ? svgAssets.eyeClosed : svgAssets.eyeOpen,
                  width: 30.w,
                  height: 30.spMin,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onError,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
