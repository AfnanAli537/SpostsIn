import 'package:flutter/material.dart';
import '../../model/profile_model.dart';

class PlayerDataSection extends StatelessWidget {
  final PlayerSpecificData data;

  const PlayerDataSection({
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
          if (data.position != null)
            _buildInfoRow('Position', data.position!),
          if (data.age != null)
            _buildInfoRow('Age', '${data.age} years old'),
          if (data.height != null)
            _buildInfoRow('Height', '${data.height} cm'),
          if (data.weight != null)
            _buildInfoRow('Weight', '${data.weight} kg'),
          if (data.preferredFoot != null)
            _buildInfoRow('Skills', 
              'Shooting, Heading, Passing, ${data.preferredFoot}'),
          if (data.yearsOfExperience != null)
            _buildInfoRow('Years of experience', 
              data.yearsOfExperience.toString()),
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