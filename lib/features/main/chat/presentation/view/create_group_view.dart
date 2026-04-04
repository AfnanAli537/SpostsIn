import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/chat/data/models/contact_model.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key});

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Set<String> _selectedMemberIds = {};

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.isCreatingGroup != current.isCreatingGroup ||
          previous.createGroupError != current.createGroupError,
      listener: (context, state) {
        final hasError =
            (state.createGroupError != null &&
            state.createGroupError!.isNotEmpty);

        if (hasError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.createGroupError!)));
          return;
        }

        if (!state.isCreatingGroup) {
          Navigator.of(context).maybePop();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Create group',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Group name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Members',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (p, c) =>
                    p.contacts != c.contacts ||
                    p.contactsLoading != c.contactsLoading,
                builder: (context, state) {
                  if (state.contactsLoading && state.contacts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.contacts.isEmpty) {
                    return const Center(child: Text('No contacts available'));
                  }

                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = state.contacts[index];
                        final isSelected = _selectedMemberIds.contains(
                          contact.id,
                        );
                        return _ContactItem(
                          contact: contact,
                          isSelected: isSelected,
                          onToggle: () {
                            setState(() {
                              if (isSelected) {
                                _selectedMemberIds.remove(contact.id);
                              } else {
                                _selectedMemberIds.add(contact.id);
                              }
                            });
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (p, c) =>
                  p.isCreatingGroup != c.isCreatingGroup ||
                  p.createGroupError != c.createGroupError,
              builder: (context, state) {
                final canSubmit =
                    _titleController.text.trim().isNotEmpty &&
                    _selectedMemberIds.isNotEmpty &&
                    !state.isCreatingGroup;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canSubmit
                        ? () {
                            FocusScope.of(context).unfocus();
                            context.read<ChatBloc>().add(
                              CreateGroupEvent(
                                title: _titleController.text.trim(),
                                memberIds: _selectedMemberIds.toList(),
                                description:
                                    _descriptionController.text.trim().isEmpty
                                    ? null
                                    : _descriptionController.text.trim(),
                              ),
                            );
                          }
                        : null,
                    child: state.isCreatingGroup
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Create',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.contact,
    required this.isSelected,
    required this.onToggle,
  });

  final ContactModel contact;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggle,
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey.shade100,
        child: Text(
          contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.black87),
        ),
      ),
      title: Text(contact.name),
      subtitle: contact.bio != null && contact.bio!.isNotEmpty
          ? Text(contact.bio!)
          : null,
      trailing: Checkbox(value: isSelected, onChanged: (_) => onToggle()),
    );
  }
}

void showCreateGroupBottomSheet(BuildContext context) {
  final chatBloc = context.read<ChatBloc>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
    ),
    builder: (sheetContext) =>
        BlocProvider.value(value: chatBloc, child: const CreateGroupView()),
  );
}
