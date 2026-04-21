import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/helper/errors_key_translator.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/data/models/certification_model.dart';
import 'package:sports_in/features/register/data/models/coach_response_model.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/checkbox_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/features/register/view_model/register_bloc/register_bloc.dart';

class CoachRegisterScreen extends StatefulWidget {
  const CoachRegisterScreen({super.key});

  @override
  State<CoachRegisterScreen> createState() => _CoachRegisterScreenState();
}

class _CoachRegisterScreenState extends State<CoachRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  final ageController = TextEditingController();
  final specialistController = TextEditingController();
  final clubNameController = TextEditingController();

  final sportNameNotifier = ValueNotifier<String?>(null);
  final locationNotifier = ValueNotifier<String?>(null);
  final genderNotifier = ValueNotifier<String?>(null);
  final hasClubNotifier = ValueNotifier<bool>(false);
  final imageNotifier = ValueNotifier<File?>(null);

  final selectedCertificationNamesNotifier = ValueNotifier<List<String>>([]);
  final selectedCertificationIdsNotifier = ValueNotifier<List<int>>([]);
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
    final userData = CoachModel(
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
      hasClub: hasClubNotifier.value,
      currentClubName: hasClubNotifier.value
          ? clubNameController.text.trim()
          : "",
      specialist: specialistController.text.trim().isEmpty
          ? ""
          : specialistController.text.trim(),
      certificationsIds: selectedCertificationIdsNotifier.value.isEmpty
          ? []
          : List<int>.from(selectedCertificationIdsNotifier.value),
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
  void initState() {
    super.initState();
    context.read<RegistrationBloc>().add(LoadCertificationsEvent());
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
          final certifications = state is RegistrationCertificationsLoaded
              ? state.certifications
              : <CertificationModel>[];

          final certificationNames = certifications.map((c) => c.name).toList();

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
                                onChanged: (val) => genderNotifier.value = val,
                                validator: (v) => Validators.validateDropdown(
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
                                  options: RegisterLists.sportNameOptions(
                                    string,
                                  ),
                                  onChanged: (val) =>
                                      sportNameNotifier.value = val,
                                  validator: (v) => Validators.validateDropdown(
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
                                  options: RegisterLists.locationOptions(
                                    string,
                                  ),
                                  onChanged: (val) =>
                                      locationNotifier.value = val,
                                  validator: (v) => Validators.validateDropdown(
                                    context: context,
                                    value: v,
                                    fieldName: string.location.toLowerCase(),
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
                          SizedBox(height: 16.h),
                          // Specialist (free text)
                          RegisterTextField(
                            controller: specialistController,
                            labelText: string.specialist,
                          ),
                          SizedBox(height: 16.h),

                          // Certifications multi-select using CheckboxDropdownOverlay
                          ValueListenableBuilder<List<String>>(
                            valueListenable: selectedCertificationNamesNotifier,
                            builder: (context, selectedNames, _) {
                              return CheckboxDropdownOverlay(
                                labelText: string.certifications,
                                value: selectedNames,
                                options: certificationNames,
                                onChanged: (updatedNames) {
                                  selectedCertificationNamesNotifier.value =
                                      updatedNames;

                                  // Map names back to IDs
                                  final updatedIds = updatedNames
                                      .map((name) {
                                        final cert = certifications.firstWhere(
                                          (c) => c.name == name,
                                          orElse: () => CertificationModel(
                                            id: 0,
                                            name: '',
                                          ),
                                        );
                                        return cert.id;
                                      })
                                      .where((id) => id != 0)
                                      .toList();

                                  selectedCertificationIdsNotifier.value =
                                      updatedIds;
                                },
                                // validator: (v) => v?.isEmpty ?? true
                                //     ? string.certifications
                                //     : null,
                              );
                            },
                          ),
                          SizedBox(height: 24.h),

                          // "Currently in a club" checkbox + conditional club name
                          ValueListenableBuilder<bool>(
                            valueListenable: hasClubNotifier,
                            builder: (context, hasClub, _) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: hasClub,
                                        activeColor: ColorManager.darkAccent1,
                                        onChanged: (value) {
                                          hasClubNotifier.value =
                                              value ?? false;
                                          if (!(value ?? false)) {
                                            clubNameController.clear();
                                          }
                                        },
                                      ),
                                      Text(
                                        string.currentlyInClub,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  if (hasClub) ...[
                                    SizedBox(height: 8.h),
                                    RegisterTextField(
                                      controller: clubNameController,
                                      labelText: string.clubName,
                                      validator: (v) => Validators.validateName(
                                        context: context,
                                        value: v,
                                        fieldName: string.clubName
                                            .toLowerCase(),
                                      ),
                                    ),
                                  ],
                                ],
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
