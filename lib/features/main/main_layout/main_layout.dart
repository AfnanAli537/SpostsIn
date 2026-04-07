import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/chat/data/repo/chat_repo.dart';
import 'package:sports_in/features/main/chat/data/service/chat_hub_service.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/messages_view.dart';
import 'package:sports_in/features/main/chat_bot/data/repo/chatbot_repo.dart';
import 'package:sports_in/features/main/chat_bot/presentation/view_model.dart/bloc/chatbot_bloc.dart';
import 'package:sports_in/features/main/home/view/presentation/home_screen.dart';
import 'package:sports_in/features/main/home/view/widgets/buttom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/app_drawer.dart';
import 'package:sports_in/features/main/profile/view/presentation/my_profile_screen.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/features/main/search/view/presentation/search_screen.dart';
import 'package:sports_in/features/notitification/data/service/notifaction_service.dart';
import 'package:sports_in/features/notitification/presentation/notifi_screen.dart';
import 'package:sports_in/features/notitification/presentation/view_model/bloc/notification_bloc.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();
  late final List<Widget> _pages = [
    const HomePage(),
    const SearchScreen(),
    MultiBlocProvider(
      providers: [
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(
            repo: getIt<ChatRepository>(),
            hub: getIt<ChatHubService>(),
          ),
        ),
        BlocProvider<ChatbotBloc>(
        create: (_) =>ChatbotBloc(repository: getIt<ChatbotRepository>()),
      ),
      ],
      child: const MessagesView(),
    ),
    const MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    final hub = GetIt.I<NotificationHubService>();

    hub.onReceiveNotification = (notification) {
      if (!mounted) return;
      context.read<NotificationBloc>().add(
        RealtimeNotificationReceivedEvent(notification: notification),
      );
    };

    hub.onConnectionStateChanged = (state) {
      if (!mounted) return;
      debugPrint('🔌 SignalR state: $state');
    };

    _initSignalR(hub);

    context.read<NotificationBloc>().add(const GetUnreadCountEvent());
    context.read<ProfileBloc>().add(LoadMyProfile());
  }

  Future<void> _initSignalR(NotificationHubService hub) async {
    try {
      await hub.connect();
    } catch (e) {
      debugPrint('❌ Initial SignalR connect error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onItemTapped(int index) {
    // Unfocus any active text field when switching tabs
    FocusScope.of(context).unfocus();
    setState(() => _currentIndex = index);
  }

  void _openNotifications() {
    final bloc = context.read<NotificationBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationScreen(notificationBloc: bloc),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : const Color(0xFFB0BEC5),
                size: 24.r,
              ),
              SizedBox(height: 2.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 5.w,
                height: 5.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (prev, curr) =>
          curr is NotificationsLoaded || curr is UnreadCountLoaded,
      builder: (context, state) {
        int unread = 0;
        if (state is NotificationsLoaded) unread = state.unreadCount;
        if (state is UnreadCountLoaded) unread = state.count;

        return IconButton(
          onPressed: _openNotifications,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              if (unread > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3DBE6C),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unread > 99 ? '99+' : '$unread',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      drawer: const AppDrawer(),
      onDrawerChanged: (isOpen) {
        if (isOpen) {
          // Dismiss keyboard as soon as the drawer starts opening
          _focusNode.unfocus();
          FocusScope.of(context).unfocus();
        }
      },
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: theme.colorScheme.surface,
              elevation: 0,
              floating: true,
              snap: true,
              leading: IconButton(
                icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
                onPressed: () {
                  // Unfocus before opening drawer so search field is blurred
                  FocusScope.of(context).unfocus();
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    ImageAssets.logo,
                    height: 32.h,
                    width: 32.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "SportsIn",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [_buildNotificationBell()],
            ),
          ];
        },
        body: IndexedStack(
          index: _currentIndex,
          children: _pages
              .asMap()
              .entries
              .map(
                (e) => ExcludeFocus(
                  excluding: _currentIndex != e.key,
                  child: e.value,
                ),
              )
              .toList(),
        ),
      ),
      // ── Fix: hide FAB when keyboard is open ────────────────────────────
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isKeyboardOpen
          ? null
          : SizedBox(
              width: 60.w,
              height: 60.h,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: theme.colorScheme.primary,
                elevation: 4,
                onPressed: () => showCreateOptionsBottomSheet(context),
                child: Icon(
                  Icons.add,
                  color: theme.colorScheme.onPrimary,
                  size: 32.r,
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.r,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 65.h,
          child: Row(
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.search, 1),
              SizedBox(width: 60.w),
              _buildNavItem(Icons.chat_bubble_outline, 2),
              _buildNavItem(Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }
}
