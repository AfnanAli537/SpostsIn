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
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/utils/helper/update_profile_build_request_body.dart';

class ScoutEditScreen extends StatefulWidget {
  final ProfileModel profile;

  const ScoutEditScreen({super.key, required this.profile});

  @override
  State<ScoutEditScreen> createState() => _ScoutEditScreenState();
}

class _ScoutEditScreenState extends State<ScoutEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController yearsOfExperienceController;
  late final TextEditingController bioController;

  late final ValueNotifier<String?> sportNameNotifier;
  // late final ValueNotifier<String?> locationNotifier;
  // late final ValueNotifier<String?> genderNotifier;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(
    AutovalidateMode.disabled,
  );

  @override
  void initState() {
    super.initState();
    final scoutData = widget.profile.scoutData!;

    firstNameController = TextEditingController(
      text: widget.profile.name.split(' ').first,
    );
    lastNameController = TextEditingController(
      text: widget.profile.name.split(' ').last,
    );
    yearsOfExperienceController = TextEditingController(
      text: scoutData.yearsOfExperience?.toString() ?? '',
    );
    bioController = TextEditingController(text: widget.profile.description);
    sportNameNotifier = ValueNotifier<String?>(scoutData.specializedSport);
    // locationNotifier = ValueNotifier<String?>(null);
    // genderNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    yearsOfExperienceController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context, S string) async {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int? parsedExperience = int.tryParse(
      yearsOfExperienceController.text.trim(),
    );

    final updateBody = await UpdateProfileBodyBuilder.buildUpdateBody(
      currentProfile: widget.profile,
      newImage: imageNotifier.value,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      bio: bioController.text.trim(),
      // gender: genderNotifier.value,
      // location: locationNotifier.value,
      specialization: sportNameNotifier.value,
      yearsOfExperience: parsedExperience,
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

                          RegisterTwoFieldsRow(
                            leftField: RegisterTextField(
                              controller: firstNameController,
                              labelText: string.firstName,
                              validator: (v) => Validators.validateName(
                                context: context,
                                value: v,
                                fieldName: string.firstName.toLowerCase(),
                              ),
                            ),
                            rightField: RegisterTextField(
                              controller: lastNameController,
                              labelText: string.lastName,
                              validator: (v) => Validators.validateName(
                                context: context,
                                value: v,
                                fieldName: string.lastName.toLowerCase(),
                              ),
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
                          ValueListenableBuilder<String?>(
                            valueListenable: sportNameNotifier,
                            builder: (context, sportName, _) {
                              return AppDropdownOverlay(
                                labelText: string.specializedSport,
                                value: sportName,
                                options: RegisterLists.sportNameOptions(string),
                                onChanged: (val) =>
                                    sportNameNotifier.value = val,
                                validator: (v) => Validators.validateDropdown(
                                  context: context,
                                  value: v,
                                  fieldName: string.specializedSport,
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 16.h),

                          RegisterTextField(
                            controller: yearsOfExperienceController,
                            labelText: string.yearsOfExperience,
                            keyboardType: TextInputType.number,
                            validator: (v) => Validators.validateExperience(
                              context: context,
                              value: v,
                            ),
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
