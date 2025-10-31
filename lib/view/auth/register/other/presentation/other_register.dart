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

class OthersRegisterScreen extends StatefulWidget {
  const OthersRegisterScreen({super.key});

  @override
  State<OthersRegisterScreen> createState() => _OthersRegisterScreenState();
}

class _OthersRegisterScreenState extends State<OthersRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? gender;
  String? location;
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

              // First & Last Name
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

              // Location
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
              SizedBox(height: 30.h),

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
