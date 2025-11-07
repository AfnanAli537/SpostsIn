import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/data_sources/register_lists.dart';
import 'package:sports_in/data/models/club_dto.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/DatePickerTextField.dart';
// import 'package:sports_in/view/auth/presentation/register/widgets/error_message.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/checkbox_dropdown_overlay.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/view_model/auth/register_bloc/register_bloc.dart';

class ClubRegisterScreen extends StatefulWidget {
  const ClubRegisterScreen({super.key});

  @override
  State<ClubRegisterScreen> createState() => _ClubRegisterScreenState();
}

class _ClubRegisterScreenState extends State<ClubRegisterScreen> {
  late S string;
    bool _showValidationErrors = false; // ✅ Controls when to show field errors

  final clubNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final foundDateController = TextEditingController();

  String? location;
  List<String>? selectedSports;
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
    final userData = ClubDto(
      clubName: clubNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      location: location!,
      foundationDate: foundDateController.text,
      sportTypes: selectedSports!,
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
    clubNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    foundDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) async {
          if (state is RegistrationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(string.registeredSuccessfully),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ),
            );

            await Future.delayed(const Duration(seconds: 1));

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

                    AppImagePicker(
                      onImageSelected: (img) => selectedImage = img,
                    ),
                    SizedBox(height: 24.h),

                    RegisterTextField(
                      controller: clubNameController,
                      labelText: string.clubName,
                      validator: (v) => Validators.validateName(
                          context,
                          v,
                          fieldName: string.clubName.toLowerCase(),
                        ),
                      showError: _showValidationErrors,
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

                    DatePickerTextField(
                      controller: foundDateController,
                      labelText: string.foundDate,
                       validator: (v) => Validators.validateDate(
                        context,
                        v,
                      ),
                      showError: _showValidationErrors,
                    ),
                    SizedBox(height: 16.h),

                    CheckboxDropdownOverlay(
                      labelText: string.selectSports,
                      value: selectedSports ?? [],
                      options: RegisterLists.sportNameOptions(string),
                      validator: (v) => Validators.validateList(
                        context,
                        v,
                        fieldName: string.sportProfession,
                      ),
                      onChanged: (selected) =>
                          setState(() => selectedSports = selected),
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
