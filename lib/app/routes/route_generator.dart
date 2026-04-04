import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
import 'package:sports_in/features/auth_session/view/about_screen.dart';
import 'package:sports_in/features/auth_session/view/account_switcher_screen.dart';
import 'package:sports_in/features/auth_session/view/contact_us_screen.dart';
import 'package:sports_in/features/auth_session/view/setting_screen.dart';
import 'package:sports_in/features/login/data/repo/login_repo.dart';
import 'package:sports_in/features/login/view/presentation/login_screen.dart';
import 'package:sports_in/features/login/view_model/login_bloc/login_bloc.dart';
import 'package:sports_in/features/forget_password/data/repo/forget_password_repo.dart';
import 'package:sports_in/features/forget_password/view/presentation/verify_email_screen.dart';
import 'package:sports_in/features/forget_password/view/presentation/otp_screen.dart';
import 'package:sports_in/features/forget_password/view/presentation/reset_password.dart';
import 'package:sports_in/features/forget_password/view_model/forget_password_bloc/forget_password_bloc.dart';
import 'package:sports_in/features/main/chat/data/repo/chat_repo.dart';
import 'package:sports_in/features/main/chat/data/service/chat_hub_service.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/chat_view.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/create_add_screen.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/my_ads_screen.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/courses/view/presentation/client/course_list_screen.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/data/repo/posts_repo.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/main_layout/main_layout.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/update_opportunity_screen.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/main/profile/view/presentation/edit_profile_router_screen.dart';
import 'package:sports_in/features/main/profile/view/presentation/posts/post_list.dart';
import 'package:sports_in/features/main/profile/view/presentation/posts/post_update.dart';
import 'package:sports_in/features/main/profile/view/presentation/user_profile_screen.dart';
import 'package:sports_in/features/notitification/presentation/post_detail_screen.dart';
import 'package:sports_in/features/notitification/presentation/view_model/bloc/notification_bloc.dart';
import 'package:sports_in/features/payment/presentation/subscription_screen.dart';
import 'package:sports_in/features/payment/presentation/view_model/bloc/payment_bloc.dart';
import 'package:sports_in/features/register/data/repo/register_repo.dart';
import 'package:sports_in/features/register/view/presentation/registration_otp/registration_otp_screen.dart';
import 'package:sports_in/features/register/view_model/register_bloc/register_bloc.dart';
import 'package:sports_in/features/register/view/presentation/user_type/presentation/user_type_screen.dart';
import 'package:sports_in/features/register/view/presentation/register/presentation/player_register.dart';
import 'package:sports_in/features/register/view/presentation/register/presentation/club_register.dart';
import 'package:sports_in/features/register/view/presentation/register/presentation/coach_register.dart';
import 'package:sports_in/features/register/view/presentation/register/presentation/institute_register.dart';
import 'package:sports_in/features/register/view/presentation/register/presentation/other_register.dart';
import 'package:sports_in/features/register/view/presentation/register/presentation/scout_register.dart';
import 'package:sports_in/features/onboarding/view/presentation/onboarding_screen.dart';
import 'package:sports_in/features/onboarding/view/presentation/privacy_policy_screen.dart';
import 'package:sports_in/features/onboarding/view_model/onboarding_bloc/onboarding_bloc.dart';

abstract class RoutesManager {
  static Route<dynamic>? router(RouteSettings settings) {
    switch (settings.name) {
    case AppRoutes.login:
  return CupertinoPageRoute(
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginBloc(getIt<LoginRepo>()),
        ),
        BlocProvider(
          create: (_) => getIt<PaymentBloc>(),
        ),
      ],
      child: LoginScreen(),
    ),
  );
      case AppRoutes.privacyPolicy:
        return CupertinoPageRoute(builder: (_) => PrivacyPolicyScreen());

      case AppRoutes.onboarding:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OnboardingBloc(),
            child: OnboardingScreen(),
          ),
        );

      case AppRoutes.forgetPassword:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ForgotPasswordBloc(getIt<ForgetPasswordRepo>()),
            child: ForgetPasswordScreen(),
          ),
        );

      case AppRoutes.otp:
        final email = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ForgotPasswordBloc(getIt<ForgetPasswordRepo>()),
            child: EmailVerificationScreen(email: email),
          ),
        );

      case AppRoutes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ForgotPasswordBloc(getIt<ForgetPasswordRepo>()),
            child: ResetPasswordScreen(
                email: args['email'], otp: args['otp']),
          ),
        );

      // ── Register ────────────────────────────────────────────────────────────
      case AppRoutes.userType:
        return CupertinoPageRoute(builder: (_) => UserTypeScreen());

      case AppRoutes.subscription:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<PaymentBloc>()..add(const FetchPlansEvent()),
            child: const SubscriptionScreen(),
          ),
        );
      case AppRoutes.registrationOtp:
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegistrationBloc(getIt<RegisterRepo>()),
            child: RegistrationOtpScreen(
              email: args['email'],
              userData: args['userData'],
            ),
          ),
        );

      case AppRoutes.playerRegister:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegistrationBloc(getIt<RegisterRepo>()),
            child: PlayerRegisterScreen(),
          ),
        );

      case AppRoutes.coachRegister:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegistrationBloc(getIt<RegisterRepo>()),
            child: CoachRegisterScreen(),
          ),
        );

      case AppRoutes.clubRegister:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegistrationBloc(getIt<RegisterRepo>()),
            child: ClubRegisterScreen(),
          ),
        );

      case AppRoutes.instituteRegister:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegistrationBloc(getIt<RegisterRepo>()),
            child: InstituteRegisterScreen(),
          ),
        );

      case AppRoutes.otherRegister:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegistrationBloc(getIt<RegisterRepo>()),
            child: OthersRegisterScreen(),
          ),
        );

      case AppRoutes.scoutRegister:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegistrationBloc(getIt<RegisterRepo>()),
            child: ScoutRegisterScreen(),
          ),
        );

      // ── Main ────────────────────────────────────────────────────────────────
      // case AppRoutes.mainLayout:
      //   return CupertinoPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (_) =>
      //           PostsBloc(postRepo: getIt<PostsRepositoryImpl>()),
      //       child: CustomBottomNav(),
      //     ),
      //   );

