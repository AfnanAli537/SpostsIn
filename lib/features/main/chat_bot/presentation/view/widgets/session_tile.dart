// import 'package:flutter/material.dart';
// import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';

// class SessionTile extends StatelessWidget {
//   final ChatSession session;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;
//   final ValueChanged<String> onRename;

//   const SessionTile({
//     super.key,
//     required this.session,
//     required this.onTap,
//     required this.onDelete,
//     required this.onRename,
//   });

//   void _showRenameDialog(BuildContext context) {
//     final controller = TextEditingController(text: session.sessionName);
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Rename Chat'),
//         content: TextField(
//           controller: controller,
//           autofocus: true,
//           decoration: const InputDecoration(hintText: 'Enter new name'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               final name = controller.text.trim();
//               if (name.isNotEmpty) onRename(name);
//               Navigator.pop(context);
//             },
//             child: const Text('Rename'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Avatar
//             CircleAvatar(
//               radius: 22,
//               backgroundColor: const Color(0xFF1A1A2E),
//               child: const Text(
//                 'S',
//                 style: TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Session info
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           session.sessionName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF1A1A2E),
//                             fontSize: 14,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Text(
//                         _formatDate(session.createdAt),
//                         style: const TextStyle(
//                           color: Colors.grey,
//                           fontSize: 11,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 3),
//                   const Text(
//                     "I'm glad to read a book...",
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),

//             // Actions
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.more_vert,
//                   color: Colors.grey, size: 20),
//               onSelected: (value) {
//                 if (value == 'rename') _showRenameDialog(context);
//                 if (value == 'delete') onDelete();
//               },
//               itemBuilder: (_) => const [
//                 PopupMenuItem(value: 'rename', child: Text('Rename')),
//                 PopupMenuItem(
//                     value: 'delete',
//                     child: Text('Delete',
//                         style: TextStyle(color: Colors.red))),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return '${months[date.month - 1]} ${date.day}, ${date.year}';
//   }
// }



import 'package:flutter/material.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';

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
    // ✅ Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Chat'),
        content: const Text('Are you sure you want to delete this chat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // ✅ Show inline loading while bloc processes
    if (mounted) setState(() => _isLoading = true);
    widget.onDelete();
    // Loading will clear when parent rebuilds with new SessionDeleted state
  }

  Future<void> _handleRename() async {
    final controller =
        TextEditingController(text: widget.session.sessionName);

    final newName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Enter new name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onSubmitted: (v) => Navigator.pop(context, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, controller.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty) return;
    if (newName == widget.session.sessionName) return;

    // ✅ Show inline loading while bloc processes
    if (mounted) setState(() => _isLoading = true);
    widget.onRename(newName);
    // Loading will clear when parent rebuilds with new SessionRenamed state
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            // ─── Avatar ────────────────────────────────────────────────
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFF1A1A2E),
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'S',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(width: 12),

            // ─── Session Info ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.session.sessionName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(widget.session.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    "Tap to continue this chat...",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ─── Actions Menu ───────────────────────────────────────────
            if (!_isLoading)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    color: Colors.grey, size: 20),
                onSelected: (value) {
                  if (value == 'rename') _handleRename();
                  if (value == 'delete') _handleDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined,
                            size: 18, color: Color(0xFF1A1A2E)),
                        SizedBox(width: 8),
                        Text('Rename'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline,
                            size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete',
                            style: TextStyle(color: Colors.red)),
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