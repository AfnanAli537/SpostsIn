import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sports_in/app/sports_in.dart';
import 'package:sports_in/firebase_options.dart';
import 'package:sports_in/core/config/language_cubit/language_cubit.dart';
import 'package:sports_in/core/config/theme_cubit/theme_cubit.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/core/services/push_notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("🔔 Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await configureDependencies();
  
  final notificationService = getIt<NotificationService>();
  await notificationService.setupInteractions();
  
  log('📱 Requesting FCM token immediately...');
  // await notificationService.getTokenAndRegister();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<LocaleCubit>()),
        BlocProvider(create: (context) => getIt<ProfileBloc>()),
      ],
      child: const SportsIn(),
    ),
  );
}