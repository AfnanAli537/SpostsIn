// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/constants/strings_manager.dart';
import 'package:sports_in/data/models/onboarding_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingModel model;
  final bool isLast;
  final bool isFirst;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final VoidCallback onSkip;
  final PageController pageController;

  const OnboardingPageItem({
    super.key,
    required this.model,
    required this.isLast,
    required this.isFirst,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(model.imagePath),
              fit: BoxFit.cover, 
            ),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.45)
            ),

            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, 
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: onSkip,
                        style: theme.textButtonTheme.style,
                        child:  Visibility(
                          visible: !isLast,
                          child: Text(
                            StringsManager.skip(context),
                            style: textTheme.bodyLarge?.copyWith(
                              color: ColorManager.lightBackground,
                            ),
                          ),
                        ),
                      ),
                    ),
            
                    SizedBox(height: 38.h),
                    Text(
                      StringsManager.getLocalizedString(context, model.title),
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
            
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        StringsManager.getLocalizedString(
                            context, model.description),
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: ColorManager.lightBackground,
                        ),
                      ),
                    ),
            
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: isFirst ? null : onPrevious,
                          style: theme.textButtonTheme.style?.copyWith(
                            foregroundColor: WidgetStatePropertyAll(
                              isFirst
                                  ? colorScheme.onSurface.withOpacity(0.4)
                                  : colorScheme.onPrimary,
                            ),
                          ),
                          child: Row(
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                size: 12,
                                color: isFirst
                                   ? ColorManager.darkTextPrimary
                                          .withOpacity(0.4)
                                    : ColorManager.lightBackground
                              ),
                              Text(
                                StringsManager.back(context),
                                style: textTheme.labelLarge?.copyWith(
                                  color: isFirst
                                      ? ColorManager.darkTextPrimary
                                          .withOpacity(0.4)
                                      : ColorManager.lightBackground
                                ),
                              ),
                            ],
                          ),
                        ),
                        SmoothPageIndicator(
                          controller: pageController,
                          count: totalPages,
                          effect: ExpandingDotsEffect(
                            expansionFactor: 3,
                            dotHeight: 8.h,
                            dotWidth: 8.w,
                            spacing: 6.w,
                            activeDotColor: colorScheme.primary,
                            dotColor:
                                colorScheme.onSurface.withOpacity(0.3),
                            radius: 8.r,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onNext,
                          style: theme.elevatedButtonTheme.style,
                          child: Row(
                            spacing: 5,
                            children: [
                              Text(
                                isLast
                                    ? StringsManager.getStarted(context)
                                    : StringsManager.next(context),
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onInverseSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        isLast?
                            SizedBox.shrink()  : Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: colorScheme.onInverseSurface,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
