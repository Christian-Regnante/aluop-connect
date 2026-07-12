// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) =>
    _ApplicationModel(
      id: json['id'] as String,
      opportunityId: json['opportunityId'] as String,
      studentId: json['studentId'] as String,
      coverLetter: json['coverLetter'] as String,
      portfolioUrl: json['portfolioUrl'] as String,
      resumeUrl: json['resumeUrl'] as String,
      status: json['status'] as String,
      appliedAt: DateTime.parse(json['appliedAt'] as String),
      internalNotes: json['internalNotes'] as String? ?? '',
      isConfidential: json['isConfidential'] as bool? ?? true,
    );

Map<String, dynamic> _$ApplicationModelToJson(_ApplicationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'opportunityId': instance.opportunityId,
      'studentId': instance.studentId,
      'coverLetter': instance.coverLetter,
      'portfolioUrl': instance.portfolioUrl,
      'resumeUrl': instance.resumeUrl,
      'status': instance.status,
      'appliedAt': instance.appliedAt.toIso8601String(),
      'internalNotes': instance.internalNotes,
      'isConfidential': instance.isConfidential,
    };
