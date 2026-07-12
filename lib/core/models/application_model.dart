import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_model.freezed.dart';
part 'application_model.g.dart';

@freezed
abstract class ApplicationModel with _$ApplicationModel {
  const factory ApplicationModel({
    required String id,
    required String opportunityId,
    required String studentId,
    required String coverLetter,
    required String portfolioUrl,
    required String resumeUrl,
    required String status,
    required DateTime appliedAt,
    @Default('') String internalNotes,
    @Default(true) bool isConfidential,
  }) = _ApplicationModel;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);
}
