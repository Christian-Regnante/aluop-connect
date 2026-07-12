// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentProfileModel {

 String get uid; String get phoneCode; String get phoneNumber; String get city; String get country; List<String> get languages; String get photoUrl; String get major; String get expectedGradYear; String get bio; List<String> get skills; List<String> get opportunityInterests; List<String> get missionAlignmentHubs; String get resumeUrl; double get gpa; String get leadershipGrade; double get attendancePercentage; List<Map<String, String>> get endorsements; Map<String, int> get metrics;
/// Create a copy of StudentProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProfileModelCopyWith<StudentProfileModel> get copyWith => _$StudentProfileModelCopyWithImpl<StudentProfileModel>(this as StudentProfileModel, _$identity);

  /// Serializes this StudentProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.phoneCode, phoneCode) || other.phoneCode == phoneCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.major, major) || other.major == major)&&(identical(other.expectedGradYear, expectedGradYear) || other.expectedGradYear == expectedGradYear)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.skills, skills)&&const DeepCollectionEquality().equals(other.opportunityInterests, opportunityInterests)&&const DeepCollectionEquality().equals(other.missionAlignmentHubs, missionAlignmentHubs)&&(identical(other.resumeUrl, resumeUrl) || other.resumeUrl == resumeUrl)&&(identical(other.gpa, gpa) || other.gpa == gpa)&&(identical(other.leadershipGrade, leadershipGrade) || other.leadershipGrade == leadershipGrade)&&(identical(other.attendancePercentage, attendancePercentage) || other.attendancePercentage == attendancePercentage)&&const DeepCollectionEquality().equals(other.endorsements, endorsements)&&const DeepCollectionEquality().equals(other.metrics, metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,phoneCode,phoneNumber,city,country,const DeepCollectionEquality().hash(languages),photoUrl,major,expectedGradYear,bio,const DeepCollectionEquality().hash(skills),const DeepCollectionEquality().hash(opportunityInterests),const DeepCollectionEquality().hash(missionAlignmentHubs),resumeUrl,gpa,leadershipGrade,attendancePercentage,const DeepCollectionEquality().hash(endorsements),const DeepCollectionEquality().hash(metrics)]);

