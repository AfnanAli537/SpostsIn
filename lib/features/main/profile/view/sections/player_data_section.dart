import 'package:flutter/material.dart';
import '../../model/profile_model.dart';

class PlayerDataSection extends StatelessWidget {
  final PlayerSpecificData data;

  const PlayerDataSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.position != null)
                  _buildInfoRow('Position', data.position!),
                if (data.preferredFoot != null)
                  _buildInfoRow('Skills', data.preferredFoot!),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Second Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.height != null)
                  _buildInfoRow('Height', '${data.height} cm'),
                if (data.weight != null)
                  _buildInfoRow('Weight', '${data.weight} kg'),
                if (data.age != null)
                  _buildInfoRow('Age', '${data.age} years old'),
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
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255,71, 89, 24),
            ),
          ),
        ),
      ],
    ),
  );
}

}