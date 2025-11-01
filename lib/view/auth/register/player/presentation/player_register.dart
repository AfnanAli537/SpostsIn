import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/view/auth/register/widgets/error_message.dart';
import 'package:sports_in/view/auth/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/register/widgets/radio_dropdown_overlay.dart';
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

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // Dropdown values
  String? gender;
  String? location;
  String? sportPosition;
  String? position;
  bool hasClub = false;
  File? selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    string = S.of(context);
  }

  // Gender options list
  List<String> get genderOptions => [string.male, string.female];

  // Location options list
  List<String> get locationOptions => [
    string.algeria,
    string.egypt,
    string.morocco,
    string.tunisia,
    string.sudan,
  ];

  // Sport Profession options list
  List<String> get sportProfessionOptions => [
    string.football,
    string.basketball,
    string.tennis,
    string.swimming,
  ];

  // Position options list
  List<String> get positionOptions => [
    string.goalkeeper,
    string.defender,
    string.midfielder,
    string.forward,
  ];

  void _onRegister() {
    // Reset any previous validation errors
    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    // Create UserModel with all collected data
    final userData = UserModel(
      userType: UserType.player,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      gender: gender,
      location: location,
      sport: sportPosition,
      position: position,
      height: heightController.text.trim(),
      weight: weightController.text.trim(),
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
            // Navigate to next screen or pop
            // Navigator.pushReplacementNamed(context, '/home');
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

                    AppImagePicker(
                      onImageSelected: (img) => selectedImage = img,
                    ),
                    SizedBox(height: 24.h),

                    // First Name & Last Name
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

                    // Confirm Password
                    RegisterTextField(
                      controller: confirmPasswordController,
                      labelText: string.confirmPassword,
                      isConformPassword: true,
                    ),
                    SizedBox(height: 16.h),
                    // Height & Weight
                    RegisterTwoFieldsRow(
                      leftField: RegisterTextField(
                        controller: heightController,
                        labelText: string.height,
                        keyboardType: TextInputType.number,
                      ),
                      rightField: RegisterTextField(
                        controller: weightController,
                        labelText: string.weight,
                        keyboardType: TextInputType.number,
                      ),
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

                    // Location
                    AppDropdownOverlay(
                      labelText: string.location,
                      value: location,
                      options: locationOptions,
                      onChanged: (val) => setState(() => location = val),
                    ),

                    SizedBox(height: 16.h),

                    // Sport Profession & Position
                    RegisterTwoFieldsRow(
                      leftField: AppDropdownOverlay(
                        labelText: string.sportProfession,
                        value: sportPosition,
                        options: sportProfessionOptions,
                        onChanged: (val) => setState(() => sportPosition = val),
                      ),
                      rightField: AppDropdownOverlay(
                        labelText: string.position,
                        value: position,
                        options: positionOptions,
                        onChanged: (val) => setState(() => position = val),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Has Club Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: hasClub,
                          activeColor: ColorManager.darkAccent1,
                          onChanged: (value) =>
                              setState(() => hasClub = value!),
                        ),
                        Text(
                          string.currentlyInClub,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    if (validationError != null)
                      RegisterErrorMessage(message: validationError),

                    // Register Button
                    CustomElevatedButton(
                      text: string.register,
                      onPressed: isLoading ? null : _onRegister,
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