@override
String toString() {
  return 'StudentProfileModel(uid: $uid, phoneCode: $phoneCode, phoneNumber: $phoneNumber, city: $city, country: $country, languages: $languages, photoUrl: $photoUrl, major: $major, expectedGradYear: $expectedGradYear, bio: $bio, skills: $skills, opportunityInterests: $opportunityInterests, missionAlignmentHubs: $missionAlignmentHubs, resumeUrl: $resumeUrl, gpa: $gpa, leadershipGrade: $leadershipGrade, attendancePercentage: $attendancePercentage, endorsements: $endorsements, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class $StudentProfileModelCopyWith<$Res>  {
  factory $StudentProfileModelCopyWith(StudentProfileModel value, $Res Function(StudentProfileModel) _then) = _$StudentProfileModelCopyWithImpl;
@useResult
$Res call({
 String uid, String phoneCode, String phoneNumber, String city, String country, List<String> languages, String photoUrl, String major, String expectedGradYear, String bio, List<String> skills, List<String> opportunityInterests, List<String> missionAlignmentHubs, String resumeUrl, double gpa, String leadershipGrade, double attendancePercentage, List<Map<String, String>> endorsements, Map<String, int> metrics
});




}
/// @nodoc
class _$StudentProfileModelCopyWithImpl<$Res>
    implements $StudentProfileModelCopyWith<$Res> {
  _$StudentProfileModelCopyWithImpl(this._self, this._then);

  final StudentProfileModel _self;
  final $Res Function(StudentProfileModel) _then;

/// Create a copy of StudentProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? phoneCode = null,Object? phoneNumber = null,Object? city = null,Object? country = null,Object? languages = null,Object? photoUrl = null,Object? major = null,Object? expectedGradYear = null,Object? bio = null,Object? skills = null,Object? opportunityInterests = null,Object? missionAlignmentHubs = null,Object? resumeUrl = null,Object? gpa = null,Object? leadershipGrade = null,Object? attendancePercentage = null,Object? endorsements = null,Object? metrics = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,phoneCode: null == phoneCode ? _self.phoneCode : phoneCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,expectedGradYear: null == expectedGradYear ? _self.expectedGradYear : expectedGradYear // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self.skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,opportunityInterests: null == opportunityInterests ? _self.opportunityInterests : opportunityInterests // ignore: cast_nullable_to_non_nullable
as List<String>,missionAlignmentHubs: null == missionAlignmentHubs ? _self.missionAlignmentHubs : missionAlignmentHubs // ignore: cast_nullable_to_non_nullable
as List<String>,resumeUrl: null == resumeUrl ? _self.resumeUrl : resumeUrl // ignore: cast_nullable_to_non_nullable
as String,gpa: null == gpa ? _self.gpa : gpa // ignore: cast_nullable_to_non_nullable
as double,leadershipGrade: null == leadershipGrade ? _self.leadershipGrade : leadershipGrade // ignore: cast_nullable_to_non_nullable
as String,attendancePercentage: null == attendancePercentage ? _self.attendancePercentage : attendancePercentage // ignore: cast_nullable_to_non_nullable
as double,endorsements: null == endorsements ? _self.endorsements : endorsements // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentProfileModel].
extension StudentProfileModelPatterns on StudentProfileModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentProfileModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _StudentProfileModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudentProfileModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String phoneCode,  String phoneNumber,  String city,  String country,  List<String> languages,  String photoUrl,  String major,  String expectedGradYear,  String bio,  List<String> skills,  List<String> opportunityInterests,  List<String> missionAlignmentHubs,  String resumeUrl,  double gpa,  String leadershipGrade,  double attendancePercentage,  List<Map<String, String>> endorsements,  Map<String, int> metrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProfileModel() when $default != null:
return $default(_that.uid,_that.phoneCode,_that.phoneNumber,_that.city,_that.country,_that.languages,_that.photoUrl,_that.major,_that.expectedGradYear,_that.bio,_that.skills,_that.opportunityInterests,_that.missionAlignmentHubs,_that.resumeUrl,_that.gpa,_that.leadershipGrade,_that.attendancePercentage,_that.endorsements,_that.metrics);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String phoneCode,  String phoneNumber,  String city,  String country,  List<String> languages,  String photoUrl,  String major,  String expectedGradYear,  String bio,  List<String> skills,  List<String> opportunityInterests,  List<String> missionAlignmentHubs,  String resumeUrl,  double gpa,  String leadershipGrade,  double attendancePercentage,  List<Map<String, String>> endorsements,  Map<String, int> metrics)  $default,) {final _that = this;
switch (_that) {
case _StudentProfileModel():
return $default(_that.uid,_that.phoneCode,_that.phoneNumber,_that.city,_that.country,_that.languages,_that.photoUrl,_that.major,_that.expectedGradYear,_that.bio,_that.skills,_that.opportunityInterests,_that.missionAlignmentHubs,_that.resumeUrl,_that.gpa,_that.leadershipGrade,_that.attendancePercentage,_that.endorsements,_that.metrics);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String phoneCode,  String phoneNumber,  String city,  String country,  List<String> languages,  String photoUrl,  String major,  String expectedGradYear,  String bio,  List<String> skills,  List<String> opportunityInterests,  List<String> missionAlignmentHubs,  String resumeUrl,  double gpa,  String leadershipGrade,  double attendancePercentage,  List<Map<String, String>> endorsements,  Map<String, int> metrics)?  $default,) {final _that = this;
switch (_that) {
case _StudentProfileModel() when $default != null:
return $default(_that.uid,_that.phoneCode,_that.phoneNumber,_that.city,_that.country,_that.languages,_that.photoUrl,_that.major,_that.expectedGradYear,_that.bio,_that.skills,_that.opportunityInterests,_that.missionAlignmentHubs,_that.resumeUrl,_that.gpa,_that.leadershipGrade,_that.attendancePercentage,_that.endorsements,_that.metrics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentProfileModel implements StudentProfileModel {
  const _StudentProfileModel({required this.uid, required this.phoneCode, required this.phoneNumber, required this.city, required this.country, required final  List<String> languages, required this.photoUrl, required this.major, required this.expectedGradYear, required this.bio, required final  List<String> skills, required final  List<String> opportunityInterests, required final  List<String> missionAlignmentHubs, required this.resumeUrl, this.gpa = 3.82, this.leadershipGrade = 'A+', this.attendancePercentage = 98.0, final  List<Map<String, String>> endorsements = const [], final  Map<String, int> metrics = const {'applications' : 12, 'shortlisted' : 4, 'accepted' : 2}}): _languages = languages,_skills = skills,_opportunityInterests = opportunityInterests,_missionAlignmentHubs = missionAlignmentHubs,_endorsements = endorsements,_metrics = metrics;
  factory _StudentProfileModel.fromJson(Map<String, dynamic> json) => _$StudentProfileModelFromJson(json);

@override final  String uid;
@override final  String phoneCode;
@override final  String phoneNumber;
@override final  String city;
@override final  String country;
 final  List<String> _languages;
@override List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  String photoUrl;
@override final  String major;
@override final  String expectedGradYear;
@override final  String bio;
 final  List<String> _skills;
@override List<String> get skills {
  if (_skills is EqualUnmodifiableListView) return _skills;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skills);
}

 final  List<String> _opportunityInterests;
@override List<String> get opportunityInterests {
  if (_opportunityInterests is EqualUnmodifiableListView) return _opportunityInterests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opportunityInterests);
}

 final  List<String> _missionAlignmentHubs;
@override List<String> get missionAlignmentHubs {
  if (_missionAlignmentHubs is EqualUnmodifiableListView) return _missionAlignmentHubs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missionAlignmentHubs);
}

@override final  String resumeUrl;
@override@JsonKey() final  double gpa;
@override@JsonKey() final  String leadershipGrade;
@override@JsonKey() final  double attendancePercentage;
 final  List<Map<String, String>> _endorsements;
@override@JsonKey() List<Map<String, String>> get endorsements {
  if (_endorsements is EqualUnmodifiableListView) return _endorsements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_endorsements);
}

 final  Map<String, int> _metrics;
