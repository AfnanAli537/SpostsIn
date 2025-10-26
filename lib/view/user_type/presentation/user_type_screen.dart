import 'package:flutter/material.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/view/auth/register/widgets/register_button.dart';
import 'package:sports_in/view/user_type/widgets/type_option_tile.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  String? selectedType;

  final List<Map<String, dynamic>> userTypes = [
    {'label': 'Player', 'icon': Icons.sports_soccer},
    {'label': 'Coach', 'icon': Icons.manage_accounts_sharp},
    {'label': 'Scout', 'icon': Icons.search},
    {'label': 'Club', 'icon': Icons.group},
    {'label': 'Institute', 'icon': Icons.business},
    {'label': 'Other', 'icon': Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // 👈 changed this
          children: [
            const Text(
              "What Is Your Type?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Knowing your goal helps us tailor your experience",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: ColorManager.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userTypes.length,
                itemBuilder: (context, index) {
                  final type = userTypes[index];
                  return TypeOptionTile(
                    label: type['label']!,
                    icon: type['icon'] ?? Icons.help_outline,
                    isSelected: selectedType == type['label'],
                    onTap: () => setState(() => selectedType = type['label']),
                  );
                },
              ),
            ),
            SizedBox(
  width: double.infinity,
  child: RegisterButton(
    label: "CONTINUE",
    enabled: selectedType != null,
    onPressed: selectedType == null
        ? null
        : () {
            switch (selectedType) {
              case 'Player':
                Navigator.pushNamed(context, AppRoutes.playerRegister);
                break;
              case 'Coach':
                Navigator.pushNamed(context, AppRoutes.coachRegister);
                break;
              case 'Scout':
                Navigator.pushNamed(context, AppRoutes.scoutRegister);
                break;
              case 'Club':
                Navigator.pushNamed(context, AppRoutes.clubRegister);
                break;
              case 'Institute':
                Navigator.pushNamed(context, AppRoutes.instituteRegister);
                break;
              case 'Other':
                Navigator.pushNamed(context, AppRoutes.otherRegister);
                break;
            }
          },
  ),
),

          ],
        ),
      ),
    );
  }
}
