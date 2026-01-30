import 'package:flutter/material.dart';
import '../../model/profile_model.dart';

class InstituteDataSection extends StatelessWidget {
  final InstituteSpecificData data;

  const InstituteDataSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.accreditation != null)
            _buildInfoRow('Industry', data.accreditation!),
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
                color: Color.fromARGB(255, 71, 89, 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}