import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/view_model/onboarding_bloc/onboarding_bloc.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    context.read<OnboardingBloc>().add(LoadOnboardingEvent());

    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) async {
        if (state is OnboardingCompleted) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('completedOnboarding', true);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
      },
      builder: (context, state) {
        if (state is OnboardingLoaded) {
          return Scaffold(
            body: SafeArea(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: controller,
                itemCount: state.pages.length,
                onPageChanged: (index) {
                  context.read<OnboardingBloc>().add(ChangePageEvent(index));
                },
                itemBuilder: (context, index) {
                  final page = state.pages[index];
                  final isLast = index == state.pages.length - 1;
                  final isFirst = index == 0;

                  return OnboardingPageItem(
                    model: page,
                    isLast: isLast,
                    isFirst: isFirst,
                    currentPage: state.currentPageIndex,
                    totalPages: state.pages.length,
                    pageController: controller,
                    onNext: () {
                      if (!isLast) {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.read<OnboardingBloc>().add(
                          CompleteOnboardingEvent(),
                        );
                      }
                    },
                    onPrevious: () {
                      if (!isFirst) {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    onSkip: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login );
                      context.read<OnboardingBloc>().add(SkipEvent());
                    },
                  );
                },
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
