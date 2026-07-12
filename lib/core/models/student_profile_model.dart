import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_profile_model.freezed.dart';
part 'student_profile_model.g.dart';

@freezed
abstract class StudentProfileModel with _$StudentProfileModel {
  const factory StudentProfileModel({
    required String uid,
    required String phoneCode,
    required String phoneNumber,
    required String city,
    required String country,
    required List<String> languages,
    required String photoUrl,
    required String major,
    required String expectedGradYear,
    required String bio,
    required List<String> skills,
    required List<String> opportunityInterests,
    required List<String> missionAlignmentHubs,
    required String resumeUrl,
    @Default(3.82) double gpa,
    @Default('A+') String leadershipGrade,
    @Default(98.0) double attendancePercentage,
    @Default([]) List<Map<String, String>> endorsements,
    @Default({'applications': 12, 'shortlisted': 4, 'accepted': 2}) Map<String, int> metrics,
  }) = _StudentProfileModel;

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) => _$StudentProfileModelFromJson(json);
}
