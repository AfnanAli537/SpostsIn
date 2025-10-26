import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class AppDropdownOverlay extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const AppDropdownOverlay({
    super.key,
    required this.hintText,
    required this.value,
    required this.options,
    required this.onChanged,
    this.errorText,
  });

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          GestureDetector(
            onTap: () => entry?.remove(),
            child: Container(color: Colors.black54),
          ),
          Center(
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: options.map((opt) {
                    final isSelected = value == opt;
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        onChanged(opt);
                        entry?.remove();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorManager.darkAccent
                              : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            opt,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: Radio<String>(
                            value: opt,
                            groupValue: value,
                            activeColor: ColorManager.lightPrimary,
                            onChanged: (val) {
                              onChanged(val!);
                              entry?.remove();
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showOverlay(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorManager.darkAccent1,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hintText,
                    style: TextStyle(
                      color: value == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: ColorManager.lightPrimary,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
