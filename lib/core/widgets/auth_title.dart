import 'package:flutter/material.dart';
class AuthTitle extends StatelessWidget {
  final String  title;
  final String? subtitle;
  final String? hintDesc;

  const AuthTitle({super.key, required this.title, this.subtitle, this.hintDesc});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: textTheme.displaySmall),
       if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
        ],
        if (hintDesc != null) ...[
          const SizedBox(height: 20),
          Text(hintDesc!,
              textAlign: TextAlign.center,
           style: textTheme.bodySmall?.copyWith(color: ColorScheme.of(context).onSurface.withOpacity(0.40))
         ),
        ],
        Row(),
      ],
    );
  }
}
