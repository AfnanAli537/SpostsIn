// // following_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sports_in/app/di/injection.dart';
// import 'package:sports_in/app/routes/app_routes.dart';
// import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
// import 'package:sports_in/core/constants/color_manager.dart';
// import 'package:sports_in/features/main/profile/view/widgets/connections_shimmer.dart';
// import 'package:sports_in/features/main/profile/view/widgets/follow_card.dart';
// import 'package:sports_in/features/main/profile/view_model/following_bloc/follow_bloc.dart';
// import 'package:sports_in/generated/l10n.dart';

// // ✅ Separate the provider from the view
// class FollowingScreen extends StatelessWidget {
//   final String userId;
//   const FollowingScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<FollowingBloc>()..add(LoadFollowing(userId)),
//       child: FollowingView(userId: userId),
//     );
//   }
// }

// class FollowingView extends StatefulWidget {
//   final String userId;
//   const FollowingView({super.key, required this.userId});

//   @override
//   State<FollowingView> createState() => _FollowingViewState();
// }

// class _FollowingViewState extends State<FollowingView> {
//   final _scrollController = ScrollController();
//   late final String currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     final sharedPref = getIt<SharedPref>();
//     currentUserId = sharedPref.getUserId() ?? '';
//   }

//   void _onScroll() {
//     final pixels = _scrollController.position.pixels;
//     final maxExtent = _scrollController.position.maxScrollExtent;
//     if (pixels < maxExtent - 200) return;
//     context.read<FollowingBloc>().add(LoadMoreFollowing());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final strings = S.of(context);
//     return Scaffold(
//       appBar: AppBar(title: Text(strings.following), centerTitle: true),
//       body: BlocConsumer<FollowingBloc, FollowingState>(
//         listener: (context, state) {
//           if (state is FollowingError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: ColorManager.error,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is FollowingLoading) {
//             return SingleChildScrollView(
//               physics: const NeverScrollableScrollPhysics(),
//               child: ConnectionsShimmer(isOwner: false),
//             );
//           }
//           if (state is FollowingError) {
//             return _buildError(state.message);
//           }
//           if (state is FollowingLoaded) {
//             return RefreshIndicator(
//               onRefresh: () async {
//                 context.read<FollowingBloc>().add(LoadFollowing(widget.userId));
//               },
//               child: CustomScrollView(
//                 controller: _scrollController,
//                 slivers: [
//                   if (state.items.isEmpty)
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 80.h),
//                         child: Center(
//                           child: Text(
//                             strings.noFollowingYet,
//                             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                   color: ColorManager.hintTextColor,
//                                 ),
//                           ),
//                         ),
//                       ),
//                     )
//                   else
//                     SliverPadding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       sliver: SliverList(
//                         delegate: SliverChildBuilderDelegate(
//                           (context, index) => FollowCard(
//                             contact: state.items[index],
//                             currentUserId: currentUserId,
//                             onTap: () => Navigator.pushNamed(
//                               context,
//                               AppRoutes.userProfile,
//                               arguments: state.items[index].userId,
//                             ),
//                           ),
//                           childCount: state.items.length,
//                         ),
//                       ),
//                     ),
//                   if (state.isLoadingMore)
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16.h),
//                         child: const Center(child: CircularProgressIndicator()),
//                       ),
//                     ),
//                   if (!state.hasNextPage && !state.isLoadingMore && state.items.isNotEmpty)
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12.h),
//                         child: Center(
//                           child: Text(
//                             strings.noMoreContacts,
//                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                   color: ColorManager.hintTextColor,
//                                 ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   SliverToBoxAdapter(child: SizedBox(height: 24.h)),
//                 ],
//               ),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildError(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 48.sp, color: ColorManager.error),
//           SizedBox(height: 12.h),
//           Text(message, textAlign: TextAlign.center),
//           SizedBox(height: 16.h),
//           ElevatedButton(
//             onPressed: () {
//               context.read<FollowingBloc>().add(LoadFollowing(widget.userId));
//             },
//             child: Text(S.of(context).retry),
//           ),
//         ],
//       ),
//     );
//   }
// }