import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/validators/auth_validator.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/data_sources/register_lists.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

class PlayerRegisterScreen extends StatefulWidget {
  const PlayerRegisterScreen({super.key});

  @override
  State<PlayerRegisterScreen> createState() => _PlayerRegisterScreenState();
}

class _PlayerRegisterScreenState extends State<PlayerRegisterScreen> {
  late S string;
  bool _showValidationErrors = false;
  File? selectedImage;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  String? gender;
  String? location;
  String? sport;
  String? position;
  bool hasClub = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    string = S.of(context);
  }

  void _onSportChanged(String? selectedSport) {
    setState(() {
      sport = selectedSport;
      // Clear position if switching to non-team sport
      if (RegisterLists.isTeamSport(string,selectedSport)) {
        position = null;
      }
    });
  }
    void _onRegister() {
    setState(() {
      _showValidationErrors = true;
    });

    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    final user = UserModel(
      userType: UserType.player,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      height: heightController.text,
      weight: weightController.text,
      gender: gender,
      location: location,
      sport: sport,
      position: position,
      image: selectedImage,
    );

    context.read<RegistrationBloc>().add(
          SubmitRegistrationEvent(
            userData: user,
            localizations: string,
          ),
        );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(string.registeredSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (route) => false);
          } else if (state is RegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RegistrationLoading;
          // final validationError =
          //     state is RegistrationValidationError ? state.message : null;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      string.createYourAccount,
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: 24.h),

                    AppImagePicker(
                      onImageSelected: (img) => selectedImage = img,
                    ),
                    SizedBox(height: 24.h),

                    RegisterTwoFieldsRow(
                      leftField: RegisterTextField(
                        controller: firstNameController,
                        labelText: string.firstName,
                        validator: (v) => Validators.validateName(
                          context,
                          v,
                          fieldName: string.firstName.toLowerCase(),
                        ),
                        showError: _showValidationErrors,
                      ),
                      rightField: RegisterTextField(
                        controller: lastNameController,
                        labelText: string.lastName,
                        validator: (v) => Validators.validateName(
                          context,
                          v,
                          fieldName: string.lastName.toLowerCase(),
                        ),
                        showError: _showValidationErrors,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    RegisterTextField(
                      controller: emailController,
                      labelText: string.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => Validators.validateEmail(context, v),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    RegisterTextField(
                      controller: passwordController,
                      labelText: string.password,
                      isPassword: true,
                      validator: (v) => Validators.validatePassword(context, v),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    RegisterTextField(
                      controller: confirmPasswordController,
                      labelText: string.confirmPassword,
                      isConformPassword: true,
                      validator: (v) => Validators.validateConfirmPassword(
                        context,
                        v,
                        passwordController.text,
                      ),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),
                    // Height & Weight
                    RegisterTwoFieldsRow(
                      leftField: RegisterTextField(
                        controller: heightController,
                        labelText: string.height,
                        keyboardType: TextInputType.number,
                        validator: (v) => Validators.validateHeight(context, v),
                        showError: _showValidationErrors,
                      ),
                      rightField: RegisterTextField(
                        controller: weightController,
                        labelText: string.weight,
                        keyboardType: TextInputType.number,
                        validator: (v) => Validators.validateWeight(context, v),
                        showError: _showValidationErrors,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    AppDropdownOverlay(
                      labelText: string.gender,
                      value: gender,
                      options: RegisterLists.genderOptions(string),
                      onChanged: (val) => setState(() => gender = val),
                      validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.gender.toLowerCase(),
                      ),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    AppDropdownOverlay(
                      labelText: string.location,
                      value: location,
                      options: RegisterLists.locationOptions(string),
                      onChanged: (val) => setState(() => location = val),
                      validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.location.toLowerCase(),
                      ),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    AppDropdownOverlay(
                      labelText: string.sportProfession,
                      value: sport,
                      options: RegisterLists.sportProfessionOptions(string),
                      onChanged: _onSportChanged,
                      validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.sportProfession.toLowerCase(),
                      ),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    // Only show position field for team sports
                      if (RegisterLists.isTeamSport(string,sport))
                        AppDropdownOverlay(
                          labelText: string.position,
                          value: position,
                          options: RegisterLists.positionOptions(string, sport),
                          onChanged: (val) => setState(() => position = val),
                          validator: (v) => Validators.validateDropdown(
                            context,
                            v,
                            fieldName: string.position.toLowerCase(),
                          ),
                      showError: _showValidationErrors,

                        ),

                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Checkbox(
                          value: hasClub,
                          activeColor: ColorManager.darkAccent1,
                          onChanged: (value) =>
                              setState(() => hasClub = value ?? false),
                        ),
                        Text(string.currentlyInClub),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    CustomElevatedButton(
                      text: string.register,
                      onPressed: _onRegister,
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),

              if (isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}
