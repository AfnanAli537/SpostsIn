import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/widgets/auth_text_form_feild.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Get user email from SharedPrefs
      final user = await getIt<SharedPref>().getUserFromPrefs();
      final userEmail = user?.email ?? 'user@example.com';
      
      final subject = Uri.encodeComponent('Support Request from SportsIn');
      final body = Uri.encodeComponent(_messageController.text);
      
      final emailUrl = 'mailto:sportsin.connect@gmail.com?subject=$subject&body=$body';
      
      if (await canLaunchUrl(Uri.parse(emailUrl))) {
        await launchUrl(Uri.parse(emailUrl));
        
        if (mounted) {
          Fluttertoast.showToast(
            msg: S.of(context).messageSent,
            backgroundColor: Colors.green,
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception('Could not launch email');
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: S.of(context).failedToSendMessage,
          backgroundColor: Colors.red,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(string.contactUs),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Info Card
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 48.sp,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Contact us for SportsIn',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16.sp,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'sportsin.connect@gmail.com',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 16.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '+20 155 000 0001 (24/7)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // Send Message Section
              Text(
                'Send Message',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your email will be automatically included in the message',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24.h),
              
              // Message Input
              AuthTextField(
                controller: _messageController,
                hintText: 'Write your text',
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Message is required';
                  }
                  if (value.length < 10) {
                    return 'Message must be at least 10 characters';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 32.h),
              
              // Send Button
              CustomElevatedButton(
                text: 'Send Message',
                isLoading: _isLoading,
                onPressed: _sendEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}