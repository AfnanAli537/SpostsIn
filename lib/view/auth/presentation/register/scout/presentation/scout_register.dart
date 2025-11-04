import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/validators/auth_validator.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/data_sources/register_lists.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/generated/l10n.dart';
// import 'package:sports_in/view/auth/presentation/register/widgets/error_message.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

class ScoutRegisterScreen extends StatefulWidget {
  const ScoutRegisterScreen({super.key});

  @override
  State<ScoutRegisterScreen> createState() => _ScoutRegisterScreenState();
}

class _ScoutRegisterScreenState extends State<ScoutRegisterScreen> {
  late S string;
  bool _showValidationErrors = false; // ✅ Controls when to show field errors

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  String? sportName;
  String? yearsOfExperience;
  String? location;
  String? gender;
  bool hasClub = false;
  File? selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    string = S.of(context);
  }
 
  void _onRegister() {
    setState(() {
      _showValidationErrors = true;
    });
    // Reset any previous validation errors
    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    // Create UserModel with all collected data
    final userData = UserModel(
      userType: UserType.scout,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      gender: gender,
      location: location,
      specialization: sportName,
      experienceYears: yearsOfExperience,
      hasClub: hasClub,
      image: selectedImage,
    );

    // Dispatch event to BLoC with localizations
    context.read<RegistrationBloc>().add(
      SubmitRegistrationEvent(
        userData: userData,
        localizations: string, // Pass localization object
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
    yearsOfExperienceController.dispose();
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
            if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
          (route) => false,
        );
      }
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
          // final validationError = state is RegistrationValidationError
          //     ? state.message
          //     : null;
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
                
                    AppImagePicker(onImageSelected: (img) => selectedImage = img),
                    SizedBox(height: 24.h),
                
                    // First & Last name
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
                
                    // Email
                    RegisterTextField(
                      controller: emailController,
                      labelText: string.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => Validators.validateEmail(context, v),
                        showError: _showValidationErrors,
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Password
                    RegisterTextField(
                      controller: passwordController,
                      labelText: string.password,
                      validator: (v) => Validators.validatePassword(context, v),
                      isPassword: true,
                        showError: _showValidationErrors,

                    ),
                
                    SizedBox(height: 16.h),
                
                    // Confirm password
                    RegisterTextField(
                      controller: confirmPasswordController,
                      labelText: string.confirmPassword,
                      isConformPassword: true, validator: (v) => Validators.validateConfirmPassword(
                        context,
                        v,
                        passwordController.text,
                      ),
                        showError: _showValidationErrors,

                    ),
                
                    SizedBox(height: 16.h),
                
                    // Gender
                    AppDropdownOverlay(
                      labelText: string.gender,
                      value: gender,
                      options: RegisterLists.genderOptions(string),
                      onChanged: (val) => setState(() => gender = val),
                        showError: _showValidationErrors,validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.gender.toLowerCase(),
                      ),

                    ),
                
                    SizedBox(height: 16.h),
                
                    // Sport + Location
                    RegisterTwoFieldsRow(
                      leftField: AppDropdownOverlay(
                        labelText: string.specializedSport,
                        value: sportName,
                        options: RegisterLists.sportNameOptions(string),
                        onChanged: (val) => setState(() => sportName = val),
                        showError: _showValidationErrors,validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.specializedSport,
                      ),

                      ),
                      rightField: AppDropdownOverlay(
                        labelText: string.location,
                        value: location,
                        options: RegisterLists.locationOptions(string),
                        onChanged: (val) => setState(() => location = val),
                        showError: _showValidationErrors,validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.location.toLowerCase(),
                      ),

                      ),
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Experience
                    AppDropdownOverlay(
                      labelText: string.yearsOfExperience,
                      value: yearsOfExperience,
                      options: RegisterLists.yearsOfExperienceOptions(string),
                      onChanged: (val) => setState(() => yearsOfExperience = val),
                        showError: _showValidationErrors,
                        validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.yearsOfExperience,
                      ),

                    ),
                
                    SizedBox(height: 20.h),
                    // if (validationError != null)
                    //   RegisterErrorMessage(message: validationError),

                    CustomElevatedButton(
                      text: string.create,
                      onPressed: _onRegister,
                    ),
                
                  ],
                ),
              ),
              // Loading overlay
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
