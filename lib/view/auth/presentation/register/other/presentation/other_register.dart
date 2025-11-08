import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/localization_helper.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/data_sources/register_lists.dart';
import 'package:sports_in/data/models/other_dto.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

class OthersRegisterScreen extends StatelessWidget {
  OthersRegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Using ValueNotifiers for dropdown values to trigger rebuilds
  final genderNotifier = ValueNotifier<String?>(null);
  final locationNotifier = ValueNotifier<String?>(null);
  final imageNotifier = ValueNotifier<File?>(null);

  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(
    AutovalidateMode.disabled,
  );

  void _onRegister(BuildContext context, S string) {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (genderNotifier.value == null || locationNotifier.value == null) {
      debugPrint("Validation failed: Required dropdowns are empty.");
      return;
    }

    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    final userData = OtherDto(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      gender: genderNotifier.value!,
      location: locationNotifier.value!,
      image: imageNotifier.value,
    );

    context.read<RegistrationBloc>().add(
      SubmitRegistrationEvent(userData: userData),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationLoading) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is RegistrationSuccess) {
            // Dismiss loading
            Navigator.of(context).pop();
            Fluttertoast.showToast(
              msg: string.loginSuccess,
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
            // Navigate to login or home
            // Navigator.pushReplacementNamed(context, '/login');
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            }
          }

          if (state is RegistrationError) {
            Navigator.of(context).pop();
            final msg = string.getErrorMessage(
              state.errorKey,
              fallback: state.fallbackMessage,
            );

            Fluttertoast.showToast(
              msg: msg,
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: ValueListenableBuilder<AutovalidateMode>(
                      valueListenable: autoValidateNotifier,
                      builder: (context, autoValidateMode, _) {
                        return Form(
                          key: _formKey,
                          autovalidateMode: autoValidateMode,
                          child: Column(
                            children: [
                              Text(
                                string.createYourAccount,
                                style: theme.textTheme.titleLarge,
                              ),
                              SizedBox(height: 24.h),

                              // Image Picker
                              AppImagePicker(
                                onImageSelected: (img) =>
                                    imageNotifier.value = img,
                              ),
                              SizedBox(height: 24.h),

                              // First Name & Last Name
                              RegisterTwoFieldsRow(
                                leftField: RegisterTextField(
                                  controller: firstNameController,
                                  labelText: string.firstName,
                                  validator: (v) => Validators.validateName(
                                    context: context,
                                    value: v,
                                    fieldName: string.firstName.toLowerCase(),
                                  ),
                                ),
                                rightField: RegisterTextField(
                                  controller: lastNameController,
                                  labelText: string.lastName,
                                  validator: (v) => Validators.validateName(
                                    context: context,
                                    value: v,
                                    fieldName: string.lastName.toLowerCase(),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Email
                              RegisterTextField(
                                controller: emailController,
                                labelText: string.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) => Validators.validateEmail(
                                  context: context,
                                  value: v,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Password
                              RegisterTextField(
                                controller: passwordController,
                                labelText: string.password,
                                isPassword: true,
                                validator: (v) => Validators.validatePassword(
                                  context: context,
                                  value: v,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Confirm Password
                              RegisterTextField(
                                controller: confirmPasswordController,
                                labelText: string.confirmPassword,
                                isConformPassword: true,
                                validator: (v) =>
                                    Validators.validateConfirmPassword(
                                      context: context,
                                      value: v,
                                      password: passwordController.text,
                                    ),
                              ),

                              SizedBox(height: 16.h),

                              // Gender Dropdown
                              ValueListenableBuilder<String?>(
                                valueListenable: genderNotifier,
                                builder: (context, gender, _) {
                                  return AppDropdownOverlay(
                                    labelText: string.gender,
                                    value: gender,
                                    options: RegisterLists.genderOptions(
                                      string,
                                    ),
                                    onChanged: (val) =>
                                        genderNotifier.value = val,
                                    validator: (v) =>
                                        Validators.validateDropdown(
                                          context: context,
                                          value: v,
                                          fieldName: string.gender
                                              .toLowerCase(),
                                        ),
                                  );
                                },
                              ),

                              SizedBox(height: 16.h),

                              // Location Dropdown
                              ValueListenableBuilder<String?>(
                                valueListenable: locationNotifier,
                                builder: (context, location, _) {
                                  return AppDropdownOverlay(
                                    labelText: string.location,
                                    value: location,
                                    options: RegisterLists.locationOptions(
                                      string,
                                    ),
                                    onChanged: (val) =>
                                        locationNotifier.value = val,
                                    validator: (v) =>
                                        Validators.validateDropdown(
                                          context: context,
                                          value: v,
                                          fieldName: string.location
                                              .toLowerCase(),
                                        ),
                                  );
                                },
                              ),

                              SizedBox(height: 24.h),

                              // Register Button
                              CustomElevatedButton(
                                text: string.register,
                                onPressed: () => _onRegister(context, string),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
