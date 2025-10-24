import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isChecked = false;
  bool _isLoading = false;

  Future<void> _continue(BuildContext context) async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenPrivacy', true);

    // Add a short delay just for smoother transition
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Policy'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.02,
          ),
          child: Column(
            children: [
              // Scrollable privacy content
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    '''
Welcome to SportsIn!

We value your privacy. This Privacy Policy explains how we collect, use, and protect your personal data when using our app.

1. Information We Collect
   - Account data (name, email, etc.)
   - Activity and interaction data
   - Uploaded media (e.g., profile pictures, videos)

2. How We Use Your Information
   - Improve your experience
   - Enable communication between users
   - Provide AI-based performance insights

3. Sharing Your Information
   - We do not sell your data
   - Data may be shared with trusted service providers

By continuing, you confirm that you have read and agree to our policy.
                    ''',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(height: 1.6),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Checkbox + text
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (val) {
                      setState(() => _isChecked = val ?? false);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the Privacy Policy and Terms of Service.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isChecked && !_isLoading
                      ? () => _continue(context)
                      : null, // disabled until agreed
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
