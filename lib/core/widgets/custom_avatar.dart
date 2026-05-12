import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';


// ── Connection Request Card ──────────────────────────────────────────────────
class ConnectionRequestTile extends StatelessWidget {
  final String id;
  final String fullName;
  final String? profilePictureUrl;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ConnectionRequestTile({
    super.key,
    required this.id,
    required this.fullName,
    this.profilePictureUrl,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          CustomAvatar(imageUrl: profilePictureUrl, name: fullName),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  strings.wantsToConnect,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _SmallActionButton(label: strings.accept, isPrimary: true, onPressed: onAccept),
          SizedBox(width: 6.w),
          _SmallActionButton(label: strings.reject, isPrimary: false, onPressed: onReject),
        ],
      ),
    );
  }
}

// ── Contact Item Tile ────────────────────────────────────────────────────────
class ContactListTile extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool isOnline;
  final VoidCallback onTap;

  const ContactListTile({
    super.key,
    required this.title,
    this.imageUrl,
    this.isOnline = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Stack(
              children: [
                CustomAvatar(imageUrl: imageUrl, name: title),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 11.w,
                      height: 11.w,
                      decoration: BoxDecoration(
                        color: Colors.green, // Or ColorManager.success
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isOnline)
              Text(
                strings.online,
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double? radius;

  const CustomAvatar({super.key, this.imageUrl, required this.name, this.radius});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return CircleAvatar(
      radius: radius ?? 22.r,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
      backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty) 
          ? NetworkImage(imageUrl!) 
          : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Text(initials,
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: (radius ?? 22.r) * 0.7))
          : null,
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _SmallActionButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isPrimary) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          minimumSize: Size(60.w, 32.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label, style: TextStyle(fontSize: 12.sp)),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        minimumSize: Size(60.w, 32.h),
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12.sp)),
    );
  }
}