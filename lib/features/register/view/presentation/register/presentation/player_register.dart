import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/helper/localization_helper.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/models/player_response_model.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/register/view_model/register_bloc/register_bloc.dart';

class PlayerRegisterScreen extends StatelessWidget {
  PlayerRegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  final genderNotifier = ValueNotifier<String?>(null);
  final locationNotifier = ValueNotifier<String?>(null);
  final sportNotifier = ValueNotifier<String?>(null);
  final positionNotifier = ValueNotifier<String?>(null);
  final hasClubNotifier = ValueNotifier<bool>(false);
  final imageNotifier = ValueNotifier<File?>(null);

  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(
    AutovalidateMode.disabled,
  );

  void _onSportChanged(String? selectedSport, S string) {
    sportNotifier.value = selectedSport;
    if (!RegisterLists.isTeamSport(string, selectedSport)) {
      positionNotifier.value = null;
    }
  }

  void _onRegister(BuildContext context, S string) {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (genderNotifier.value == null ||
        locationNotifier.value == null ||
        sportNotifier.value == null) {
      return;
    }

    if (positionNotifier.value == null &&
        RegisterLists.sportHasPositions(sportNotifier.value)) {
      return;
    }

    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    final int? parsedHeight = int.tryParse(heightController.text.trim());
    final int? parsedWeight = int.tryParse(weightController.text.trim());
    final int? parsedAge = int.tryParse(ageController.text.trim());

    final player = PlayerModel(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      height: parsedHeight,
      weight: parsedWeight,
      age: parsedAge,
      gender: genderNotifier.value!,
      location: locationNotifier.value!,
      sportName: sportNotifier.value!,
      position: positionNotifier.value,
      hasClub: hasClubNotifier.value,
      image: imageNotifier.value,
    );

    context.read<RegistrationBloc>().add(
      SubmitRegistrationEvent(userData: player),
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
              arguments: {'email': state.email, 'userData': state.userData},
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
          
                          RegisterTwoFieldsRow(
                            leftField: RegisterTextField(
                              controller: heightController,
                              labelText: string.height,
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.validateHeight(
                                context: context,
                                value: v,
                              ),
                            ),
                            rightField: RegisterTextField(
                              controller: weightController,
                              labelText: string.weight,
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.validateWeight(
                                context: context,
                                value: v,
                              ),
                            ),
                          ),
          
                          SizedBox(height: 16.h),
          
                          RegisterTwoFieldsRow(
                            leftField: ValueListenableBuilder<String?>(
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
                            rightField: RegisterTextField(
                              controller: ageController,
                              labelText: string.age,
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.validateAge(
                                context: context,
                                value: v,
                              ),
                            ),
                          ),
          
                          SizedBox(height: 16.h),
          
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
          
                          SizedBox(height: 16.h),
          
                          ValueListenableBuilder<String?>(
                            valueListenable: sportNotifier,
                            builder: (context, sport, _) {
                              return AppDropdownOverlay(
                                labelText: string.sportProfession,
                                value: sport,
                                options:
                                    RegisterLists.sportProfessionOptions(
                                      string,
                                    ),
                                onChanged: (val) =>
                                    _onSportChanged(val, string),
                                validator: (v) =>
                                    Validators.validateDropdown(
                                      context: context,
                                      value: v,
                                      fieldName: string.sportProfession
                                          .toLowerCase(),
                                    ),
                              );
                            },
                          ),
          
                          SizedBox(height: 16.h),
          
                          ValueListenableBuilder<String?>(
                            valueListenable: sportNotifier,
                            builder: (context, sport, _) {
                              if (!RegisterLists.isTeamSport(
                                string,
                                sport,
                              )) {
                                return const SizedBox.shrink();
                              }
                              return ValueListenableBuilder<String?>(
                                valueListenable: positionNotifier,
                                builder: (context, position, _) {
                                  return AppDropdownOverlay(
                                    labelText: string.position,
                                    value: position,
                                    options: RegisterLists.positionOptions(
                                      string,
                                      sport,
                                    ),
                                    onChanged: (val) =>
                                        positionNotifier.value = val,
                                    validator: (v) =>
                                        Validators.validateDropdown(
                                          context: context,
                                          value: v,
                                          fieldName: string.position
                                              .toLowerCase(),
                                        ),
                                  );
                                },
                              );
                            },
                          ),
          
                          ValueListenableBuilder<String?>(
                            valueListenable: sportNotifier,
                            builder: (context, sport, _) {
                              if (!RegisterLists.isTeamSport(
                                string,
                                sport,
                              )) {
                                return const SizedBox.shrink();
                              }
                              return SizedBox(height: 20.h);
                            },
                          ),
          
                          ValueListenableBuilder<bool>(
                            valueListenable: hasClubNotifier,
                            builder: (context, hasClub, _) {
                              return Row(
                                children: [
                                  Checkbox(
                                    value: hasClub,
                                    activeColor: ColorManager.darkAccent1,
                                    onChanged: (value) =>
                                        hasClubNotifier.value =
                                            value ?? false,
                                  ),
                                  Text(string.currentlyInClub),
                                ],
                              );
                            },
                          ),
          
                          SizedBox(height: 12.h),
          
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
