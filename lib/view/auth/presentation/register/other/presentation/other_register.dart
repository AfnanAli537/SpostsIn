import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/validators/auth_validator.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/error_message.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

class OthersRegisterScreen extends StatefulWidget {
  const OthersRegisterScreen({super.key});

  @override
  State<OthersRegisterScreen> createState() => _OthersRegisterScreenState();
}

class _OthersRegisterScreenState extends State<OthersRegisterScreen> {
  late S string;
  bool _showValidationErrors = false; // ✅ Controls when to show field errors

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? gender;
  String? location;
  File? selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    string = S.of(context);
  }

  List<String> get genderOptions => [string.male, string.female];

  List<String> get locationOptions => [
    string.algeria,
    string.egypt,
    string.morocco,
    string.tunisia,
    string.sudan,
  ];

  void _onRegister() {
    setState(() {
      _showValidationErrors = true;
    });
    // Reset any previous validation errors
    context.read<RegistrationBloc>().add(const ResetValidationEvent());

    // Create UserModel with all collected data
    final userData = UserModel(
      userType: UserType.others,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      gender: gender,
      location: location,
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
                        showError: _showValidationErrors,
                        validator: (v) => Validators.validateName(
                          context,
                          v,
                          fieldName: string.firstName.toLowerCase(),
                        ),
                      ),
                      rightField: RegisterTextField(
                        controller: lastNameController,
                        labelText: string.lastName,
                        showError: _showValidationErrors,
                        validator: (v) => Validators.validateName(
                          context,
                          v,
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
                      validator: (v) => Validators.validateEmail(context, v),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    // Password
                    RegisterTextField(
                      controller: passwordController,
                      labelText: string.password,
                      isPassword: true,
                      validator: (v) => Validators.validatePassword(context, v),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    // Confirm Password
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

                    // Gender
                    AppDropdownOverlay(
                      labelText: string.gender,
                      value: gender,
                      options: genderOptions,
                      onChanged: (val) => setState(() => gender = val),
                       validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.gender.toLowerCase(),
                      ),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    // Location
                    AppDropdownOverlay(
                      labelText: string.location,
                      value: location,
                      options: locationOptions,
                      onChanged: (val) => setState(() => location = val),
                      validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.location.toLowerCase(),
                      ),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    if (validationError != null)
                      RegisterErrorMessage(message: validationError),

                    // Register Button
                    CustomElevatedButton(
                      text: string.register,
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
