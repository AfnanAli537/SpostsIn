import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/core/constants/color_manager.dart';
// import 'package:sports_in/core/mappers/enum_mapper.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_state.dart';
// import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_two_fields_row.dart';
// import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';

class OtherEditScreen extends StatefulWidget {
  final ProfileModel profile;

  const OtherEditScreen({super.key, required this.profile});

  @override
  State<OtherEditScreen> createState() => _OtherEditScreenState();
}

class _OtherEditScreenState extends State<OtherEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController bioController;

  // late final ValueNotifier<String?> genderNotifier;
  // late final ValueNotifier<String?> locationNotifier;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(
    AutovalidateMode.disabled,
  );

  @override
  void initState() {
    super.initState();

    final nameParts = widget.profile.name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    bioController = TextEditingController(text: widget.profile.description);
    // genderNotifier = ValueNotifier(
    //   EnumMapper.genderIdToLabel(widget.profile.otherData!.gender ?? 0),
    // );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    // genderNotifier.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context, S string) {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;

    if (!_formKey.currentState!.validate()) return;

    context.read<ProfileBloc>().add(
      UpdateProfile(
        currentProfile: widget.profile,
        newImage: imageNotifier.value,
        oldImage: widget.profile.profileImage,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        // gender: genderNotifier.value,
        bio: bioController.text.trim(),
        // location: locationNotifier.value,
      ),
    );
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
              msg: string.editProfileSuccess,
              backgroundColor: ColorManager.success,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
            // Navigator.pop(context);
          }

          if (state is ProfileError) {
            Fluttertoast.showToast(
              msg: state.message,
              backgroundColor: ColorManager.error,
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
                          // SizedBox(height: 16.h),

                          // ValueListenableBuilder<String?>(
                          //   valueListenable: genderNotifier,
                          //   builder: (context, gender, _) {
                          //     return AppDropdownOverlay(
                          //       labelText: string.gender,
                          //       value: gender,
                          //       options: RegisterLists.genderOptions(string),
                          //       onChanged: (val) => genderNotifier.value = val,
                          //       validator: (v) => Validators.validateDropdown(
                          //         context: context,
                          //         value: v,
                          //         fieldName: string.gender.toLowerCase(),
                          //       ),
                          //     );
                          //   },
                          // ),

                          SizedBox(height: 24.h),

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
