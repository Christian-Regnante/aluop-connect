import 'package:freezed_annotation/freezed_annotation.dart';

part 'employer_profile_model.freezed.dart';
part 'employer_profile_model.g.dart';

@freezed
abstract class EmployerProfileModel with _$EmployerProfileModel {
  const factory EmployerProfileModel({
    required String uid,
    required String orgName,
    required String logoUrl,
    required String websiteUrl,
    required List<String> industries,
    required String missionStatement,
    required String bio,
    required List<String> coreValues,
    required String hqLocation,
    required String linkedinUrl,
    @Default(12) int projectsFunded,
    @Default(45) int studentsHired,
    @Default(4.8) double rating,
    @Default([]) List<Map<String, String>> teamMembers,
  }) = _EmployerProfileModel;

  factory EmployerProfileModel.fromJson(Map<String, dynamic> json) => _$EmployerProfileModelFromJson(json);
}
