// // features/main/profile/view/widgets/follow_card.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sports_in/core/widgets/connect_button.dart';
// import 'package:sports_in/core/widgets/custom_avatar.dart';
// import 'package:sports_in/core/widgets/follow_button.dart';
// import 'package:sports_in/features/main/profile/model/profile_model.dart';
// import 'package:sports_in/features/main/profile/view_model/follow_bloc/follow_bloc.dart';
// import 'package:sports_in/generated/l10n.dart';

// class FollowCard extends StatelessWidget {
//   final UserContactItem contact;
//   final String currentUserId;
//   final String? followText;
//   final VoidCallback onTap;

//   const FollowCard({
//     super.key,
//     required this.contact,
//     required this.currentUserId,
//     this.followText,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final strings = S.of(context);
//     final isCurrentUser = contact.userId == currentUserId;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.only(bottom: 16.h),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(12.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8.r,
//               offset: Offset(0, 2.h),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16.r),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CustomAvatar(
//                     imageUrl: contact.profilePictureUrl,
//                     name: contact.fullName,
//                     radius: 32.r,
//                   ),
//                   SizedBox(width: 16.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           contact.fullName,
//                           style: theme.textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.w700,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (contact.bio != null) ...[
//                           SizedBox(height: 4.h),
//                           Text(
//                             contact.bio!,
//                             style: theme.textTheme.bodySmall,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     Icons.chevron_right_rounded,
//                     color: theme.colorScheme.onTertiaryContainer,
//                     size: 22.sp,
//                   ),
//                 ],
//               ),
//               if (!isCurrentUser) ...[
//                 SizedBox(height: 16.h),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: ConnectButton(
//                         connectionStatus: contact.connectionStatus,
//                         onPressed: () {
//                           final status = contact.connectionStatus;
//                           if (status == null) {
//                             context.read<FollowListBloc>().add(
//                                   SendConnectionRequestOnItem(contact.userId),
//                                 );
//                           } else if (status == 'Accepted') {
//                             context.read<FollowListBloc>().add(
//                                   RemoveContactOnItem(contact.userId),
//                                 );
//                           }
//                         },
//                         // ✅ Accept / Reject callbacks for incoming requests
//                         onAccept: () {
//                           context.read<FollowListBloc>().add(
//                                 AcceptConnectionRequestOnItem(contact.userId),
//                               );
//                         },
//                         onReject: () {
//                           context.read<FollowListBloc>().add(
//                                 RejectConnectionRequestOnItem(contact.userId),
//                               );
//                         },
//                         connectText: strings.connect,
//                         pendingText: strings.pending,
//                         removeContactText: strings.remove,
//                         acceptText: strings.accept,
//                         rejectText: strings.reject,
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: FollowButton(
//                         isFollowing: contact.isFollowedByMe,
//                         onPressed: () {
//                           context.read<FollowListBloc>().add(
//                                 ToggleFollowOnItem(contact.userId),
//                               );
//                         },
//                         followingText: strings.following,
//                         followText: strings.follow,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }