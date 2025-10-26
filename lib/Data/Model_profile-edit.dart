import 'dart:io';

class ProfileModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String bio;
  final String gender;
  final String? profileImageUrl;
  final File? profileImageFile;

  ProfileModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.bio,
    required this.gender,
    this.profileImageUrl,
    this.profileImageFile,
  });

  // نسخة فاضية
  factory ProfileModel.empty() {
    return ProfileModel(
      id: '',
      name: '',
      username: '',
      email: '',
      phone: '',
      website: '',
      bio: '',
      gender: '',
      profileImageUrl: null,
      profileImageFile: null,
    );
  }

  // من JSON إلى Object
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      bio: json['bio'] ?? '',
      gender: json['gender'] ?? '',
      profileImageUrl: json['profile_image_url'],
      profileImageFile: null,
    );
  }

  // من Object إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'website': website,
      'bio': bio,
      'gender': gender,
      'profile_image_url': profileImageUrl,
    };
  }

  // تعديل بيانات معينة
  ProfileModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? website,
    String? bio,
    String? gender,
    String? profileImageUrl,
    File? profileImageFile,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImageFile: profileImageFile ?? this.profileImageFile,
    );
  }

  // تحقق من صحة البيانات
  bool get isValid {
    return name.isNotEmpty && username.isNotEmpty && email.isNotEmpty;
  }
}
