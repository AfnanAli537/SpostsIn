import 'package:flutter/material.dart';
import '../../model/profile_model.dart';

class CoachDataSection extends StatelessWidget {
  final CoachSpecificData data;

  const CoachDataSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.specializedSport != null)
            _buildInfoRow('Specialized sport', data.specializedSport!),
          if (data.age != null)
            _buildInfoRow('Age', '${data.age} years old'),
          if (data.yearsOfExperience != null)
            _buildInfoRow('Years of experience', 
              data.yearsOfExperience.toString()),
          if (data.certifications != null)
            _buildInfoRow('Certifications', data.certifications!),
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
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}