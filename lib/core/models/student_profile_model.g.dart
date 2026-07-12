// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentProfileModel _$StudentProfileModelFromJson(Map<String, dynamic> json) =>
    _StudentProfileModel(
      uid: json['uid'] as String,
      phoneCode: json['phoneCode'] as String,
      phoneNumber: json['phoneNumber'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      photoUrl: json['photoUrl'] as String,
      major: json['major'] as String,
      expectedGradYear: json['expectedGradYear'] as String,
      bio: json['bio'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      opportunityInterests: (json['opportunityInterests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      missionAlignmentHubs: (json['missionAlignmentHubs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      resumeUrl: json['resumeUrl'] as String,
      gpa: (json['gpa'] as num?)?.toDouble() ?? 3.82,
      leadershipGrade: json['leadershipGrade'] as String? ?? 'A+',
      attendancePercentage:
          (json['attendancePercentage'] as num?)?.toDouble() ?? 98.0,
      endorsements:
          (json['endorsements'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          const [],
      metrics:
          (json['metrics'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {'applications': 12, 'shortlisted': 4, 'accepted': 2},
    );

Map<String, dynamic> _$StudentProfileModelToJson(
  _StudentProfileModel instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'phoneCode': instance.phoneCode,
  'phoneNumber': instance.phoneNumber,
  'city': instance.city,
  'country': instance.country,
  'languages': instance.languages,
  'photoUrl': instance.photoUrl,
  'major': instance.major,
  'expectedGradYear': instance.expectedGradYear,
  'bio': instance.bio,
  'skills': instance.skills,
  'opportunityInterests': instance.opportunityInterests,
  'missionAlignmentHubs': instance.missionAlignmentHubs,
  'resumeUrl': instance.resumeUrl,
  'gpa': instance.gpa,
  'leadershipGrade': instance.leadershipGrade,
  'attendancePercentage': instance.attendancePercentage,
  'endorsements': instance.endorsements,
  'metrics': instance.metrics,
};
