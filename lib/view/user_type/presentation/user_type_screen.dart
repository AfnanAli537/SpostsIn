import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/view/user_type/widgets/type_option_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  late S string;
  late List<Map<String, dynamic>> userTypes;
  String? selectedType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    string = S.of(context);
    userTypes = [
      {'key': 'player', 'label': string.player, 'icon': svgAssets.player},
      {'key': 'coach', 'label': string.coach, 'icon': svgAssets.coach},
      {'key': 'scout', 'label': string.scout, 'icon': svgAssets.scout},
      {'key': 'club', 'label': string.club, 'icon': svgAssets.club},
      {'key': 'institute', 'label': string.institute, 'icon': svgAssets.institute},
      {'key': 'other', 'label': string.other, 'icon': svgAssets.other},
    ];
  }

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
                string.whatIsYourType,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                string.knowingYourGoal,
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
                            label: type['label'],
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
              //       string.alreadyHaveAnAccount(context),
              //       style: Theme.of(context).textTheme.bodyMedium,
              //     ),
              //     const SizedBox(width: 10),
              //     TextButton(
              //       onPressed: () => Navigator.pop(context),
              //       child: Text(string.login(context)),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 6.h),
      
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  text: string.continueText,
                  enabled: selectedType != null,
                  onPressed: () {
                    if (selectedType != null) _navigateToNext();
                  },
                ),
              ),
            ],
          ),
        ),
      // ),
    );
  }
}
