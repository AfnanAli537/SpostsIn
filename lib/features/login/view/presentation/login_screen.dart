import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/core/widgets/custom_toggle_switch.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/login/view/widgets/circular_container.dart';
import 'package:sports_in/core/widgets/auth_title.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/features/login/view_model/login_bloc/login_bloc.dart';
import 'package:sports_in/core/config/language_cubit/language_cubit.dart';
import 'package:sports_in/core/config/theme_cubit/theme_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
    final themeCubit = context.watch<ThemeCubit>();

    final currentMode = themeCubit.state;
    final brightness = MediaQuery.of(context).platformBrightness;
    final effectiveMode = currentMode == ThemeMode.system
        ? (brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light)
        : currentMode;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          //           if (state is TokenExpired) {
          //   Navigator.pushReplacementNamed(context, AppRoutes.login);
          //          Fluttertoast.showToast(
          //               msg:string.tokenEX ,
          //               backgroundColor: Colors.red,
          //               toastLength: Toast.LENGTH_LONG,
          //               gravity: ToastGravity.TOP,
          //             );
          // }
          if (state is LoginSuccess) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.mainLayout, (route) => false);

            // Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
            Fluttertoast.showToast(
              msg: string.loginSuccess,
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          } else if (state is LoginFailure) {
            final msg = TranslateErrorHelper.translateErrorKey(
              context,
              state.generalError ?? "",
            );
            Fluttertoast.showToast(
              msg: msg,
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          }
          if (state is GoogleSignInSuccess) {
            Fluttertoast.showToast(
              msg: "sucessfull sign in with google",
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          } else if (state is GoogleSignInFailure) {
            Fluttertoast.showToast(
              msg: state.errorKey,
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
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
                        prefixSvg: SvgAssets.email,
                        label: string.email,
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        validator: (value) => Validators.validateEmail(
                          context: context,
                          value: value,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      AuthTextField(
                        prefixSvg: SvgAssets.lockOn,
                        label: string.password,
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) => Validators.validatePassword(
                          context: context,
                          value: value,
                        ),
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      CustomElevatedButton(
                        text: state is LoginLoading
                            ? string.signingIn
                            : string.signIn,
                        isLoading: state is LoginLoading,
                        enabled: true,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            context.read<LoginBloc>().add(
                              LoginButtonPressed(
                                // context: context,
                                email: email,
                                password: password,
                              ),
                            );
                          }
                        },
                      ),

                      SizedBox(height: 38.h),

                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(child: Divider()),
                          Text(
                            string.continueWith,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      state is GoogleSignInLoading
                          ? const CircularProgressIndicator()
                          : SocialIconButton(
                              svgPath: SvgAssets.google,
                              onTap: () {
                                context.read<LoginBloc>().add(
                                  GoogleSignInRequested(),
                                );
                              },
                            ),

                      SizedBox(height: 24.h),

                      Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            string.notHaveAccount,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.userType,
                              );
                            },
                            child: Text(
                              string.signUp,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryFixed,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),

                      Column(
                        spacing: 7,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                    ? ColorManager.borderCircular
                                    : Theme.of(context).iconTheme.color,
                                size: 22.h,
                              );
                            },
                          ),
                          CustomAnimatedToggle<String>(
                            values: const ["en", "ar"],
                            initialValue: context
                                .read<LocaleCubit>()
                                .defualtLocale
                                .languageCode,
                            onChanged: (lang) {
                              context.read<LocaleCubit>().setLocale(
                                Locale(lang),
                              );
                            },
                            iconBuilder: (value, isSelected) {
                              final borderColor = isSelected
                                  ? ColorManager.borderCircular
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
