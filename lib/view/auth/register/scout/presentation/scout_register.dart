import 'package:flutter/material.dart';
import 'package:sports_in/view/auth/register/widgets/register_button.dart';
import 'package:sports_in/core/widgets/register_text_field.dart';


class ScoutRegisterScreen extends StatefulWidget {
  const ScoutRegisterScreen({super.key});

  @override
  State<ScoutRegisterScreen> createState() => _ScoutRegisterScreenState();
}

class _ScoutRegisterScreenState extends State<ScoutRegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create your Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RegisterTextField(controller: firstNameController, hintText: "First name"),
            const SizedBox(height: 10),
            RegisterTextField(controller: lastNameController, hintText: "Last name"),
            const SizedBox(height: 10),
            RegisterTextField(controller: emailController, hintText: "Email", keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 10),
            RegisterTextField(controller: passwordController, hintText: "Password", isPassword: true),
            const SizedBox(height: 10),
            RegisterTextField(controller: confirmPasswordController, hintText: "Confirm password", isPassword: true),
            const SizedBox(height: 20),
            RegisterButton(label: "Create", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
