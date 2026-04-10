import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view/chat_history_screen.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class ChatbotOnboardingScreen extends StatelessWidget {
  const ChatbotOnboardingScreen({super.key});

  static const routeName = '/chatbot-onboarding';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Text(
                S.of(context).aiAssistantTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      // color: const Color(0xFF1A1A2E),
                      color:Theme.of(context).colorScheme.primary ,
                      fontSize: 22.sp,
                    ),
              ),
              SizedBox(height: 12.h),
              Text(
                S.of(context).aiAssistantSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.5,
                      fontSize: 14.sp,
                    ),
              ),
              SizedBox(height: 32.h),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/chatbot_robot.png',
                    width: 280.w,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('has_seen_chatbot_onboarding', true);

                    if (!context.mounted) return;

                    final chatbotBloc = context.read<ChatbotBloc>();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<ChatbotBloc>.value(
                          value: chatbotBloc,
                          child: const ChatHistoryScreen(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: const Color(0xFF1A1A2E),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor:Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).continueButton,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward, size: 18.sp),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}