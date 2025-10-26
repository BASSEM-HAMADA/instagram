import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/Data/Model_profile-edit.dart';
import 'package:untitled6/Logic_profile_edit/cubit.dart';
import 'package:untitled6/Logic_profile_edit/state.dart';
import 'package:untitled6/ui/home_page.dart';

class InstagramProfileEdit extends StatefulWidget {
  const InstagramProfileEdit({super.key});

  @override
  State<InstagramProfileEdit> createState() => _InstagramProfileEditState();
}

class _InstagramProfileEditState extends State<InstagramProfileEdit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileEditCubit>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ الحصول على أبعاد الشاشة
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocConsumer<ProfileEditCubit, ProfileEditState>(
      listener: (context, state) {
        if (state is ProfileEditSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage)),
          );
        } else if (state is ProfileEditErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ProfileValidationErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.validationMessage),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileEditCubit>();
        final profile = _getProfileFromState(state);
        final isLoading = state is ProfileEditLoadingState ||
            state is ProfileEditUpdatingState ||
            state is ProfileImageUploadingState;

        if (state is ProfileEditLoadingState && profile.name.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: height * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====== AppBar Row ======
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04, vertical: height * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            cubit.cancelEditing();
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w600),
                        ),
                        InkWell(
                          onTap: isLoading
                              ? null
                              : () async {
                            await cubit.saveProfile();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Text(
                              'Done',
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w500,
                                color: isLoading
                                    ? Colors.grey
                                    : const Color.fromRGBO(56, 151, 240, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // ====== Profile Image ======
                  Center(
                    child: Stack(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(width * 0.3),
                          onTap:
                          isLoading ? null : () => cubit.pickProfileImage(),
                          child: CircleAvatar(
                            radius: width * 0.15, // ✅ نسبي لحجم الشاشة
                            backgroundImage: _getProfileImage(profile),
                          ),
                        ),
                        if (state is ProfileImageUploadingState)
                          Positioned.fill(
                            child: CircleAvatar(
                              radius: width * 0.15,
                              backgroundColor: Colors.black54,
                              child: const CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // ====== Change Profile Photo Button ======
                  Center(
                    child: TextButton(
                      onPressed:
                      isLoading ? null : () => cubit.pickProfileImage(),
                      child: Text(
                        "Change Profile Photo",
                        style: TextStyle(
                          color: const Color.fromRGBO(56, 151, 240, 1),
                          fontSize: width * 0.04,
                        ),
                      ),
                    ),
                  ),

                  // ====== Editable Fields ======
                  _buildRow(context, "Name", profile.name, cubit, width, height),
                  _buildRow(
                      context, "Username", profile.username, cubit, width, height),
                  _buildRow(
                      context, "Website", profile.website, cubit, width, height),
                  _buildRow(context, "Bio", profile.bio, cubit, width, height),

                  SizedBox(height: height * 0.03),

                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: Text(
                      'Switch to Professional Account',
                      style: TextStyle(
                        color: const Color.fromRGBO(56, 151, 240, 1),
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  Padding(
                    padding: EdgeInsets.only(left: width * 0.05),
                    child: Text(
                      'Private Information',
                      style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  _buildRow(
                      context, "Email", profile.email, cubit, width, height),
                  _buildRow(
                      context, "Phone", profile.phone, cubit, width, height),
                  _buildRow(
                      context, "Gender", profile.gender, cubit, width, height),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ProfileModel _getProfileFromState(ProfileEditState state) {
    if (state is ProfileEditLoadedState) return state.profile;
    if (state is ProfileEditUpdatingState) return state.profile;
    if (state is ProfileEditSuccessState) return state.profile;
    if (state is ProfileEditErrorState && state.profile != null) {
      return state.profile!;
    }
    if (state is ProfileImageUploadingState) return state.profile;
    if (state is ProfileImageUploadedState) return state.profile;
    if (state is ProfileValidationErrorState) return state.profile;
    return ProfileModel.empty();
  }

  ImageProvider _getProfileImage(ProfileModel profile) {
    if (profile.profileImageFile != null) {
      return FileImage(profile.profileImageFile!);
    } else if (profile.profileImageUrl != null &&
        profile.profileImageUrl!.isNotEmpty) {
      return NetworkImage(profile.profileImageUrl!);
    } else {
      return const NetworkImage(
          'https://via.placeholder.com/150/CCCCCC/FFFFFF?text=Profile');
    }
  }

  Widget _buildRow(BuildContext context, String label, String value,
      ProfileEditCubit cubit, double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.05, vertical: height * 0.01),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.22, // ✅ بدل 80 ثابتة
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: SizedBox(
              height: height * 0.06, // ✅ بدل 48 ثابتة
              child: TextFormField(
                key: ValueKey('${label}_$value'),
                initialValue: value,
                onChanged: (newValue) => cubit.updateField(label, newValue),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: width * 0.025),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
