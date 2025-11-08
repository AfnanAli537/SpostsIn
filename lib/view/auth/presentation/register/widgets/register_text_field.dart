// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sports_in/core/constants/assets_manager.dart';
// import 'package:sports_in/core/constants/color_manager.dart';

// class RegisterTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final bool isPassword;
//   final bool isConformPassword;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   final bool showError; // ✅ Controls red border

//   const RegisterTextField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     this.isPassword = false,
//     this.isConformPassword = false,
//     this.keyboardType = TextInputType.text,
//     this.validator,
//     this.showError = false, // ✅ Default no error
//   });

//   @override
//   State<RegisterTextField> createState() => _RegisterTextFieldState();
// }

// class _RegisterTextFieldState extends State<RegisterTextField> {
//   bool _obscure = true;
//   late FocusNode _focusNode;
//   String? _errorText;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//     _focusNode.addListener(() => setState(() {}));
    
//     // Add listener to validate on text change
//     widget.controller.addListener(_validateField);
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     widget.controller.removeListener(_validateField);
//     super.dispose();
//   }

//   void _validateField() {
//   if (widget.validator != null) {
//     setState(() {
//       _errorText = widget.validator!(widget.controller.text);
//     });
//   }
// }

// @override
// void didUpdateWidget(RegisterTextField oldWidget) {
//   super.didUpdateWidget(oldWidget);
//   // Re-validate when showError changes
//   if (widget.showError != oldWidget.showError) {
//     _validateField();
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final hasError = widget.showError && _errorText != null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: widget.controller,
//           focusNode: _focusNode,
//           obscureText: widget.isPassword || widget.isConformPassword ? _obscure : false,
//           keyboardType: widget.keyboardType,
//           style: theme.textTheme.bodyMedium,
//           decoration: InputDecoration(
//             labelText: widget.labelText,
//             labelStyle: theme.textTheme.bodyMedium?.copyWith(
//               color:(_focusNode.hasFocus ? ColorManager.darkAccent : Colors.grey),
//             ),
//             contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            
//             // ✅ Normal border
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.r),
//               borderSide: BorderSide(
//                 color: hasError ? ColorManager.error : ColorManager.darkAccent1,
//                 width: hasError ? 1.5.w : 1.2.w,
//               ),
//             ),
            
//             // ✅ Focused border
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10.r),
//               borderSide: BorderSide(
//                 color: ColorManager.darkAccent,
//                 width: 1.8.w,
//               ),
//             ),

//             suffixIcon: (widget.isPassword)
//                 ? IconButton(
//                     onPressed: () => setState(() => _obscure = !_obscure),
//                     icon: SvgPicture.asset(
//                       _obscure ? svgAssets.eyeClosed : svgAssets.eyeOpen,
//                       width: 28.w,
//                       height: 28.spMin,
//                       colorFilter: ColorFilter.mode(
//                        theme.colorScheme.onError,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                   )
//                 : null,
//           ),
//           onTapOutside: (_) => _focusNode.unfocus(),
//         ),
        
//         // ✅ Error text below field
//         if (hasError && _errorText != null)
//           Padding(
//             padding: EdgeInsets.only(top: 4.h, left: 4.w),
//             child: Text(
//               _errorText!,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: ColorManager.error,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
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
  final String? Function(String?)? validator;

  const RegisterTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.isConformPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
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
    final showSuffix = widget.isPassword;

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.isPassword || widget.isConformPassword ? _obscure : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: _focusNode.hasFocus ? ColorManager.darkAccent : Colors.grey,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        errorMaxLines: 3,
        
        // Enabled border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorManager.darkAccent1,
            width: 1.2.w,
          ),
        ),
        
        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorManager.darkAccent,
            width: 1.8.w,
          ),
        ),

        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorManager.error,
            width: 1.5.w,
          ),
        ),

        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ColorManager.error,
            width: 1.8.w,
          ),
        ),

        suffixIcon: showSuffix
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: SvgPicture.asset(
                  _obscure ? svgAssets.eyeClosed : svgAssets.eyeOpen,
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