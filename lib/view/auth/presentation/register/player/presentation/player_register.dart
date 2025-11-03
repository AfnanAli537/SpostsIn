import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/validators/auth_validator.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/data/models/user_model.dart';
import 'package:sports_in/view/auth/presentation/register/widgets/error_message.dart';
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
  bool _showValidationErrors = false; // ✅ Controls when to show field errors

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
    string.volleyball,
    string.handball,
  ];

  // Dynamic position options based on selected sport
  List<String> get positionOptions {
    if (sportPosition == null) return [];

    if (sportPosition == string.football) {
      return [
        string.goalkeeper,
        string.defender,
        string.midfielder,
        string.forward,
      ];
    } else if (sportPosition == string.basketball) {
      return [
        string.pointGuard,
        string.shootingGuard,
        string.smallForward,
        string.powerForward,
        string.center,
      ];
    } else if (sportPosition == string.volleyball) {
      return [
        string.setter,
        string.outsideHitter,
        string.oppositeHitter,
        string.middleBlocker,
        string.libero,
      ];
    } else if (sportPosition == string.handball) {
      return [
        string.goalkeeper,
        string.leftWing,
        string.rightWing,
        string.leftBack,
        string.centerBack,
        string.rightBack,
        string.pivot,
      ];
    } 

    return [];
  }

  void _onSportChanged(String? selectedSport) {
    setState(() {
      sportPosition = selectedSport;
      // ✅ Reset position when sport changes
      position = null;
    });
  }

  void _onRegister() {
    // ✅ Enable field-level validation
    setState(() {
      _showValidationErrors = true;
    });

    // Reset any previous BLoC validation errors
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

                    // Sport Profession
                    AppDropdownOverlay(
                      labelText: string.sportProfession,
                      value: sportPosition,
                      options: sportProfessionOptions,
                      onChanged: _onSportChanged,
                      validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.sportProfession,
                      ),
                      showError: _showValidationErrors,
                    ),

                    SizedBox(height: 16.h),

                    // Position (dynamically changes based on sport)
                    // ✅ Disabled until sport is selected
                    AppDropdownOverlay(
                      labelText: string.position,
                      value: position,
                      options: positionOptions,
                      onChanged: (val) => setState(() => position = val),
                      validator: (v) => Validators.validateDropdown(
                        context,
                        v,
                        fieldName: string.position.toLowerCase(),
                      ),
                      showError: _showValidationErrors,
                      enabled: sportPosition != null, // ✅ Only enabled if sport selected
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

                    // ✅ BLoC-level error message banner (above button)
                    if (validationError != null)
                      RegisterErrorMessage(message: validationError),

                    // Register Button
                    CustomElevatedButton(
                      text: string.register,
                      onPressed: _onRegister,
                    ),

                    SizedBox(height: 20.h),
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
