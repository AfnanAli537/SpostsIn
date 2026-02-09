import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/DatePickerTextField.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/checkbox_dropdown_overlay.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/utils/helper/update_profile_build_request_body.dart';

class ClubEditScreen extends StatefulWidget {
  final ProfileModel profile;

  const ClubEditScreen({super.key, required this.profile});

  @override
  State<ClubEditScreen> createState() => _ClubEditScreenState();
}

class _ClubEditScreenState extends State<ClubEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController clubNameController;
  late final TextEditingController foundDateController;
  late final TextEditingController bioController;
  late final ValueNotifier<String?> locationNotifier;
  late final ValueNotifier<List<String>> selectedSportsNotifier;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(
    AutovalidateMode.disabled,
  );

  @override
  void initState() {
    super.initState();
    final clubData = widget.profile.clubData!;

    clubNameController = TextEditingController(text: widget.profile.name);
    foundDateController = TextEditingController(text: clubData.foundedYear);
    bioController = TextEditingController(text: widget.profile.description);
    // locationNotifier = ValueNotifier<String?>(null);
    selectedSportsNotifier = ValueNotifier<List<String>>([]);
  }

  @override
  void dispose() {
    clubNameController.dispose();
    foundDateController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context, S string) async {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updateBody = await UpdateProfileBodyBuilder.buildUpdateBody(
      currentProfile: widget.profile,
      newImage: imageNotifier.value,
      clubName: clubNameController.text.trim(),
      bio: bioController.text.trim(),
      // location: locationNotifier.value,
      foundationDate: foundDateController.text.trim(),
      sports: selectedSportsNotifier.value,
    );

    context.read<ProfileBloc>().add(UpdateProfile(updateData: updateBody));
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(string.editProfile)),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            Fluttertoast.showToast(
              msg: 'Profile updated successfully',
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
            Navigator.pop(context);
          }

          if (state is ProfileError) {
            Fluttertoast.showToast(
              msg: state.message,
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: ValueListenableBuilder<AutovalidateMode>(
                  valueListenable: autoValidateNotifier,
                  builder: (context, autoValidateMode, _) {
                    return Form(
                      key: _formKey,
                      autovalidateMode: autoValidateMode,
                      child: Column(
                        children: [
                          AppImagePicker(
                            initialImage: widget.profile.profileImage,
                            onImageSelected: (img) => imageNotifier.value = img,
                          ),
                          SizedBox(height: 24.h),

                          RegisterTextField(
                            controller: clubNameController,
                            labelText: string.clubName,
                            validator: (v) => Validators.validateName(
                              context: context,
                              value: v,
                              fieldName: string.clubName.toLowerCase(),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // ✅ Bio/Description Field
                          RegisterTextField(
                            controller: bioController,
                            labelText: string.bio,
                            maxLines: 4,
                            // validator: (v) {
                            //   if (v == null || v.trim().isEmpty) {
                            //     return 'Please enter a bio';
                            //   }
                            //   return null;
                            // },
                          ),
                          SizedBox(height: 16.h),

                          DatePickerTextField(
                            controller: foundDateController,
                            labelText: string.foundDate,
                            validator: (v) => Validators.validateDate(
                              context: context,
                              value: v,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          ValueListenableBuilder<List<String>>(
                            valueListenable: selectedSportsNotifier,
                            builder: (context, selectedSports, _) {
                              return CheckboxDropdownOverlay(
                                labelText: string.selectSports,
                                value: selectedSports,
                                options: RegisterLists.sportNameOptions(string),
                                validator: (v) => Validators.validateList(
                                  context: context,
                                  value: v,
                                  fieldName: string.sportProfession,
                                ),
                                onChanged: (selected) =>
                                    selectedSportsNotifier.value = selected,
                              );
                            },
                          ),

                          SizedBox(height: 20.h),

                          BlocBuilder<ProfileBloc, ProfileState>(
                            builder: (context, state) {
                              final isLoading = state is ProfileLoading;

                              return CustomElevatedButton(
                                text: isLoading ? string.loading : string.save,
                                isLoading: isLoading,
                                enabled: !isLoading, // ✅ Disable during loading
                                onPressed: () => _onUpdate(context, string),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
