import 'package:untitled6/Data/Model_profile-edit.dart';

abstract class ProfileEditState {}

// الحالة الأولية
class ProfileEditInitialState extends ProfileEditState {}

// تحميل البيانات
class ProfileEditLoadingState extends ProfileEditState {}

// تم تحميل البروفايل
class ProfileEditLoadedState extends ProfileEditState {
  final ProfileModel profile;
  ProfileEditLoadedState(this.profile);
}

// جاري التحديث
class ProfileEditUpdatingState extends ProfileEditState {
  final ProfileModel profile;
  ProfileEditUpdatingState(this.profile);
}

// التحديث ناجح
class ProfileEditSuccessState extends ProfileEditState {
  final ProfileModel profile;
  final String successMessage;
  ProfileEditSuccessState(this.profile, this.successMessage);
}

// حصل خطأ
class ProfileEditErrorState extends ProfileEditState {
  final String errorMessage;
  final ProfileModel? profile;
   ProfileEditErrorState(this.errorMessage, [this.profile]);
}

// خطأ في البيانات المدخلة
class ProfileValidationErrorState extends ProfileEditState {
  final String validationMessage;
  final ProfileModel profile;
  ProfileValidationErrorState(this.validationMessage, this.profile);
}

// رفع صورة جاري
class ProfileImageUploadingState extends ProfileEditState {
  final ProfileModel profile;
  ProfileImageUploadingState(this.profile);
}

// الصورة اترفعت
class ProfileImageUploadedState extends ProfileEditState {
  final ProfileModel profile;
  ProfileImageUploadedState(this.profile);
}
