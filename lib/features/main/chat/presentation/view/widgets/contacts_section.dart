import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/chat_view.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_avatar.dart';

class ContactsSection extends StatelessWidget {
  final bool loading;
  final List<ContactModel> contacts;

  const ContactsSection({
    super.key,
    required this.loading,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            "Contacts",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 90.h,
          child: loading
              ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: contacts.length,
                  separatorBuilder: (_, __) => SizedBox(width: 18.w),
                  itemBuilder: (_, index) {
                    final contact = contacts[index];
                    final name = contact.name;

                    return GestureDetector(
                      onTap: () async {
                        final sharedPref = SharedPref(
                          await SharedPreferences.getInstance(),
                        );
                        final currentUserId = sharedPref.getUserId()!;
                        log('👤 currentUserId: $currentUserId');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<ChatBloc>(),
                              child: ChatView(
                                currentUserId: currentUserId,
                                chat: ChatModel(
                                  id: contact.id,
                                  title: contact.name,
                                  groupPhoto: contact.avatar,
                                  isGroup: false,
                                  members: [],
                                  lastMessage: null,
                                  lastMessageTime: null,
                                  unreadCount: 0,
                                  isOnline: contact.isOnline,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ChatAvatar(
                            name: name,
                            imageUrl: contact.avatar,
                            size: 56.r,
                            showOnline: contact.isOnline,
                          ),
                          SizedBox(height: 6.h),
                          SizedBox(
                            width: 65.w,
                            child: Text(
                              name.split(' ').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
