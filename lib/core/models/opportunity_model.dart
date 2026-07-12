import 'package:freezed_annotation/freezed_annotation.dart';

part 'opportunity_model.freezed.dart';

@freezed
abstract class OpportunityModel with _$OpportunityModel {
  const OpportunityModel._();

  const factory OpportunityModel({
    required String id,
    required String employerId,
    required String title,
    required String company,
    required String industry,
    required String type,
    required String duration,
    required String locationMode,
    required String locationName,
    required String stipend,
    required String openings,
    required String description,
    required List<String> requirements,
    required List<String> tags,
    required DateTime postedTime,
    required DateTime deadline,
    @Default(0) int applicantsCount,
    @Default('active') String status,
  }) = _OpportunityModel;

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final employerId = json['employerId'] as String? ?? '';
    final title = json['title'] as String? ?? '';
    final company = json['company'] as String? ?? '';
    final industry = json['industry'] as String? ?? '';
    final type = json['type'] as String? ?? '';
    final duration = json['duration'] as String? ?? '';
    final locationMode = json['locationMode'] as String? ?? '';
    final locationName = json['locationName'] as String? ?? '';
    final stipend = json['stipend'] as String? ?? 'Paid';
    final openings = json['openings'] as String? ?? '1';
    final description = json['description'] as String? ?? '';
    
    final requirementsRaw = json['requirements'];
    final List<String> requirements = requirementsRaw is List
        ? List<String>.from(requirementsRaw.map((e) => e.toString()))
        : [];
        
    final tagsRaw = json['tags'];
    final List<String> tags = tagsRaw is List
        ? List<String>.from(tagsRaw.map((e) => e.toString()))
        : [];

    DateTime postedTime;
    if (json['postedTime'] != null) {
      try {
        postedTime = DateTime.parse(json['postedTime'] as String);
      } catch (_) {
        postedTime = DateTime.now();
      }
    } else {
      postedTime = DateTime.now();
    }

    DateTime deadline;
    if (json['deadline'] != null) {
      try {
        deadline = DateTime.parse(json['deadline'] as String);
      } catch (_) {
        deadline = DateTime.now().add(const Duration(days: 30));
      }
    } else {
      deadline = DateTime.now().add(const Duration(days: 30));
    }

    final applicantsCount = json['applicantsCount'] as int? ?? 0;
    final status = json['status'] as String? ?? 'active';

    return OpportunityModel(
      id: id,
      employerId: employerId,
      title: title,
      company: company,
      industry: industry,
      type: type,
      duration: duration,
      locationMode: locationMode,
      locationName: locationName,
      stipend: stipend,
      openings: openings,
      description: description,
      requirements: requirements,
      tags: tags,
      postedTime: postedTime,
      deadline: deadline,
      applicantsCount: applicantsCount,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employerId': employerId,
      'title': title,
      'company': company,
      'industry': industry,
      'type': type,
      'duration': duration,
      'locationMode': locationMode,
      'locationName': locationName,
      'stipend': stipend,
      'openings': openings,
      'description': description,
      'requirements': requirements,
      'tags': tags,
      'postedTime': postedTime.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'applicantsCount': applicantsCount,
      'status': status,
    };
  }
}
