import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';

class PlayerDataSection extends StatelessWidget {
  final PlayerSpecificData data;
  final ThemeData theme;
  final S string;

  const PlayerDataSection({
    super.key,
    required this.data,
    required this.theme,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.position != null)
                  _buildInfoRow(string.position, data.position!),
                if (data.preferredFoot != null)
                  _buildInfoRow(string.skills, data.preferredFoot!),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.height != null)
                  _buildInfoRow(string.height, '${data.height} cm'),
                if (data.weight != null)
                  _buildInfoRow(string.weight, '${data.weight} kg'),
                if (data.age != null)
                  _buildInfoRow(string.age, '${data.age} ${string.yearsOfExperience0to2.split(' ')[1]}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              value,
              softWrap: true,
              style: TextStyle(
                color: ColorManager.borderCircular,
              ),
              // style: theme.textTheme.bodySmall?.copyWith(
              //   color: theme.colorScheme.primary,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}