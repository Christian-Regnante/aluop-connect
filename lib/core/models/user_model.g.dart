// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  hasCompletedSetup: json['hasCompletedSetup'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'email': instance.email,
      'role': instance.role,
      'createdAt': instance.createdAt.toIso8601String(),
      'hasCompletedSetup': instance.hasCompletedSetup,
    };
