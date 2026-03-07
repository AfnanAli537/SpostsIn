import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/utils/helper/update_profile_build_request_body.dart';

class InstituteEditScreen extends StatefulWidget {
  final ProfileModel profile;

  const InstituteEditScreen({super.key, required this.profile});

  @override
  State<InstituteEditScreen> createState() => _InstituteEditScreenState();
}

class _InstituteEditScreenState extends State<InstituteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController instituteNameController;
  late final TextEditingController industryController;
  late final TextEditingController bioController;
  // late final ValueNotifier<String?> locationNotifier;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(
    AutovalidateMode.disabled,
  );

  @override
  void initState() {
    super.initState();
    final instituteData = widget.profile.instituteData!;
    
    instituteNameController = TextEditingController(text: widget.profile.name);
    industryController = TextEditingController(text: instituteData.industry);
    bioController = TextEditingController(text: widget.profile.description);
    // locationNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    instituteNameController.dispose();
    industryController.dispose();
    bioController.dispose();
    imageNotifier.dispose();
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
      oldImage: widget.profile.profileImage,
      instituteName: instituteNameController.text.trim(),
      bio: bioController.text.trim(),
      // location: locationNotifier.value,
      industry: industryController.text.trim(),
    );

    context.read<ProfileBloc>().add(UpdateProfile(updateData: updateBody));
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(string.editProfile),
      ),
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
                            onImageSelected: (img) =>
                                imageNotifier.value = img,
                          ),
                          SizedBox(height: 24.h),

                          RegisterTextField(
                            controller: instituteNameController,
                            labelText: string.instituteName,
                            validator: (v) => Validators.validateName(
                              context: context,
                              value: v,
                              fieldName: string.instituteName.toLowerCase(),
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

                          RegisterTextField(
                            controller: industryController,
                            labelText: string.industary,
                            validator: (v) => Validators.validateName(
                              context: context,
                              value: v,
                              fieldName: string.industary.toLowerCase(),
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