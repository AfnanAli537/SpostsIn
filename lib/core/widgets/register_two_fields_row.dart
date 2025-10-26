import 'package:flutter/material.dart';

class RegisterTwoFieldsRow extends StatelessWidget {
  final Widget leftField;
  final Widget? rightField; // optional

  const RegisterTwoFieldsRow({
    Key? key,
    required this.leftField,
    this.rightField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: leftField),
        const SizedBox(width: 10),
        Expanded(
          child: rightField ?? const SizedBox.shrink(), // empty space if null
        ),
      ],
    );
  }
}
