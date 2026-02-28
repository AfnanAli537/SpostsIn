import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
import 'package:sports_in/features/main/chat/view/widgets/chat_widget.dart';
import 'package:sports_in/features/main/chat/view/widgets/theme.dart';
import 'package:sports_in/features/main/chat/view_model/bloc/chat_bloc.dart';

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
  String _privacyOption = 'public';
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

  void _toggleMember(String id) =>
      setState(() => _selectedIds.contains(id) ? _selectedIds.remove(id) : _selectedIds.add(id));

  void _submit() {
    if (!_canCreate) return;
    context.read<ChatBloc>().add(CreateGroupEvent(
          title: _titleController.text.trim(),
          memberIds: _selectedIds.toList(),
          description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (p, c) =>
          p.groupCreated != c.groupCreated || p.createGroupError != c.createGroupError,
      listener: (_, state) {
        if (state.groupCreated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group created successfully! 🎉'),
              backgroundColor: ChatColors.online,
            ),
          );
        }
        if (state.createGroupError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.createGroupError!),
              backgroundColor: ChatColors.danger,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ChatColors.background,
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
                    const SizedBox(height: 20),
                    _buildPrivacySection(),
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
      backgroundColor: ChatColors.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 40,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: ChatColors.primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Create group',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w800, color: ChatColors.textPrimary)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: ChatColors.border),
      ),
    );
  }

  Widget _buildGroupPhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: pick image with image_picker
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
                        ChatColors.primary.withOpacity(0.1),
                        ChatColors.primaryDark.withOpacity(0.15)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                        color: ChatColors.primary.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: ChatColors.primary, size: 28),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ChatColors.primary,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Add group photo',
              style: TextStyle(fontSize: 12, color: ChatColors.textMuted)),
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
            .where((c) =>
                c.userName.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('ADD MEMBERS', style: ChatTextStyles.sectionLabel),
                const Text(' *',
                    style: TextStyle(
                        color: ChatColors.danger,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                if (_selectedIds.isNotEmpty)
                  Text('${_selectedIds.length} selected',
                      style: const TextStyle(
                          fontSize: 12,
                          color: ChatColors.primary,
                          fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),

            // Selected chips
            if (_selectedIds.isNotEmpty) ...[
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _selectedIds.map((id) {
                    final c = state.contacts.firstWhere((x) => x.userId == id,
                        orElse: () => ChatMemberModel(userId: id, userName: id, isAdmin: true));
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        avatar: ChatAvatar(imageUrl: c.avatar, name: c.userName, size: 22),
                        label: Text(c.userName.split(' ').first,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        deleteIcon: const Icon(Icons.close_rounded, size: 14),
                        onDeleted: () => _toggleMember(id),
                        backgroundColor: ChatColors.primary.withOpacity(0.1),
                        deleteIconColor: ChatColors.primary,
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
              const Center(child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ))
            else
              ...filtered.map((c) {
                final isSelected = _selectedIds.contains(c.userId);
                return GestureDetector(
                  onTap: () => _toggleMember(c.userId),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ChatColors.primary.withOpacity(0.06)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? ChatColors.primary.withOpacity(0.3)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        ChatAvatar(imageUrl: c.avatar, name: c.userName, size: 42),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.userName,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: ChatColors.textPrimary)),
                              if (c.bio != null)
                                Text(c.bio!,
                                    style: const TextStyle(
                                        fontSize: 12, color: ChatColors.textMuted)),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? ChatColors.primary : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? ChatColors.primary : ChatColors.textMuted,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
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

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('VISIBLE TO', style: ChatTextStyles.sectionLabel),
        const SizedBox(height: 8),
        Row(
          children: [
            _PrivacyOption(
                label: 'Public',
                value: 'public',
                selected: _privacyOption,
                onTap: (v) => setState(() => _privacyOption = v)),
            const SizedBox(width: 8),
            _PrivacyOption(
                label: 'Friends',
                value: 'friends',
                selected: _privacyOption,
                onTap: (v) => setState(() => _privacyOption = v)),
            const SizedBox(width: 8),
            _PrivacyOption(
                label: 'Specialty',
                value: 'specialty',
                selected: _privacyOption,
                onTap: (v) => setState(() => _privacyOption = v)),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: ChatColors.surface,
        border: Border(top: BorderSide(color: ChatColors.border)),
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

class _PrivacyOption extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;

  const _PrivacyOption(
      {required this.label,
      required this.value,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? ChatColors.primary.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? ChatColors.primary : ChatColors.border,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? ChatColors.primary : ChatColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}