@override@JsonKey() Map<String, int> get metrics {
  if (_metrics is EqualUnmodifiableMapView) return _metrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metrics);
}


/// Create a copy of StudentProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentProfileModelCopyWith<_StudentProfileModel> get copyWith => __$StudentProfileModelCopyWithImpl<_StudentProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.phoneCode, phoneCode) || other.phoneCode == phoneCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.major, major) || other.major == major)&&(identical(other.expectedGradYear, expectedGradYear) || other.expectedGradYear == expectedGradYear)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._skills, _skills)&&const DeepCollectionEquality().equals(other._opportunityInterests, _opportunityInterests)&&const DeepCollectionEquality().equals(other._missionAlignmentHubs, _missionAlignmentHubs)&&(identical(other.resumeUrl, resumeUrl) || other.resumeUrl == resumeUrl)&&(identical(other.gpa, gpa) || other.gpa == gpa)&&(identical(other.leadershipGrade, leadershipGrade) || other.leadershipGrade == leadershipGrade)&&(identical(other.attendancePercentage, attendancePercentage) || other.attendancePercentage == attendancePercentage)&&const DeepCollectionEquality().equals(other._endorsements, _endorsements)&&const DeepCollectionEquality().equals(other._metrics, _metrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,phoneCode,phoneNumber,city,country,const DeepCollectionEquality().hash(_languages),photoUrl,major,expectedGradYear,bio,const DeepCollectionEquality().hash(_skills),const DeepCollectionEquality().hash(_opportunityInterests),const DeepCollectionEquality().hash(_missionAlignmentHubs),resumeUrl,gpa,leadershipGrade,attendancePercentage,const DeepCollectionEquality().hash(_endorsements),const DeepCollectionEquality().hash(_metrics)]);

