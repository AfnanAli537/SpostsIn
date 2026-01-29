import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/localization_helper.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/models/club_response_model.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/DatePickerTextField.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/checkbox_dropdown_overlay.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/register/view_model/register_bloc/register_bloc.dart';


class ClubRegisterScreen extends StatelessWidget {
  ClubRegisterScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final clubNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final foundDateController = TextEditingController();

  final locationNotifier = ValueNotifier<String?>(null);
  final selectedSportsNotifier = ValueNotifier<List<String>>([]);
  final imageNotifier = ValueNotifier<File?>(null);
  
  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(AutovalidateMode.disabled);

  void _onRegister(BuildContext context, S string) {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (locationNotifier.value == null) {
      return;
    }

    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    final userData = ClubModel(
      clubName: clubNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      location: locationNotifier.value!,
      foundationDate: foundDateController.text,
      sportTypes: selectedSportsNotifier.value,
    );

    context.read<RegistrationBloc>().add(
      SubmitRegistrationEvent(
        userData: userData,
      ),
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
          // Navigate to OTP screen after OTP is sent
          if (state is RegistrationOtpSent) {
            Fluttertoast.showToast(
              msg: string.otpSentSuccessfully,
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );

            // Navigate to OTP verification screen
            Navigator.pushNamed(
              context,
              AppRoutes.registrationOtp,
              arguments: {
                'email': state.email,
                'userData': state.userData,
              },
            );
          }

          if (state is RegistrationError) {
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
                                onImageSelected: (img) => imageNotifier.value = img,
                              ),
                              SizedBox(height: 24.h),

                              RegisterTextField(
                                controller: clubNameController,
                                labelText: string.clubName,
                                validator: (v) => Validators.validateName(
                                  context: context,
                                  value: v,
                                  fieldName: string.clubName.toLowerCase(),
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
                                validator: (v) => Validators.validateConfirmPassword(
                                  context: context,
                                  value: v,
                                  password: passwordController.text,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              ValueListenableBuilder<String?>(
                                valueListenable: locationNotifier,
                                builder: (context, location, _) {
                                  return AppDropdownOverlay(
                                    labelText: string.location,
                                    value: location,
                                    options: RegisterLists.locationOptions(string),
                                    onChanged: (val) => locationNotifier.value = val,
                                    validator: (v) => Validators.validateDropdown(
                                      context: context,
                                      value: v,
                                      fieldName: string.location.toLowerCase(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16.h),

                              DatePickerTextField(
                                controller: foundDateController,
                                labelText: string.foundDate,
                                validator: (v) => Validators.validateDate(
                                  context: context,
                                  value: v,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              ValueListenableBuilder<List<String>>(
                                valueListenable: selectedSportsNotifier,
                                builder: (context, selectedSports, _) {
                                  return CheckboxDropdownOverlay(
                                    labelText: string.selectSports,
                                    value: selectedSports,
                                    options: RegisterLists.sportNameOptions(string),
                                    validator: (v) => Validators.validateList(
                                      context: context,
                                      value: v,
                                      fieldName: string.sportProfession,
                                    ),
                                    onChanged: (selected) =>
                                        selectedSportsNotifier.value = selected,
                                  );
                                },
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
