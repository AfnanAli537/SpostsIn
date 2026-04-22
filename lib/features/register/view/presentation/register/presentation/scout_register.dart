import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/data/models/scout_response_model.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/register/view_model/register_bloc/register_bloc.dart';

class ScoutRegisterScreen extends StatelessWidget {
  ScoutRegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  final ageController = TextEditingController();

  final sportNameNotifier = ValueNotifier<String?>(null);
  final locationNotifier = ValueNotifier<String?>(null);
  final genderNotifier = ValueNotifier<String?>(null);
  final imageNotifier = ValueNotifier<File?>(null);

  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(
    AutovalidateMode.disabled,
  );

  void _onRegister(BuildContext context, S string) {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;

    if (!_formKey.currentState!.validate()) return;

    if (genderNotifier.value == null ||
        locationNotifier.value == null ||
        sportNameNotifier.value == null) {
      return;
    }

    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    final userData = ScoutModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      gender: genderNotifier.value!,
      location: locationNotifier.value!,
      sportName: sportNameNotifier.value!,
      yearsOfExperience: int.tryParse(yearsOfExperienceController.text.trim()),
      age: int.tryParse(ageController.text.trim()),
      image: imageNotifier.value,
    );

    context.read<RegistrationBloc>().add(
          SubmitRegistrationEvent(userData: userData),
        );
  }

  Future<void> _showError(BuildContext context, String message) async {
    final msg = await TranslateErrorHelper.translateErrorKeyAsync(
      context,
      message,
    );
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
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
          if (state is RegistrationOtpSent) {
            Fluttertoast.showToast(
              msg: string.otpSentSuccessfully,
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
            Navigator.pushNamed(
              context,
              AppRoutes.registrationOtp,
              arguments: {'email': state.email, 'userData': state.userData},
            );
          }
          if (state is RegistrationError) {
            _showError(context, state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
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

                          AppImagePicker(
                            onImageSelected: (img) =>
                                imageNotifier.value = img,
                          ),
                          SizedBox(height: 24.h),

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

                          ValueListenableBuilder<String?>(
                            valueListenable: genderNotifier,
                            builder: (context, gender, _) {
                              return AppDropdownOverlay(
                                labelText: string.gender,
                                value: gender,
                                options: RegisterLists.genderOptions(string),
                                onChanged: (val) =>
                                    genderNotifier.value = val,
                                validator: (v) =>
                                    Validators.validateDropdown(
                                  context: context,
                                  value: v,
                                  fieldName: string.gender.toLowerCase(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16.h),

                          RegisterTextField(
                            controller: ageController,
                            labelText: string.age,
                            keyboardType: TextInputType.number,
                            validator: (v) => Validators.validateAge(
                              context: context,
                              value: v,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          RegisterTwoFieldsRow(
                            leftField: ValueListenableBuilder<String?>(
                              valueListenable: sportNameNotifier,
                              builder: (context, sportName, _) {
                                return AppDropdownOverlay(
                                  labelText: string.specializedSport,
                                  value: sportName,
                                  options:
                                      RegisterLists.sportNameOptions(string),
                                  onChanged: (val) =>
                                      sportNameNotifier.value = val,
                                  validator: (v) =>
                                      Validators.validateDropdown(
                                    context: context,
                                    value: v,
                                    fieldName: string.specializedSport,
                                  ),
                                );
                              },
                            ),
                            rightField: ValueListenableBuilder<String?>(
                              valueListenable: locationNotifier,
                              builder: (context, location, _) {
                                return AppDropdownOverlay(
                                  labelText: string.location,
                                  value: location,
                                  options:
                                      RegisterLists.locationOptions(string),
                                  onChanged: (val) =>
                                      locationNotifier.value = val,
                                  validator: (v) =>
                                      Validators.validateDropdown(
                                    context: context,
                                    value: v,
                                    fieldName:
                                        string.location.toLowerCase(),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16.h),

                          RegisterTextField(
                            controller: yearsOfExperienceController,
                            labelText: string.yearsOfExperience,
                            keyboardType: TextInputType.number,
                            validator: (v) => Validators.validateExperience(
                              context: context,
                              value: v,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          CustomElevatedButton(
                            text: state is RegistrationLoading
                                ? string.loading
                                : string.create,
                            isLoading: state is RegistrationLoading,
                            enabled: true,
                            onPressed: () => _onRegister(context, string),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}