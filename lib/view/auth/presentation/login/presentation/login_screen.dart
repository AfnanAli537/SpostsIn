import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/core/widgets/custom_toggle_switch.dart';
import 'package:sports_in/view/auth/presentation/login/widgets/circular_container.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view_model/language_cubit/language_cubit.dart';
import 'package:sports_in/view_model/theme_cubit/theme_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
final currentMode = context.watch<ThemeCubit>().state;
final brightness = MediaQuery.of(context).platformBrightness;
final effectiveMode = currentMode == ThemeMode.system
    ? (brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light)
    : currentMode;

final currentLocale =context.watch<LocaleCubit>().state;

final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

Locale effectiveLocale;
if (currentLocale == const Locale('system')) {
  effectiveLocale = systemLocale.languageCode == 'ar'
      ? const Locale('ar')
      : const Locale('en');
} else {
  effectiveLocale = currentLocale;
}
    return Scaffold(
        resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),
                const AuthTitle(
                  title: "Welcome",
                  subtitle: "Login to your Account",
                ),
                SizedBox(height: 50.h),
                AuthTextField(
                  prefixSvg: svgAssets.email,
                  label: "Email",
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                AuthTextField(
                  prefixSvg: svgAssets.lockOn,
                  label: "Password",
                  controller: passwordController,
                  isPassword: true,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {Navigator.pushNamed(context, AppRoutes.forgetPassword);},
                    child: Text(
                      "Forgot your password?",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                CustomElevatedButton(text: "Sign in", onPressed: () {}),
                SizedBox(height: 38.h),
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Divider()),
                    Text(
                      "or continue with",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16.h),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   spacing: 20,
                //   children: [
                //     SocialIconButton(
                //       svgPath: svgAssets.facebook,
                //       onTap: () {},
                //     ),
                    SocialIconButton(svgPath: svgAssets.google, onTap: () {}),
                //   ],
                // ),
                SizedBox(height: 24.h),
                Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Don’t have an Account?",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        "Sign UP",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color:Theme.of(context).colorScheme.onPrimaryFixed),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Column(
                  spacing: 7,
                  mainAxisSize: MainAxisSize.min,
                  children: [
//                   CustomAnimatedToggle<ThemeMode>(
//   values: const [
//     ThemeMode.light,
//     ThemeMode.dark,
//     // ThemeMode.system,
//   ],
//   initialValue: ThemeMode.system, 
//   onChanged: (mode) {
//   },
//   iconBuilder: (mode, isSelected) {
//     IconData icon;
//     switch (mode) {
//       case ThemeMode.light:
//         icon = Icons.wb_sunny_rounded; // ☀️
//         break;
//       case ThemeMode.dark:
//         icon = Icons.dark_mode_rounded; // 🌙
//         break;
//       default:
//         icon = Icons.phonelink_setup_sharp; // ⚙️ device/system theme
//         break;
//     }

//     return Icon(
//       icon,
//       color: isSelected
//           ? const Color(0xFF7CB518)
//           : Theme.of(context).iconTheme.color,
//       size: 22.h,
//     );
//   },
// ) ,
//   

  CustomAnimatedToggle<ThemeMode>(
                      values: const [ThemeMode.light, ThemeMode.dark],
                  initialValue: effectiveMode,
  onChanged: (mode) => context.read<ThemeCubit>().setTheme(mode),
                      iconBuilder: (mode, isSelected) {
                        return Icon(
                          mode == ThemeMode.light
                              ? Icons.wb_sunny_rounded
                              : Icons.dark_mode_rounded,
                          color: isSelected
                              ? const Color(0xFF7CB518)
                              : Theme.of(context).iconTheme.color,
                          size: 22.h,
                        );
                      },
                    ), 
CustomAnimatedToggle<String>(
  values: const ["en", "ar"],
  initialValue: effectiveLocale.languageCode, // Fix here
  onChanged: (lang) =>
      context.read<LocaleCubit>().setLocale(Locale(lang)),
  iconBuilder: (value, isSelected) {
    final borderColor = isSelected
        ? const Color(0xFF7CB518)
        : Colors.transparent;
    final imagePath = value == "en"
        ? IconAssets.us
        : IconAssets.eg;

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 1.w,
        ),
      ),
      child: Image.asset(
        imagePath,
        width: 20.w,
        height: 20.h,
      ),
    );
  },
)
,
//                  CustomAnimatedToggle<String>(
//   values: const ["en", "ar", "system"],
//   initialValue: "system", // Default to device language
//   onChanged: (lang) {
//     print("Language changed to: $lang");
//     // Example:
//     // context.read<LocaleCubit>().changeLanguage(lang);
//   },
//   iconBuilder: (value, isSelected) {
//     final borderColor =
//         isSelected ? const Color(0xFF7CB518) : Colors.transparent;

//     String imagePath;
//     switch (value) {
//       case "en":
//         imagePath = IconAssets.us;
//         break;
//       case "ar":
//         imagePath = IconAssets.eg;
//         break;
//       default:
//         imagePath =  IconAssets.system; // <- Add a system icon (e.g. globe)
//         break;
//     }

//     return Container(
//       padding: EdgeInsets.all(2.w),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: 1.w,
//         ),
//       ),
//       child :Image.asset(
//         imagePath,
//         width: 20.w,
//         height: 20.h,
//       ),
//     );
//   },
// )
// ,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