@override
String toString() {
  return 'StudentProfileModel(uid: $uid, phoneCode: $phoneCode, phoneNumber: $phoneNumber, city: $city, country: $country, languages: $languages, photoUrl: $photoUrl, major: $major, expectedGradYear: $expectedGradYear, bio: $bio, skills: $skills, opportunityInterests: $opportunityInterests, missionAlignmentHubs: $missionAlignmentHubs, resumeUrl: $resumeUrl, gpa: $gpa, leadershipGrade: $leadershipGrade, attendancePercentage: $attendancePercentage, endorsements: $endorsements, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class _$StudentProfileModelCopyWith<$Res> implements $StudentProfileModelCopyWith<$Res> {
  factory _$StudentProfileModelCopyWith(_StudentProfileModel value, $Res Function(_StudentProfileModel) _then) = __$StudentProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String phoneCode, String phoneNumber, String city, String country, List<String> languages, String photoUrl, String major, String expectedGradYear, String bio, List<String> skills, List<String> opportunityInterests, List<String> missionAlignmentHubs, String resumeUrl, double gpa, String leadershipGrade, double attendancePercentage, List<Map<String, String>> endorsements, Map<String, int> metrics
});




}
/// @nodoc
class __$StudentProfileModelCopyWithImpl<$Res>
    implements _$StudentProfileModelCopyWith<$Res> {
  __$StudentProfileModelCopyWithImpl(this._self, this._then);

  final _StudentProfileModel _self;
  final $Res Function(_StudentProfileModel) _then;

/// Create a copy of StudentProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? phoneCode = null,Object? phoneNumber = null,Object? city = null,Object? country = null,Object? languages = null,Object? photoUrl = null,Object? major = null,Object? expectedGradYear = null,Object? bio = null,Object? skills = null,Object? opportunityInterests = null,Object? missionAlignmentHubs = null,Object? resumeUrl = null,Object? gpa = null,Object? leadershipGrade = null,Object? attendancePercentage = null,Object? endorsements = null,Object? metrics = null,}) {
  return _then(_StudentProfileModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,phoneCode: null == phoneCode ? _self.phoneCode : phoneCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as String,expectedGradYear: null == expectedGradYear ? _self.expectedGradYear : expectedGradYear // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,skills: null == skills ? _self._skills : skills // ignore: cast_nullable_to_non_nullable
as List<String>,opportunityInterests: null == opportunityInterests ? _self._opportunityInterests : opportunityInterests // ignore: cast_nullable_to_non_nullable
as List<String>,missionAlignmentHubs: null == missionAlignmentHubs ? _self._missionAlignmentHubs : missionAlignmentHubs // ignore: cast_nullable_to_non_nullable
as List<String>,resumeUrl: null == resumeUrl ? _self.resumeUrl : resumeUrl // ignore: cast_nullable_to_non_nullable
as String,gpa: null == gpa ? _self.gpa : gpa // ignore: cast_nullable_to_non_nullable
as double,leadershipGrade: null == leadershipGrade ? _self.leadershipGrade : leadershipGrade // ignore: cast_nullable_to_non_nullable
as String,attendancePercentage: null == attendancePercentage ? _self.attendancePercentage : attendancePercentage // ignore: cast_nullable_to_non_nullable
as double,endorsements: null == endorsements ? _self._endorsements : endorsements // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,metrics: null == metrics ? _self._metrics : metrics // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
