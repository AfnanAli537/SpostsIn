import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/view/user_type/widgets/type_option_tile.dart';
import 'package:sports_in/core/constants/strings_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  String? selectedType;

  // Use non-localized keys for logic and localized labels for display
  final List<Map<String, dynamic>> userTypes = [
    {'key': 'player', 'label': StringsManager.player, 'icon': SvgAssets.player},
    {'key': 'coach', 'label': StringsManager.coach, 'icon': SvgAssets.coach},
    {'key': 'scout', 'label': StringsManager.scout, 'icon': SvgAssets.scout},
    {'key': 'club', 'label': StringsManager.club, 'icon': SvgAssets.club},
    {'key': 'institute', 'label': StringsManager.institute, 'icon': SvgAssets.institute},
    {'key': 'other', 'label': StringsManager.other, 'icon': SvgAssets.other},
  ];

  void _navigateToNext() {
    switch (selectedType) {
      case 'player':
        Navigator.pushNamed(context, AppRoutes.playerRegister);
        break;
      case 'coach':
        Navigator.pushNamed(context, AppRoutes.coachRegister);
        break;
      case 'scout':
        Navigator.pushNamed(context, AppRoutes.scoutRegister);
        break;
      case 'club':
        Navigator.pushNamed(context, AppRoutes.clubRegister);
        break;
      case 'institute':
        Navigator.pushNamed(context, AppRoutes.instituteRegister);
        break;
      case 'other':
        Navigator.pushNamed(context, AppRoutes.otherRegister);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return 
    // SafeArea(
    //   child: 
      Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                StringsManager.whatIsYourType(context),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                StringsManager.knowingYourGoal(context),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 24.h),
      
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemHeight = (constraints.maxHeight -
                            (userTypes.length - 1.h) * 12.h) /
                        userTypes.length;
      
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userTypes.length,
                      itemBuilder: (context, index) {
                        final type = userTypes[index];
                        return SizedBox(
                          height: itemHeight,
                          child: TypeOptionTile(
                            // Display localized label
                            label: type['label'](context),
                            icon: type['icon'],
                            isSelected: selectedType == type['key'],
                            onTap: () => setState(() {
                              selectedType = type['key'];
                            }),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      
              SizedBox(height: 16.h),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       StringsManager.alreadyHaveAnAccount(context),
              //       style: Theme.of(context).textTheme.bodyMedium,
              //     ),
              //     const SizedBox(width: 10),
              //     TextButton(
              //       onPressed: () => Navigator.pop(context),
              //       child: Text(StringsManager.login(context)),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 6.h),
      
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: StringsManager.continueText(context),
                  enabled: selectedType != null,
                  onPressed: selectedType == null ? null : _navigateToNext,
                ),
              ),
            ],
          ),
        ),
      // ),
    );
  }
}
