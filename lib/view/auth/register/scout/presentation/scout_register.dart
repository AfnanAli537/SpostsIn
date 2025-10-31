import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/strings_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/view/auth/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoutRegisterScreen extends StatefulWidget {
  const ScoutRegisterScreen({super.key});

  @override
  State<ScoutRegisterScreen> createState() => _ScoutRegisterScreenState();
}

class _ScoutRegisterScreenState extends State<ScoutRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
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

  // Gender options list
  List<String> get genderOptions => [
        StringsManager.male(context),
        StringsManager.female(context),
      ];

  // Location options list
  List<String> get locationOptions => [
        StringsManager.algeria(context),
        StringsManager.egypt(context),
        StringsManager.morocco(context),
        StringsManager.tunisia(context),
        StringsManager.sudan(context),
      ];

  // Years of experience options list
  List<String> get yearsOfExperienceOptions => [
        StringsManager.yearsOfExperience0to2(context),
        StringsManager.yearsOfExperience3to5(context),
        StringsManager.yearsOfExperience5to10(context),
        StringsManager.yearsOfExperience10Plus(context),
      ];

  // Sport name options list
  List<String> get sportNameOptions => [
        StringsManager.football(context),
        StringsManager.basketball(context),
        StringsManager.tennis(context),
        StringsManager.swimming(context),
      ];

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(StringsManager.registeredSuccessfully(context))),
      );
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                StringsManager.createYourAccount(context),
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 24.h),

              AppImagePicker(onImageSelected: (img) => selectedImage = img),

              SizedBox(height: 24.h),

              // First Name & Last Name
              RegisterTwoFieldsRow(
                leftField: RegisterTextField(
                  controller: firstNameController,
                  labelText: StringsManager.firstName(context),
                  validator: (v) => Validators.validateName(
                    context,
                    v,
                    fieldName: StringsManager.firstName(context).toLowerCase(),
                  ),
                ),
                rightField: RegisterTextField(
                  controller: lastNameController,
                  labelText: StringsManager.lastName(context),
                  validator: (v) => Validators.validateName(
                    context,
                    v,
                    fieldName: StringsManager.lastName(context).toLowerCase(),
                  ),
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

              // Gender
              AppDropdownOverlay(
                labelText: StringsManager.gender(context),
                value: gender,
                options: genderOptions,
                onChanged: (val) => setState(() => gender = val),
                validator: (v) => Validators.validateDropdown(
                  context,
                  v,
                  fieldName: StringsManager.gender(context).toLowerCase(),
                ),
              ),

              SizedBox(height: 16.h),

              // Sport Name & Location Row
              RegisterTwoFieldsRow(
                leftField: AppDropdownOverlay(
                  labelText: StringsManager.specializedSport(context),
                  value: sportName,
                  options: sportNameOptions,
                  onChanged: (val) => setState(() => sportName = val),
                  validator: (v) => Validators.validateDropdown(
                    context,
                    v,
                    fieldName: 'sport',
                  ),
                ),
                rightField: AppDropdownOverlay(
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
              ),

              SizedBox(height: 16.h),

              // Years of Experience
              AppDropdownOverlay(
                labelText: StringsManager.yearsOfExperience(context),
                value: yearsOfExperience,
                options: yearsOfExperienceOptions,
                onChanged: (val) => setState(() => yearsOfExperience = val),
                validator: (v) => Validators.validateDropdown(
                  context,
                  v,
                  fieldName: StringsManager
                      .yearsOfExperience(context)
                      .toLowerCase(),
                ),
              ),

              SizedBox(height: 30.h),

              // Register Button
              CustomElevatedButton(
                text: StringsManager.create(context),
                onPressed: _onRegister,
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
