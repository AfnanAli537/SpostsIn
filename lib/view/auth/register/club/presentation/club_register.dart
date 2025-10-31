import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/strings_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/view/auth/register/widgets/DatePickerTextField.dart';
import 'package:sports_in/view/auth/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/view/auth/register/widgets/checkbox_dropdown_overlay.dart';

class ClubRegisterScreen extends StatefulWidget {
  const ClubRegisterScreen({super.key});

  @override
  State<ClubRegisterScreen> createState() => _ClubRegisterScreenState();
}

class _ClubRegisterScreenState extends State<ClubRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final clubNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final foundDateController = TextEditingController();

  String? location;
  List<String>? selectedSports;
  File? selectedImage;

  // Location options
  List<String> get locationOptions => [
        StringsManager.algeria(context),
        StringsManager.egypt(context),
        StringsManager.morocco(context),
        StringsManager.tunisia(context),
        StringsManager.sudan(context),
      ];

  // Sports options
  List<String> get sportProfessionOptions => [
        StringsManager.football(context),
        StringsManager.basketball(context),
        StringsManager.tennis(context),
        StringsManager.swimming(context),
      ];

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringsManager.registeredSuccessfully(context)),
        ),
      );
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title
              Text(
                StringsManager.createYourAccount(context),
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 24.h),

              // Club Image Picker
              AppImagePicker(onImageSelected: (img) => selectedImage = img),
              SizedBox(height: 24.h),

              // Club Name
              RegisterTextField(
                controller: clubNameController,
                labelText: StringsManager.clubName(context),
                validator: (v) => Validators.validateName(
                  context,
                  v,
                  fieldName: StringsManager.clubName(context).toLowerCase(),
                ),
              ),
              SizedBox(height: 16.h),

              // Email
              RegisterTextField(
                controller: emailController,
                labelText: StringsManager.email(context),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => Validators.validateEmail(context, v),
              ),
              SizedBox(height: 16.h),

              // Password
              RegisterTextField(
                controller: passwordController,
                labelText: StringsManager.password(context),
                isPassword: true,
                validator: (v) => Validators.validatePassword(context, v),
              ),
              SizedBox(height: 16.h),

              // Confirm Password
              RegisterTextField(
                controller: confirmPasswordController,
                labelText: StringsManager.confirmPassword(context),
                isConformPassword: true,
                validator: (v) => Validators.validateConfirmPassword(
                  context,
                  v,
                  passwordController.text,
                ),
              ),
              SizedBox(height: 16.h),

              // Location Dropdown
              AppDropdownOverlay(
                labelText: StringsManager.location(context),
                value: location,
                options: locationOptions,
                onChanged: (val) => setState(() => location = val),
                validator: (v) => Validators.validateDropdown(
                  context,
                  v,
                  fieldName: StringsManager.location(context).toLowerCase(),
                ),
              ),
              SizedBox(height: 16.h),

              // Foundation Date Picker
              DatePickerTextField(
                controller: foundDateController,
                labelText: StringsManager.foundDate(context),
                validator: (v) => Validators.validateDate(context, v),
              ),
              SizedBox(height: 16.h),

              // Sports Selection (Checkbox Dropdown)
              CheckboxDropdownOverlay(
                labelText: StringsManager.selectSports(context),
                options: sportProfessionOptions,
                onChanged: (selected) =>
                    setState(() => selectedSports = selected),
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return StringsManager.selectAtLeastOne(context);
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h),

              // Register Button
              CustomElevatedButton(
                text: StringsManager.register(context),
                onPressed: _onRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
