import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_widget.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _searchController = TextEditingController();

  final Set<String> _selectedIds = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadContactsEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool get _canCreate =>
      _titleController.text.trim().isNotEmpty && _selectedIds.isNotEmpty;

  void _toggleMember(String id) => setState(
    () => _selectedIds.contains(id)
        ? _selectedIds.remove(id)
        : _selectedIds.add(id),
  );

  void _submit() {
    if (!_canCreate) return;
    context.read<ChatBloc>().add(
      CreateGroupEvent(
        title: _titleController.text.trim(),
        memberIds: _selectedIds.toList(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (p, c) =>
          p.isCreatingGroup != c.isCreatingGroup ||
          p.createGroupError != c.createGroupError ||
          p.chats.length != c.chats.length,
      listener: (_, state) {
        if (!state.isCreatingGroup && state.createGroupError == null) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        if (state.createGroupError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.createGroupError!),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGroupPhotoSection(),
                    const SizedBox(height: 20),
                    _buildFieldsSection(),
                    const SizedBox(height: 20),
                    _buildAddMembersSection(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 40,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 18,
          color: Colors.blue,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Create group',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEEF0F5)),
      ),
    );
  }

  Widget _buildGroupPhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: integrate image picker
            },
            child: Stack(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.1),
                        Colors.indigo.withOpacity(0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add group photo',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsSection() {
    return Column(
      children: [
        LabeledTextField(
          label: 'Group name',
          hint: 'Enter group name...',
          controller: _titleController,
          required: true,
        ),
        const SizedBox(height: 14),
        LabeledTextField(
          label: 'Description (optional)',
          hint: "What's this group about?",
          controller: _descController,
        ),
      ],
    );
  }

  Widget _buildAddMembersSection() {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (p, c) =>
          p.contacts != c.contacts || p.contactsLoading != c.contactsLoading,
      builder: (_, state) {
        final filtered = state.contacts
            .where(
              (c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'ADD MEMBERS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                    letterSpacing: 0.6,
                  ),
                ),
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (_selectedIds.isNotEmpty)
                  Text(
                    '${_selectedIds.length} selected',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (_selectedIds.isNotEmpty) ...[
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _selectedIds.map((id) {
                    final c = state.contacts.firstWhere((x) => x.id == id);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        avatar: ChatAvatar(
                          imageUrl: c.avatar,
                          name: c.name,
                          size: 22,
                        ),
                        label: Text(
                          c.name.split(' ').first,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        deleteIcon: const Icon(Icons.close_rounded, size: 14),
                        onDeleted: () => _toggleMember(id),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        deleteIconColor: Colors.blue,
                        labelPadding: const EdgeInsets.only(left: 2),
                        visualDensity: VisualDensity.compact,
                        side: const BorderSide(color: Colors.transparent),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],

            ChatSearchBar(
              controller: _searchController,
              hint: 'Search members...',
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
            const SizedBox(height: 10),

            if (state.contactsLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              ...filtered.map((c) {
                final isSelected = _selectedIds.contains(c.id);
                return GestureDetector(
                  onTap: () => _toggleMember(c.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        ChatAvatar(imageUrl: c.avatar, name: c.name, size: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              if (c.bio != null && c.bio!.isNotEmpty)
                                Text(
                                  c.bio!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 13,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  Widget _buildCreateButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEF0F5))),
      ),
      child: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (p, c) => p.isCreatingGroup != c.isCreatingGroup,
        builder: (_, state) {
          return ValueListenableBuilder(
            valueListenable: _titleController,
            builder: (_, __, ___) {
              final enabled = _canCreate && !state.isCreatingGroup;
              final label = state.isCreatingGroup
                  ? 'Creating...'
                  : _selectedIds.isEmpty
                  ? 'Create group'
                  : 'Create group (${_selectedIds.length})';
              return PrimaryGradientButton(
                label: label,
                enabled: enabled,
                onTap: enabled ? _submit : null,
              );
            },
          );
        },
      ),
    );
  }
}
