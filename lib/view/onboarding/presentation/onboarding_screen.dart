import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/data/models/onboarding_model.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view_model/onboarding_bloc/onboarding_bloc.dart';
import '../widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
      final pages = [
      OnboardingModel(
       title: string.onboarding1Title,
       description: string.onboarding1Desc,
        imagePath:ImageAssets.onboarding1 ,
      ),
      OnboardingModel(
        title: string.onboarding2Title,
        description: string.onboarding2Desc,
        imagePath:ImageAssets.onboarding2,
      ),
      OnboardingModel(
        title:string.onboarding3Title ,
        description:string.onboarding3Desc ,
        imagePath:ImageAssets.onboarding3 ,
      ),
      OnboardingModel(
        title:string.onboarding4Title,
        description:string.onboarding4Desc ,
        imagePath:ImageAssets.onboarding4 ,
      ),
      OnboardingModel(
        title:string.onboarding5Title ,
        description:string.onboarding5Desc ,
        imagePath:ImageAssets.onboarding5 ,
      ),
    ];

    final PageController controller = PageController();
    context.read<OnboardingBloc>().add(LoadOnboardingEvent(pagesLength: pages.length));

    return BlocConsumer<OnboardingBloc, OnboardingState>(
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
              itemCount: pages.length,
              onPageChanged: (index) {
                context.read<OnboardingBloc>().add(ChangePageEvent(index));
              },
              itemBuilder: (context, index) {
                final page = pages[index];
                final isLast = index == pages.length - 1;
                final isFirst = index == 0;
    
                return OnboardingPageItem(
                  model: page,
                  isLast: isLast,
                  isFirst: isFirst,
                  currentPage: state.currentPageIndex,
                  totalPages: pages.length,
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
    );
  }
}
