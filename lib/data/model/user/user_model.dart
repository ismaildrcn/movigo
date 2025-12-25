import 'package:movigo/features/profile/widgets/common_widgets.dart';

class UserModel {
  final int? id;
  final String fullName;
  final String email;
  final String? phone;
  final bool? isActive;
  final bool? isVerified;
  final String? avatar;
  final String? password;
  final String? role;
  final String? createdAt;
  final String? token;
  final String? birthdate;
  final GenderEnum? gender;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.avatar,
    required this.phone,
    this.role,
    this.isActive,
    this.isVerified,
    this.createdAt,
    this.token,
    this.birthdate,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      avatar: json['avatar'],
      phone: json['phone'],
      isActive: json['is_active'],
      isVerified: json['is_verified'],
      createdAt: json['created_at'],
      token: json['token'],
      birthdate: json['birthdate'],
      gender: json['gender'] != null
          ? GenderEnum.values.firstWhere(
              (e) => e.toString() == 'GenderEnum.' + json['gender'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'avatar': avatar,
      'phone': phone,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt,
      'birthdate': birthdate,
      'gender': gender != null ? gender.toString().split('.').last : null,
    };
  }
}
