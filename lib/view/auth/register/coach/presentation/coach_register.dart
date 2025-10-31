import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/constants/strings_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/view/auth/register/widgets/register_text_field.dart';
import 'package:sports_in/view/auth/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/register/widgets/radio_dropdown_overlay.dart';

class CoachRegisterScreen extends StatefulWidget {
  const CoachRegisterScreen({super.key});

  @override
  State<CoachRegisterScreen> createState() => _CoachRegisterScreenState();
}

class _CoachRegisterScreenState extends State<CoachRegisterScreen> {
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

  List<String> get genderOptions => [
        StringsManager.male(context),
        StringsManager.female(context),
      ];

  List<String> get locationOptions => [
        StringsManager.algeria(context),
        StringsManager.egypt(context),
        StringsManager.morocco(context),
        StringsManager.tunisia(context),
        StringsManager.sudan(context),
      ];

  List<String> get yearsOfExperienceOptions => [
        StringsManager.yearsOfExperience0to2(context),
        StringsManager.yearsOfExperience3to5(context),
        StringsManager.yearsOfExperience5to10(context),
        StringsManager.yearsOfExperience10Plus(context),
      ];

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

              // First & Last name
              RegisterTwoFieldsRow(
                leftField: RegisterTextField(
                  controller: firstNameController,
                  labelText: StringsManager.firstName(context),
                  validator: (v) => Validators.validateName(
                    context,
                    v,
                    fieldName:
                        StringsManager.firstName(context).toLowerCase(),
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

              // Confirm password
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

              // Sport + Location
              RegisterTwoFieldsRow(
                leftField: AppDropdownOverlay(
                  labelText: StringsManager.specializedSport(context),
                  value: sportName,
                  options: sportNameOptions,
                  onChanged: (val) => setState(() => sportName = val),
                  validator: (v) => Validators.validateDropdown(
                    context,
                    v,
                    fieldName:
                        StringsManager.specializedSport(context).toLowerCase(),
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

              // Experience
              AppDropdownOverlay(
                labelText: StringsManager.yearsOfExperience(context),
                value: yearsOfExperience,
                options: yearsOfExperienceOptions,
                onChanged: (val) => setState(() => yearsOfExperience = val),
                validator: (v) => Validators.validateDropdown(
                  context,
                  v,
                  fieldName:
                      StringsManager.yearsOfExperience(context).toLowerCase(),
                ),
              ),

              SizedBox(height: 24.h),

              // Currently in club checkbox
              Row(
                children: [
                  Checkbox(
                    value: hasClub,
                    activeColor: ColorManager.darkAccent1,
                    onChanged: (value) => setState(() => hasClub = value!),
                  ),
                  Text(
                    StringsManager.currentlyInClub(context),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),

              SizedBox(height: 30.h),

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
