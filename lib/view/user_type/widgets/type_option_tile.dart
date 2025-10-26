import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class TypeOptionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const TypeOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.lightAccent : ColorManager.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorManager.grey),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            Expanded(child: Text(label, style: TextStyle(color: ColorManager.black, fontSize: 16),)),
            if (isSelected)
              const Icon(Icons.radio_button_checked, color: ColorManager.black)
            else
              const Icon(Icons.radio_button_off, color: ColorManager.grey),
          ],
        ),
      ),
    );
  }
}
