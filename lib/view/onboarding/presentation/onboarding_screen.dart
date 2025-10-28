import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/stateful_wrapper.dart';
import 'package:sports_in/view_model/onboarding_bloc/onboarding_bloc.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    context.read<OnboardingBloc>().add(LoadOnboardingEvent());

    return StatefulWrapper(
      onInit: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      },
      onDispose: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      child: BlocConsumer<OnboardingBloc, OnboardingState>(
        listener: (context, state) async {
          if (state is OnboardingCompleted) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        builder: (context, state) {
          if (state is OnboardingLoaded) {
            return Scaffold(
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
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
                        context
                            .read<OnboardingBloc>()
                            .add(CompleteOnboardingEvent());
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
                      context.read<OnboardingBloc>().add(SkipEvent());
                    },
                  );
                },
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
