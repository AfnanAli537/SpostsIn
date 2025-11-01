// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/core/widgets/custom_toggle_switch.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/presentation/login/widgets/circular_container.dart';
import 'package:sports_in/view/auth/widgets/auth_title.dart';
import 'package:sports_in/view/auth/widgets/auth_text_form_feild.dart';
import 'package:sports_in/view_model/auth/login_bloc/login_bloc.dart';
import 'package:sports_in/view_model/language_cubit/language_cubit.dart';
import 'package:toast/toast.dart';
import 'package:sports_in/view_model/theme_cubit/theme_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
    final themeCubit = context.watch<ThemeCubit>();
    final localeCubit = context.watch<LocaleCubit>();

    final currentMode = themeCubit.state;
    final brightness = MediaQuery.of(context).platformBrightness;

    final effectiveMode = currentMode == ThemeMode.system
        ? (brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light)
        : currentMode;

    final effectiveLocale = localeCubit.state;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Toast.show("Login Successful 🎉", backgroundColor: Colors.green);
            // Navigator.pushNamed(context, AppRoutes.home);
          } else if (state is LoginFailure) {
            Toast.show(state.generalError!, backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          final validatingError = state is LoginFailure;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Form(
                   key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16.h),
                      AuthTitle(
                        title: string.welcome,
                        subtitle: string.loginToYourAccount,
                      ),
                      SizedBox(height: 50.h),
                      AuthTextField(
                        prefixSvg: svgAssets.email,
                        label: string.email,
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        // validator: (_)=>validatingError? state.emailError:null,
                     validator: (value) => Validators.email(value),
                      ),
                      SizedBox(height: 16.h),
                      AuthTextField(
                        prefixSvg: svgAssets.lockOn,
                        label: string.password,
                        controller: passwordController,
                        isPassword: true,
                        // validator:(_)=>validatingError? state.passwordError:null ,
                          validator: (value) => Validators.password(value),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.forgetPassword,
                            );
                          },
                          child: Text(
                            string.forgetYourPassword,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomElevatedButton(
                        text: string.signIn,
                        onPressed: () {
                        if (_formKey.currentState!.validate()) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    context.read<LoginBloc>().add(
      LoginButtonPressed(email: email, password: password),
    );
  }
                        },
                      ),
                      SizedBox(height: 38.h),
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Divider()),
                          Text(
                            string.continueWith,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      SocialIconButton(svgPath: svgAssets.google, onTap: () {}),
                      SizedBox(height: 24.h),
                      Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            string.notHaveAccount,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          GestureDetector(
                            child: Text(
                              string.signUp,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryFixed,
                                  ),
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
                          // 🌞 Theme Toggle
                          CustomAnimatedToggle<ThemeMode>(
                            values: const [ThemeMode.light, ThemeMode.dark],
                            initialValue: effectiveMode,
                            onChanged: (mode) =>
                                context.read<ThemeCubit>().setTheme(mode),
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
                  
                          // 🌐 Language Toggle (Provider-based)
                          CustomAnimatedToggle<String>(
                            values: const ["en", "ar"],
                            initialValue: effectiveLocale.languageCode,
                            onChanged: (lang) {
                              context.read<LocaleCubit>().setLocale(Locale(lang));
                            },
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
