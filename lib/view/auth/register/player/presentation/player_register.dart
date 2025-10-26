import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/validators/auth_validator.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/register_text_field.dart';
import 'package:sports_in/core/widgets/register_two_fields_row.dart';
import 'package:sports_in/view/auth/register/widgets/register_button.dart';
import 'package:sports_in/view/user_type/widgets/app_dropdown_overlay.dart';

class PlayerRegisterScreen extends StatefulWidget {
  const PlayerRegisterScreen({super.key});

  @override
  State<PlayerRegisterScreen> createState() => _PlayerRegisterScreenState();
}

class _PlayerRegisterScreenState extends State<PlayerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  String? selectedCountry;
  String? selectedSport;
  String? selectedPosition;
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
      _errors['height'] = ValidationHelper.validateRequired(
        heightController.text,
        fieldName: "Height",
      );
      _errors['weight'] = ValidationHelper.validateRequired(
        weightController.text,
        fieldName: "Weight",
      );
      _errors['age'] = ValidationHelper.validateRequired(
        ageController.text,
        fieldName: "Age",
      );

      if (selectedCountry == null) _errors['country'] = "Please select a country";
      if (selectedSport == null) _errors['sport'] = "Please select a sport";
      if (selectedPosition == null) _errors['position'] = "Please select a position";
      if (selectedGender == null) _errors['gender'] = "Please select gender";
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

                // 📏 Height & Weight
                RegisterTwoFieldsRow(
                  leftField: RegisterTextField(
                    controller: heightController,
                    hintText: "Height",
                    keyboardType: TextInputType.number,
                    errorText: _errors['height'],
                  ),
                  rightField: RegisterTextField(
                    controller: weightController,
                    hintText: "Weight",
                    keyboardType: TextInputType.number,
                    errorText: _errors['weight'],
                  ),
                ),
                const SizedBox(height: 10),

                // 🌍 Country
                AppDropdownOverlay(
                  hintText: "Select country",
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
                  value: selectedCountry,
                  onChanged: (v) {
                    _unfocus();
                    setState(() => selectedCountry = v);
                  },
                  errorText: _errors['country'],
                ),
                const SizedBox(height: 10),

                // ⚽ Sport + Age
                RegisterTwoFieldsRow(
                  leftField: AppDropdownOverlay(
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
                  rightField: RegisterTextField(
                    controller: ageController,
                    hintText: "Age",
                    keyboardType: TextInputType.number,
                    errorText: _errors['age'],
                  ),
                ),
                const SizedBox(height: 10),

                // 🧩 Position
                AppDropdownOverlay(
                  hintText: "Position",
                  options: const [
                    "Defense",
                    "Midfielder",
                    "Forward",
                    "Goalkeeper",
                  ],
                  value: selectedPosition,
                  onChanged: (v) {
                    _unfocus();
                    setState(() => selectedPosition = v);
                  },
                  errorText: _errors['position'],
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
      ),
    );
  }
}
