import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/register/widgets/error_message.dart';
import 'package:sports_in/view/auth/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

class ScoutRegisterScreen extends StatefulWidget {
  const ScoutRegisterScreen({super.key});

  @override
  State<ScoutRegisterScreen> createState() => _ScoutRegisterScreenState();
}

class _ScoutRegisterScreenState extends State<ScoutRegisterScreen> {
  late S string;
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
  // Gender options list
  List<String> get genderOptions => [
        string.male,
        string.female,
      ];

  // Location options list
  List<String> get locationOptions => [
        string.algeria,
        string.egypt,
        string.morocco,
        string.tunisia,
        string.sudan,
      ];

  // Years of experience options list
  List<String> get yearsOfExperienceOptions => [
        string.yearsOfExperience0to2,
        string.yearsOfExperience3to5,
        string.yearsOfExperience5to10,
        string.yearsOfExperience10Plus,
      ];

  // Sport name options list
  List<String> get sportNameOptions => [
        string.football,
        string.basketball,
        string.tennis,
        string.swimming,
      ];

 
  void _onRegister() {
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
          final validationError = state is RegistrationValidationError
              ? state.message
              : null;
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
                      ),
                      rightField: RegisterTextField(
                        controller: lastNameController,
                        labelText: string.lastName,
                      ),
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Email
                    RegisterTextField(
                      controller: emailController,
                      labelText: string.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Password
                    RegisterTextField(
                      controller: passwordController,
                      labelText: string.password,
                      isPassword: true,
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Confirm password
                    RegisterTextField(
                      controller: confirmPasswordController,
                      labelText: string.confirmPassword,
                      isConformPassword: true,
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Gender
                    AppDropdownOverlay(
                      labelText: string.gender,
                      value: gender,
                      options: genderOptions,
                      onChanged: (val) => setState(() => gender = val),
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Sport + Location
                    RegisterTwoFieldsRow(
                      leftField: AppDropdownOverlay(
                        labelText: string.specializedSport,
                        value: sportName,
                        options: sportNameOptions,
                        onChanged: (val) => setState(() => sportName = val),
                      ),
                      rightField: AppDropdownOverlay(
                        labelText: string.location,
                        value: location,
                        options: locationOptions,
                        onChanged: (val) => setState(() => location = val),
                      ),
                    ),
                
                    SizedBox(height: 16.h),
                
                    // Experience
                    AppDropdownOverlay(
                      labelText: string.yearsOfExperience,
                      value: yearsOfExperience,
                      options: yearsOfExperienceOptions,
                      onChanged: (val) => setState(() => yearsOfExperience = val),
                    ),
                
                    SizedBox(height: 20.h),
                    if (validationError != null)
                      RegisterErrorMessage(message: validationError),

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
