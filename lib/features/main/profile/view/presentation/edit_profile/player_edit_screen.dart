import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/utils/validators/regex.dart';
import 'package:sports_in/core/widgets/app_image_picker.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_state.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_text_field.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/register_two_fields_row.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:sports_in/core/utils/helper/update_profile_build_request_body.dart';


class PlayerEditScreen extends StatefulWidget {
  final ProfileModel profile;

  const PlayerEditScreen({super.key, required this.profile});

  @override
  State<PlayerEditScreen> createState() => _PlayerEditScreenState();
}

class _PlayerEditScreenState extends State<PlayerEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController heightController;
  late final TextEditingController weightController;
  late final TextEditingController ageController;
  late final TextEditingController bioController;

  late final ValueNotifier<String?> genderNotifier;
  late final ValueNotifier<String?> locationNotifier;
  late final ValueNotifier<String?> sportNameNotifier;
  late final ValueNotifier<String?> positionNotifier;
  late final ValueNotifier<bool> hasClubNotifier;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);
  
  final autoValidateNotifier = ValueNotifier<AutovalidateMode>(AutovalidateMode.disabled);

  @override
  void initState() {
    super.initState();
    final playerData = widget.profile.playerData!;
    
    firstNameController = TextEditingController(text: widget.profile.name.split(' ').first);
    lastNameController = TextEditingController(text: widget.profile.name.split(' ').last);
    heightController = TextEditingController(text: playerData.height?.toString() ?? '');
    weightController = TextEditingController(text: playerData.weight?.toString() ?? '');
    ageController = TextEditingController(text: playerData.age?.toString() ?? '');
    bioController = TextEditingController(text: widget.profile.description);
    // genderNotifier = ValueNotifier<String?>(null);
    // locationNotifier = ValueNotifier<String?>(null);
    sportNameNotifier = ValueNotifier<String?>(playerData.specializedSport);
    positionNotifier = ValueNotifier<String?>(playerData.position);
    // hasClubNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    bioController.dispose();
    sportNameNotifier.dispose();
    positionNotifier.dispose();
    super.dispose();
  }

  void _onSportChanged(String? selectedSport, S string) {
    sportNameNotifier.value = selectedSport;
    if (!RegisterLists.isTeamSport(string, selectedSport)) {
      positionNotifier.value = null;
    }
  }

  void _onUpdate(BuildContext context, S string) async {
    autoValidateNotifier.value = AutovalidateMode.onUserInteraction;
    
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int? parsedHeight = int.tryParse(heightController.text.trim());
    final int? parsedWeight = int.tryParse(weightController.text.trim());
    final int? parsedAge = int.tryParse(ageController.text.trim());

    final updateBody = await UpdateProfileBodyBuilder.buildUpdateBody(
      currentProfile: widget.profile,
      newImage: imageNotifier.value,
      oldImage: widget.profile.profileImage,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      height: parsedHeight,
      weight: parsedWeight,
      age: parsedAge,
      bio: bioController.text.trim(),
      // gender: genderNotifier.value,
      // location: locationNotifier.value,
      sports: sportNameNotifier.value != null ? [sportNameNotifier.value!] : null,
      position: positionNotifier.value,
      // hasClub: hasClubNotifier.value,
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

                          RegisterTwoFieldsRow(
                            leftField: RegisterTextField(
                              controller: heightController,
                              labelText: string.height,
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.validateHeight(
                                context: context,
                                value: v,
                              ),
                            ),
                            rightField: RegisterTextField(
                              controller: weightController,
                              labelText: string.weight,
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.validateWeight(
                                context: context,
                                value: v,
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          RegisterTextField(
                              controller: ageController,
                              labelText: string.age,
                              keyboardType: TextInputType.number,
                              validator: (v) => Validators.validateAge(
                                context: context,
                                value: v,
                              ),
                            ),

                          SizedBox(height: 16.h),

                          ValueListenableBuilder<String?>(
                            valueListenable: sportNameNotifier,
                            builder: (context, sport, _) {
                              return AppDropdownOverlay(
                                labelText: string.sportProfession,
                                value: sport,
                                options: RegisterLists.sportNameOptions(string),
                                onChanged: (val) => _onSportChanged(val, string),
                                validator: (v) => Validators.validateDropdown(
                                  context: context,
                                  value: v,
                                  fieldName: string.sportProfession.toLowerCase(),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 16.h),

                          ValueListenableBuilder<String?>(
                            valueListenable: sportNameNotifier,
                            builder: (context, sport, _) {
                              if (!RegisterLists.isTeamSport(string, sport)) {
                                return const SizedBox.shrink();
                              }
                              return ValueListenableBuilder<String?>(
                                valueListenable: positionNotifier,
                                builder: (context, position, _) {
                                  return AppDropdownOverlay(
                                    labelText: string.position,
                                    value: position,
                                    options: RegisterLists.positionOptions(string, sport),
                                    onChanged: (val) => positionNotifier.value = val,
                                    validator: (v) => Validators.validateDropdown(
                                      context: context,
                                      value: v,
                                      fieldName: string.position.toLowerCase(),
                                    ),
                                  );
                                },
                              );
                            },
                          ),

                          ValueListenableBuilder<String?>(
                            valueListenable: sportNameNotifier,
                            builder: (context, sport, _) {
                              if (!RegisterLists.isTeamSport(string, sport)) {
                                return const SizedBox.shrink();
                              }
                              return SizedBox(height: 20.h);
                            },
                          ),


                          SizedBox(height: 12.h),

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