// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sports_in/features/main/chat_bot/presentation/view/chat_history_screen.dart';
// import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
// import 'package:sports_in/generated/l10n.dart';

// class ChatbotOnboardingScreen extends StatelessWidget {
//   const ChatbotOnboardingScreen({super.key});

//   static const routeName = '/chatbot-onboarding';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 28.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 40.h),
//               Text(
//                 S.of(context).aiAssistantTitle,
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0xFF1A1A2E),
//                       fontSize: 22.sp,
//                     ),
//               ),
//               SizedBox(height: 12.h),
//               Text(
//                 S.of(context).aiAssistantSubtitle,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: Colors.grey.shade600,
//                       height: 1.5,
//                       fontSize: 14.sp,
//                     ),
//               ),
//               SizedBox(height: 48.h),
//               const Expanded(child: Center(child: _RobotIllustration())),
//               SizedBox(height: 48.h),
//               SizedBox(
//                 width: double.infinity,
//                 height: 52.h,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     final prefs = await SharedPreferences.getInstance();
//                     await prefs.setBool('has_seen_chatbot_onboarding', true);

//                     if (!context.mounted) return;

//                     final chatbotBloc = context.read<ChatbotBloc>();

//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => BlocProvider<ChatbotBloc>.value(
//                           value: chatbotBloc,
//                           child: const ChatHistoryScreen(),
//                         ),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF1A1A2E),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14.r),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         S.of(context).continueButton,
//                         style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       Icon(Icons.arrow_forward, size: 18.sp),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(height: 32.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _RobotIllustration extends StatelessWidget {
//   const _RobotIllustration();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 220.w,
//       height: 220.h,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Positioned(
//             bottom: 20.h,
//             child: Container(
//               width: 110.w,
//               height: 110.h,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A1A2E),
//                 borderRadius: BorderRadius.circular(24.r),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 20.h,
//             child: Container(
//               width: 80.w,
//               height: 80.h,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1A1A2E),
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const _Eye(),
//                   SizedBox(width: 14.w),
//                   const _Eye(),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             top: 10.h,
//             right: 0,
//             child: Container(
//               padding: EdgeInsets.all(8.r),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFD4F5C4),
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Icon(
//                 Icons.chat_bubble_outline,
//                 color: const Color(0xFF2E7D32),
//                 size: 20.sp,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 50.h,
//             left: 10.w,
//             child: Icon(
//               Icons.settings,
//               color: const Color(0xFFE8F5E9),
//               size: 28.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Eye extends StatelessWidget {
//   const _Eye();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 14.w,
//       height: 14.h,
//       decoration: const BoxDecoration(
//         color: Color(0xFFD4F5C4),
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }
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