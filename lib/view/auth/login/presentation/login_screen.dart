import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Login Screen'),
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.userType);
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),

      ),
    );
  }
}