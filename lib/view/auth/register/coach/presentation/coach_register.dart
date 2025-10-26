import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/validators/auth_validator.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/register_text_field.dart';
import 'package:sports_in/core/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/register/widgets/register_button.dart';
import 'package:sports_in/view/user_type/widgets/app_dropdown_overlay.dart';

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

  String? selectedLocation;
  String? selectedSport;
  String? selectedGender;
  bool hasClub = false;
  File? selectedImage;

  final Map<String, String?> _errors = {};

  void _unfocus() => FocusScope.of(context).unfocus();

  void _validateAndSubmit() {
    _unfocus();

    setState(() {
      _errors.clear();

      _errors['firstName'] = ValidationHelper.validateRequired(
        firstNameController.text,
        fieldName: "First name",
      );
      _errors['lastName'] = ValidationHelper.validateRequired(
        lastNameController.text,
        fieldName: "Last name",
      );
      _errors['email'] = ValidationHelper.validateEmail(emailController.text);
      _errors['password'] = ValidationHelper.validatePassword(
        passwordController.text,
      );
      _errors['confirmPassword'] = ValidationHelper.validateConfirmPassword(
        passwordController.text,
        confirmPasswordController.text,
      );
      _errors['yearsOfExperience'] = ValidationHelper.validateRequired(
        yearsOfExperienceController.text,
        fieldName: "Years of experience",
      );

      if (selectedLocation == null) {
        _errors['location'] = "Please select a location";
      }
      if (selectedSport == null) {
        _errors['sport'] = "Please select a sport";
      }
      if (selectedGender == null) {
        _errors['gender'] = "Please select gender";
      }
    });

    if (_errors.values.every((e) => e == null)) {
      // ✅ All inputs are valid — you can handle registration here
      // For example: call API or navigate
      debugPrint('Form is valid. Proceed with registration.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _unfocus,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
            children: [
              const Text(
                "Create your Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // 🖼 Image Picker
              AppImagePicker(onImageSelected: (img) => selectedImage = img),
              const SizedBox(height: 24),

              // 👤 First & Last Name
              RegisterTwoFieldsRow(
                leftField: RegisterTextField(
                  controller: firstNameController,
                  hintText: "First name",
                  errorText: _errors['firstName'],
                ),
                rightField: RegisterTextField(
                  controller: lastNameController,
                  hintText: "Last name",
                  errorText: _errors['lastName'],
                ),
              ),
              const SizedBox(height: 10),

              // 📧 Email
              RegisterTextField(
                controller: emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                errorText: _errors['email'],
              ),
              const SizedBox(height: 10),

              // 🔒 Password
              RegisterTextField(
                controller: passwordController,
                hintText: "Password",
                isPassword: true,
                errorText: _errors['password'],
              ),
              const SizedBox(height: 10),

              // 🔑 Confirm Password
              RegisterTextField(
                controller: confirmPasswordController,
                hintText: "Confirm password",
                isPassword: true,
                errorText: _errors['confirmPassword'],
              ),
              const SizedBox(height: 10),

              // 📊 Years of Experience
              RegisterTextField(
                controller: yearsOfExperienceController,
                hintText: "Years of experience",
                keyboardType: TextInputType.number,
                errorText: _errors['yearsOfExperience'],
              ),
              const SizedBox(height: 10),

              // ⚽ Sport Name
              AppDropdownOverlay(
                hintText: "Sport name",
                options: const [
                  "Football",
                  "Basketball",
                  "Tennis",
                  "Volleyball",
                ],
                value: selectedSport,
                onChanged: (v) {
                  _unfocus();
                  setState(() => selectedSport = v);
                },
                errorText: _errors['sport'],
              ),
              const SizedBox(height: 10),

              // 🌍 Location
              AppDropdownOverlay(
                hintText: "Location",
                options: const [
                  'Egypt',
                  'USA',
                  'Germany',
                  'France',
                  'Brazil',
                  'Japan',
                  'India',
                  'Spain',
                ],
                value: selectedLocation,
                onChanged: (v) {
                  _unfocus();
                  setState(() => selectedLocation = v);
                },
                errorText: _errors['location'],
              ),
              const SizedBox(height: 10),

              // 🚻 Gender
              AppDropdownOverlay(
                hintText: "Gender",
                options: const ["Male", "Female"],
                value: selectedGender,
                onChanged: (v) {
                  _unfocus();
                  setState(() => selectedGender = v);
                },
                errorText: _errors['gender'],
              ),
              const SizedBox(height: 24),

              // 🏟 Club Option
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: hasClub,
                    activeColor: ColorManager.darkAccent1,
                    onChanged: (value) {
                      setState(() => hasClub = value!);
                    },
                  ),
                  const Text(
                    "Club",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ✅ Submit Button
              SizedBox(
                width: double.infinity,
                child: RegisterButton(
                  label: "Create",
                  onPressed: _validateAndSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}