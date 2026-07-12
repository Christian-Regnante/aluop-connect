// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmployerProfileModel _$EmployerProfileModelFromJson(
  Map<String, dynamic> json,
) => _EmployerProfileModel(
  uid: json['uid'] as String,
  orgName: json['orgName'] as String,
  logoUrl: json['logoUrl'] as String,
  websiteUrl: json['websiteUrl'] as String,
  industries: (json['industries'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  missionStatement: json['missionStatement'] as String,
  bio: json['bio'] as String,
  coreValues: (json['coreValues'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  hqLocation: json['hqLocation'] as String,
  linkedinUrl: json['linkedinUrl'] as String,
  projectsFunded: (json['projectsFunded'] as num?)?.toInt() ?? 12,
  studentsHired: (json['studentsHired'] as num?)?.toInt() ?? 45,
  rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
  teamMembers:
      (json['teamMembers'] as List<dynamic>?)
          ?.map((e) => Map<String, String>.from(e as Map))
          .toList() ??
      const [],
);

Map<String, dynamic> _$EmployerProfileModelToJson(
  _EmployerProfileModel instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'orgName': instance.orgName,
  'logoUrl': instance.logoUrl,
  'websiteUrl': instance.websiteUrl,
  'industries': instance.industries,
  'missionStatement': instance.missionStatement,
  'bio': instance.bio,
  'coreValues': instance.coreValues,
  'hqLocation': instance.hqLocation,
  'linkedinUrl': instance.linkedinUrl,
  'projectsFunded': instance.projectsFunded,
  'studentsHired': instance.studentsHired,
  'rating': instance.rating,
  'teamMembers': instance.teamMembers,
};
