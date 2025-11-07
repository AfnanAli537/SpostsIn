import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/data_sources/register_lists.dart';
import 'package:sports_in/data/models/institute_dto.dart';
import 'package:sports_in/generated/l10n.dart';
// import 'package:sports_in/view/auth/presentation/register/widgets/error_message.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

class InstituteRegisterScreen extends StatefulWidget {
  const InstituteRegisterScreen({super.key});

  @override
  State<InstituteRegisterScreen> createState() =>
      _InstituteRegisterScreenState();
}

class _InstituteRegisterScreenState extends State<InstituteRegisterScreen> {
  late S string;
    bool _showValidationErrors = false; // ✅ Controls when to show field errors

  final instituteNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final industryController = TextEditingController();
  String? location;
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
 if (location == null) {
      debugPrint("Validation failed: Required dropdowns are empty.");
      return; 
  }
    // Create UserModel with all collected data
    final userData = InstituteDto(
      instituteName: instituteNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      location: location!,
      industry: industryController.text.trim(),
      // image: selectedImage,
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
    instituteNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    industryController.dispose();
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
                
                    // Institute Name
                    RegisterTextField(
                      controller: instituteNameController,
                      labelText: string.instituteName,
                      showError: _showValidationErrors,
                      validator: (v) => Validators.validateName(
                          context,
                          v,
                          fieldName: string.instituteName.toLowerCase(),
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
                
                    // Location
                    AppDropdownOverlay(
                      labelText: string.location,
                      value: location,
                      options: RegisterLists.locationOptions(string),
                      onChanged: (val) => setState(() => location = val),
                      showError: _showValidationErrors,
                       validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.location.toLowerCase(),
                      ),

                    ),
                    SizedBox(height: 16.h),
                
                    // Industry
                    RegisterTextField(
                      controller: industryController,
                      labelText: string.industary,
                      validator: (v) => Validators.validateName(
                          context,
                          v,
                          fieldName: string.industary.toLowerCase(),
                        ),
                      showError: _showValidationErrors,

                    ),
                    SizedBox(height: 20.h),
                    // if (validationError != null)
                    //   RegisterErrorMessage(message: validationError),
                      
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
