import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';
import 'package:sports_in/generated/l10n.dart';

class SessionTile extends StatefulWidget {
  final ChatSession session;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<String> onRename;

  const SessionTile({
    super.key,
    required this.session,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
  });

  @override
  State<SessionTile> createState() => _SessionTileState();
}

class _SessionTileState extends State<SessionTile> {
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).deleteChat),
        content: Text(S.of(context).deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (mounted) setState(() => _isLoading = true);
    widget.onDelete();
  }

  Future<void> _handleRename() async {
    final controller = TextEditingController(text: widget.session.sessionName);

    final newName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).renameChat),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: S.of(context).enterNewName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(context, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(S.of(context).rename),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty) return;
    if (newName == widget.session.sessionName) return;

    if (mounted) setState(() => _isLoading = true);
    widget.onRename(newName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44.w,
              height: 44.h,
              child: _isLoading
                  ?  Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        // color: Color(0xFF1A1A2E),
                        color: Theme.of(context).colorScheme.primary
                      ),
                    )
                  : Image.asset(
                      'assets/images/chatbot_robot.png',
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.session.sessionName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            // color: const Color(0xFF1A1A2E),
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(widget.session.createdAt),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    S.of(context).tapToContinue,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (!_isLoading)
              PopupMenuButton<String>(

                icon: Icon(Icons.more_vert, color: Colors.grey, size: 20.sp),
                onSelected: (value) {
                  if (value == 'rename') _handleRename();
                  if (value == 'delete') _handleDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined,
                            size: 18.sp,
                            //  color: const Color(0xFF1A1A2E)
                            color: Theme.of(context).colorScheme.primary
                             ),
                        SizedBox(width: 8.w),
                        Text(S.of(context).rename,
                            style: TextStyle(fontSize: 13.sp)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 18.sp, color: Colors.red),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).delete,
                          style: TextStyle(color: Colors.red, fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}