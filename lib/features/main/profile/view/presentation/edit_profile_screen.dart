import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(string.profile),
        actions: [
          IconButton(
            icon: Icon(Icons.block_outlined, color: theme.iconTheme.color),
            onPressed: () {
              // Save profile changes
            },
          ),
        ],
      ),
      body: Center(child: Text('Edit Profile Screen'))
      );
  }
}