case AppRoutes.mainLayout:
  return CupertinoPageRoute(
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PostsBloc(postRepo: getIt<PostsRepositoryImpl>()),
        ),
        BlocProvider(
          create: (_) => getIt<NotificationBloc>()
            ..add(const GetUnreadCountEvent()),
        ),
      ],
      child: const CustomBottomNav(),
    ),
  );
  case AppRoutes.postDetail:
  final postId = settings.arguments as String;
  return CupertinoPageRoute(
    builder: (_) => PostDetailScreen(postId: postId),
  );
      // ── Profile ─────────────────────────────────────────────────────────────
      case AppRoutes.userProfile:
        final userId = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => UserProfileScreen(userId: userId),
        );

      case AppRoutes.editProfile:
        return CupertinoPageRoute(
            builder: (_) => EditProfileRouterScreen());

      case AppRoutes.profilePostsListScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
          builder: (_) => ProfilePostsListScreen(
            userId: args['userId'],
            isCurrentUser: args['isCurrentUser'],
          ),
        );

      case AppRoutes.profilePostsEditScreen:
        final args = settings.arguments as PostModel;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostsBloc(postRepo: getIt<PostsRepositoryImpl>()),
            child: UpdatePostScreen(post: args),
          ),
        );

      // ── Opportunity ─────────────────────────────────────────────────────────
      case AppRoutes.opportunityEditScreen:
        final opportunityId = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OpportunityBloc(
              opportunityRepo: getIt<OpportunityReposatory>(),
            ),
            child: UpdateOpportunityScreen(opportunityId: opportunityId),
          ),
        );
      case AppRoutes.chatView:
        final args = settings.arguments as Map<String, dynamic>;
        final chat = args['chat'] as ChatModel;
        final currentUserId = args['currentUserId'] as String;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ChatBloc(
              repo: getIt<ChatRepository>(),
              hub: getIt<ChatHubService>(),
            ),
            child: ChatView(chat: chat, currentUserId: currentUserId),
          ),
        );

      // ── Courses ─────────────────────────────────────────────────────────────
      case AppRoutes.courseList:
        final args = settings.arguments as Map<String, dynamic>;
        final coursesBloc = args['coursesBloc'] as CoursesBloc;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider.value(
            value: coursesBloc,
            child: CourseListScreen(
              listType: args['listType'] as CourseListType,
            ),
          ),
        );

      // ── Settings / misc ─────────────────────────────────────────────────────
      case AppRoutes.settings:
        return CupertinoPageRoute(
            builder: (_) => const SettingsScreen());

      case AppRoutes.contactUs:
        return CupertinoPageRoute(
            builder: (_) => const ContactUsScreen());

      case AppRoutes.about:
        return CupertinoPageRoute(builder: (_) => const AboutScreen());

      case AppRoutes.accountSwitcher:
        return CupertinoPageRoute(
          builder: (_) => const AccountSwitcherBottomSheet(),
        );

      // ── Advertisements ──────────────────────────────────────────────────────
      /// [settings.arguments] is null  → create mode
      /// [settings.arguments] is [AdModel] → edit mode
      case AppRoutes.createAdScreen:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AdsBloc(adsRepo: getIt<AdsRepositoryImpl>()),
            child: CreateAdScreen(
              existingAd: settings.arguments as AdModel?,
            ),
          ),
        );

      /// Navigate to "My Ads" — MyAdsScreen provides its own BLoC internally,
      /// so no wrapper is needed here.
      case AppRoutes.myAdsScreen:
        return CupertinoPageRoute(
          builder: (_) => const MyAdsScreen(),
        );

      default:
        return null;
    }
  }
}