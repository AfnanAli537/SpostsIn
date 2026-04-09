import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
import 'package:sports_in/generated/l10n.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  bool get _isUser => message.role == 'User';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!_isUser) ...[
            SizedBox(
              width: 32.w,
              height: 32.h,
              child: Image.asset(
                'assets/images/chatbot_robot.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: _isUser ? 60.w : 0,
                right: _isUser ? 0 : 60.w,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: _isUser ?  Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: Radius.circular(_isUser ? 18.r : 4.r),
                  bottomRight: Radius.circular(_isUser ? 4.r : 18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                semanticsLabel: _isUser
                    ? S.of(context).userMessage
                    : S.of(context).botMessage,
                style: TextStyle(
                  color: _isUser ?  Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                  fontSize: 14.sp,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}