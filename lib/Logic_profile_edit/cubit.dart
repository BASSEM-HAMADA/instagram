import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled6/Data/Model_profile-edit.dart';
import 'package:untitled6/Logic_profile_edit/state.dart';

class ProfileEditCubit extends Cubit<ProfileEditState> {
  final SupabaseClient _supabase;
  final ImagePicker _imagePicker = ImagePicker();
  ProfileModel _currentProfile = ProfileModel.empty();

  ProfileEditCubit(this._supabase) : super(ProfileEditInitialState());

  ProfileModel get currentProfile => _currentProfile;

  // تحميل البروفايل
  Future<void> loadProfile() async {
    try {
      emit(ProfileEditLoadingState());
      final user = _supabase.auth.currentUser;

      if (user == null) {
        emit( ProfileEditErrorState('User not authenticated'));
        return;
      }

      final response =
      await _supabase.from('profiles').select().eq('id', user.id).single();

      _currentProfile = ProfileModel.fromJson(response);
      emit(ProfileEditLoadedState(_currentProfile));
    } catch (e) {
      emit(ProfileEditErrorState('Failed to load profile: ${e.toString()}'));
    }
  }

  // تعديل حقل معين
  void updateField(String field, String value) {
    _currentProfile = _currentProfile.copyWith(
      name: field == 'name' ? value : null,
      username: field == 'username' ? value : null,
      email: field == 'email' ? value : null,
      phone: field == 'phone' ? value : null,
      website: field == 'website' ? value : null,
      bio: field == 'bio' ? value : null,
      gender: field == 'gender' ? value : null,
    );

    emit(ProfileEditLoadedState(_currentProfile));
  }

  // اختيار صورة
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        final imageFile = File(image.path);
        _currentProfile =
            _currentProfile.copyWith(profileImageFile: imageFile);
        emit(ProfileEditLoadedState(_currentProfile));
      }
    } catch (e) {
      emit(ProfileEditErrorState('Failed to pick image: $e', _currentProfile));
    }
  }

  // رفع الصورة
  Future<void> uploadProfileImage() async {
    if (_currentProfile.profileImageFile == null) return;

    try {
      emit(ProfileImageUploadingState(_currentProfile));
      final user = _supabase.auth.currentUser;

      if (user == null) {
        emit( ProfileEditErrorState('User not authenticated'));
        return;
      }

      final fileName =
          'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _supabase.storage
          .from('profiles')
          .upload(fileName, _currentProfile.profileImageFile!);

      final imageUrl =
      _supabase.storage.from('profiles').getPublicUrl(fileName);

      _currentProfile =
          _currentProfile.copyWith(profileImageUrl: imageUrl, profileImageFile: null);

      emit(ProfileImageUploadedState(_currentProfile));
    } catch (e) {
      emit(ProfileEditErrorState('Failed to upload image: $e', _currentProfile));
    }
  }

  // حفظ البروفايل
  Future<void> saveProfile() async {
    try {
      if (!_currentProfile.isValid) {
        emit(ProfileValidationErrorState(
            'Please fill in all required fields', _currentProfile));
        return;
      }

      emit(ProfileEditUpdatingState(_currentProfile));
      final user = _supabase.auth.currentUser;

      if (user == null) {
        emit( ProfileEditErrorState('User not authenticated'));
        return;
      }

      if (_currentProfile.profileImageFile != null) {
        await uploadProfileImage();
      }

      await _supabase
          .from('profiles')
          .update(_currentProfile.toJson())
          .eq('id', user.id);

      emit(ProfileEditSuccessState(
          _currentProfile, 'Profile updated successfully'));
    } catch (e) {
      emit(ProfileEditErrorState('Failed to save profile: $e', _currentProfile));
    }
  }

  void reset() {
    _currentProfile = ProfileModel.empty();
    emit(ProfileEditInitialState());
  }

  Future<void> cancelEditing() async {
    await loadProfile();
  }
}

