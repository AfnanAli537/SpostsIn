// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sports_in/features/main/courses/model/course_models.dart';
// import 'package:sports_in/features/main/courses/view/presentation/client/course_detail_screen.dart';
// import 'package:sports_in/features/main/courses/view/presentation/client/course_list_screen.dart';
// import 'package:sports_in/features/main/courses/view/widgets/course_card.dart';
// import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
// import 'package:sports_in/generated/l10n.dart';

// class CoursesHomeScreen extends StatefulWidget {
//   const CoursesHomeScreen({super.key});

//   @override
//   State<CoursesHomeScreen> createState() => _CoursesHomeScreenState();
// }

// class _CoursesHomeScreenState extends State<CoursesHomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch initial data
//     _loadData();
//   }

//   void _loadData() {
//     context.read<CoursesBloc>()
//       ..add(const FetchEnrolledCourses(page: 1, size: 3))
//       ..add(const FetchAvailableCourses(page: 1, size: 6));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final string = S.of(context);

//     // ✅ FINAL FIX: Return plain Column - no RefreshIndicator, no Slivers
//     // Parent (BuildContent/HomeTab) handles the scrolling
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 16.h),
        
//         // Continue Watching Section
//         BlocBuilder<CoursesBloc, CoursesState>(
//           builder: (context, state) {
//             if (state is EnrolledCoursesLoaded && state.courses.isNotEmpty) {
//               final inProgressCourses = state.courses
//                   .where((c) => c.progress > 0 && c.progress < 100)
//                   .toList()
//                 ..sort((a, b) => b.progress.compareTo(a.progress));

//               if (inProgressCourses.isNotEmpty) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       child: Text(
//                         // string.continueWatching ?? 
//                         'Continue Watching',
//                         style: theme.textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       child: _buildLastViewedCard(inProgressCourses.first, theme),
//                     ),
//                     SizedBox(height: 24.h),
//                   ],
//                 );
//               }
//             }
//             return const SizedBox.shrink();
//           },
//         ),

//         // Enrolled Courses Section
//         BlocBuilder<CoursesBloc, CoursesState>(
//           builder: (context, state) {
//             if (state is EnrolledCoursesLoaded && state.courses.isNotEmpty) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           // string.enrolledCourses ?? 
//                           'Enrolled Courses',
//                           style: theme.textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => BlocProvider.value(
//                                   value: context.read<CoursesBloc>(),
//                                   child: const CourseListScreen(
//                                     listType: CourseListType.enrolled,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Text(
//                             // string.showMore ?? 
//                           'Show More'),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 280.h,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: EdgeInsets.symmetric(horizontal: 16.w),
//                       itemCount: state.courses.length > 3 ? 3 : state.courses.length,
//                       itemBuilder: (context, index) {
//                         final course = state.courses[index];
//                         return Container(
//                           width: 250.w,
//                           margin: EdgeInsets.only(right: 16.w),
//                           child: CourseCard(
//                             course: course,
//                             onTap: () => _navigateToCourseDetail(course.id),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 24.h),
//                 ],
//               );
//             }
//             return const SizedBox.shrink();
//           },
//         ),

//         // New Courses Section
//         BlocBuilder<CoursesBloc, CoursesState>(
//           builder: (context, state) {
//             if (state is CoursesLoading) {
//               return Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(32.h),
//                   child: const CircularProgressIndicator(),
//                 ),
//               );
//             }

//             if (state is CoursesLoaded) {
//               if (state.courses.isEmpty) {
//                 return Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(32.h),
//                     child: Text(
//                       // string.noCoursesAvailable ?? 
//                       'No courses available',
//                       style: theme.textTheme.bodyLarge,
//                     ),
//                   ),
//                 );
//               }

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.w),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           // string.newCourses ?? 
//                           'New Courses',
//                           style: theme.textTheme.titleLarge?.copyWith(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => BlocProvider.value(
//                                   value: context.read<CoursesBloc>(),
//                                   child: const CourseListScreen(
//                                     listType: CourseListType.available,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Text(
//                             // string.showMore ?? 
//                             'Show More'),
//                         ),
//                       ],
//                     ),
//                   ),
//                   ...state.courses.take(6).map((course) => CourseCard(
//                         course: course,
//                         onTap: () => _navigateToCourseDetail(course.id),
//                       )),
//                 ],
//               );
//             }

//             if (state is CoursesError) {
//               return Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(32.h),
//                   child: Column(
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 48.sp,
//                         color: theme.colorScheme.error,
//                       ),
//                       SizedBox(height: 16.h),
//                       Text(
//                         state.message,
//                         style: theme.textTheme.bodyLarge,
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 16.h),
//                       ElevatedButton(
//                         onPressed: _loadData,
//                         child: Text(string.retry ?? 'Retry'),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return const SizedBox.shrink();
//           },
//         ),

//         SizedBox(height: 24.h),
//       ],
//     );
//   }

//   Widget _buildLastViewedCard(CourseModel course, ThemeData theme) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BlocProvider.value(
//               value: context.read<CoursesBloc>(),
//               child: CourseDetailScreen(courseId: course.id),
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Thumbnail
//             ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
//               child: Stack(
//                 children: [
//                   Image.network(
//                     course.thumbnailUrl ?? '',
//                     height: 180.h,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       height: 180.h,
//                       color: Colors.grey[300],
//                       child: Icon(Icons.image_not_supported, size: 48.sp),
//                     ),
//                   ),
//                   // Play overlay
//                   Positioned.fill(
//                     child: Container(
//                       color: Colors.black.withOpacity(0.3),
//                       child: Center(
//                         child: Container(
//                           padding: EdgeInsets.all(16.r),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             Icons.play_arrow,
//                             size: 32.sp,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: EdgeInsets.all(16.r),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     course.title,
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     course.owner.fullName,
//                     style: theme.textTheme.bodySmall,
//                   ),
//                   SizedBox(height: 12.h),
//                   // Progress bar
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '${course.progress}% Complete',
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             course.formattedDuration,
//                             style: theme.textTheme.bodySmall,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8.h),
//                       LinearProgressIndicator(
//                         value: course.progress / 100,
//                         backgroundColor: Colors.grey[200],
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           theme.colorScheme.primary,
//                         ),
//                         minHeight: 6.h,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _navigateToCourseDetail(String courseId) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider.value(
//           value: context.read<CoursesBloc>(),
//           child: CourseDetailScreen(courseId: courseId),
//         ),
//       ),
//     );
//   }
// }