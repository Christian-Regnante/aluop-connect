// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employer_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmployerProfileModel {

 String get uid; String get orgName; String get logoUrl; String get websiteUrl; List<String> get industries; String get missionStatement; String get bio; List<String> get coreValues; String get hqLocation; String get linkedinUrl; int get projectsFunded; int get studentsHired; double get rating; List<Map<String, String>> get teamMembers;
/// Create a copy of EmployerProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployerProfileModelCopyWith<EmployerProfileModel> get copyWith => _$EmployerProfileModelCopyWithImpl<EmployerProfileModel>(this as EmployerProfileModel, _$identity);

  /// Serializes this EmployerProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployerProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&const DeepCollectionEquality().equals(other.industries, industries)&&(identical(other.missionStatement, missionStatement) || other.missionStatement == missionStatement)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.coreValues, coreValues)&&(identical(other.hqLocation, hqLocation) || other.hqLocation == hqLocation)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.projectsFunded, projectsFunded) || other.projectsFunded == projectsFunded)&&(identical(other.studentsHired, studentsHired) || other.studentsHired == studentsHired)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other.teamMembers, teamMembers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,orgName,logoUrl,websiteUrl,const DeepCollectionEquality().hash(industries),missionStatement,bio,const DeepCollectionEquality().hash(coreValues),hqLocation,linkedinUrl,projectsFunded,studentsHired,rating,const DeepCollectionEquality().hash(teamMembers));

@override
String toString() {
  return 'EmployerProfileModel(uid: $uid, orgName: $orgName, logoUrl: $logoUrl, websiteUrl: $websiteUrl, industries: $industries, missionStatement: $missionStatement, bio: $bio, coreValues: $coreValues, hqLocation: $hqLocation, linkedinUrl: $linkedinUrl, projectsFunded: $projectsFunded, studentsHired: $studentsHired, rating: $rating, teamMembers: $teamMembers)';
}


}

/// @nodoc
abstract mixin class $EmployerProfileModelCopyWith<$Res>  {
  factory $EmployerProfileModelCopyWith(EmployerProfileModel value, $Res Function(EmployerProfileModel) _then) = _$EmployerProfileModelCopyWithImpl;
@useResult
$Res call({
 String uid, String orgName, String logoUrl, String websiteUrl, List<String> industries, String missionStatement, String bio, List<String> coreValues, String hqLocation, String linkedinUrl, int projectsFunded, int studentsHired, double rating, List<Map<String, String>> teamMembers
});




}
/// @nodoc
class _$EmployerProfileModelCopyWithImpl<$Res>
    implements $EmployerProfileModelCopyWith<$Res> {
  _$EmployerProfileModelCopyWithImpl(this._self, this._then);

  final EmployerProfileModel _self;
  final $Res Function(EmployerProfileModel) _then;

/// Create a copy of EmployerProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? orgName = null,Object? logoUrl = null,Object? websiteUrl = null,Object? industries = null,Object? missionStatement = null,Object? bio = null,Object? coreValues = null,Object? hqLocation = null,Object? linkedinUrl = null,Object? projectsFunded = null,Object? studentsHired = null,Object? rating = null,Object? teamMembers = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,orgName: null == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,industries: null == industries ? _self.industries : industries // ignore: cast_nullable_to_non_nullable
as List<String>,missionStatement: null == missionStatement ? _self.missionStatement : missionStatement // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,coreValues: null == coreValues ? _self.coreValues : coreValues // ignore: cast_nullable_to_non_nullable
as List<String>,hqLocation: null == hqLocation ? _self.hqLocation : hqLocation // ignore: cast_nullable_to_non_nullable
as String,linkedinUrl: null == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String,projectsFunded: null == projectsFunded ? _self.projectsFunded : projectsFunded // ignore: cast_nullable_to_non_nullable
as int,studentsHired: null == studentsHired ? _self.studentsHired : studentsHired // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,teamMembers: null == teamMembers ? _self.teamMembers : teamMembers // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployerProfileModel].
extension EmployerProfileModelPatterns on EmployerProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployerProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployerProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployerProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployerProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployerProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployerProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String orgName,  String logoUrl,  String websiteUrl,  List<String> industries,  String missionStatement,  String bio,  List<String> coreValues,  String hqLocation,  String linkedinUrl,  int projectsFunded,  int studentsHired,  double rating,  List<Map<String, String>> teamMembers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployerProfileModel() when $default != null:
return $default(_that.uid,_that.orgName,_that.logoUrl,_that.websiteUrl,_that.industries,_that.missionStatement,_that.bio,_that.coreValues,_that.hqLocation,_that.linkedinUrl,_that.projectsFunded,_that.studentsHired,_that.rating,_that.teamMembers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String orgName,  String logoUrl,  String websiteUrl,  List<String> industries,  String missionStatement,  String bio,  List<String> coreValues,  String hqLocation,  String linkedinUrl,  int projectsFunded,  int studentsHired,  double rating,  List<Map<String, String>> teamMembers)  $default,) {final _that = this;
switch (_that) {
case _EmployerProfileModel():
return $default(_that.uid,_that.orgName,_that.logoUrl,_that.websiteUrl,_that.industries,_that.missionStatement,_that.bio,_that.coreValues,_that.hqLocation,_that.linkedinUrl,_that.projectsFunded,_that.studentsHired,_that.rating,_that.teamMembers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String orgName,  String logoUrl,  String websiteUrl,  List<String> industries,  String missionStatement,  String bio,  List<String> coreValues,  String hqLocation,  String linkedinUrl,  int projectsFunded,  int studentsHired,  double rating,  List<Map<String, String>> teamMembers)?  $default,) {final _that = this;
switch (_that) {
case _EmployerProfileModel() when $default != null:
return $default(_that.uid,_that.orgName,_that.logoUrl,_that.websiteUrl,_that.industries,_that.missionStatement,_that.bio,_that.coreValues,_that.hqLocation,_that.linkedinUrl,_that.projectsFunded,_that.studentsHired,_that.rating,_that.teamMembers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployerProfileModel implements EmployerProfileModel {
  const _EmployerProfileModel({required this.uid, required this.orgName, required this.logoUrl, required this.websiteUrl, required final  List<String> industries, required this.missionStatement, required this.bio, required final  List<String> coreValues, required this.hqLocation, required this.linkedinUrl, this.projectsFunded = 12, this.studentsHired = 45, this.rating = 4.8, final  List<Map<String, String>> teamMembers = const []}): _industries = industries,_coreValues = coreValues,_teamMembers = teamMembers;
  factory _EmployerProfileModel.fromJson(Map<String, dynamic> json) => _$EmployerProfileModelFromJson(json);

@override final  String uid;
@override final  String orgName;
@override final  String logoUrl;
@override final  String websiteUrl;
 final  List<String> _industries;
@override List<String> get industries {
  if (_industries is EqualUnmodifiableListView) return _industries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_industries);
}

@override final  String missionStatement;
@override final  String bio;
 final  List<String> _coreValues;
@override List<String> get coreValues {
  if (_coreValues is EqualUnmodifiableListView) return _coreValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coreValues);
}

@override final  String hqLocation;
@override final  String linkedinUrl;
@override@JsonKey() final  int projectsFunded;
@override@JsonKey() final  int studentsHired;
@override@JsonKey() final  double rating;
 final  List<Map<String, String>> _teamMembers;
@override@JsonKey() List<Map<String, String>> get teamMembers {
  if (_teamMembers is EqualUnmodifiableListView) return _teamMembers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teamMembers);
}


/// Create a copy of EmployerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployerProfileModelCopyWith<_EmployerProfileModel> get copyWith => __$EmployerProfileModelCopyWithImpl<_EmployerProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployerProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployerProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&const DeepCollectionEquality().equals(other._industries, _industries)&&(identical(other.missionStatement, missionStatement) || other.missionStatement == missionStatement)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._coreValues, _coreValues)&&(identical(other.hqLocation, hqLocation) || other.hqLocation == hqLocation)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.projectsFunded, projectsFunded) || other.projectsFunded == projectsFunded)&&(identical(other.studentsHired, studentsHired) || other.studentsHired == studentsHired)&&(identical(other.rating, rating) || other.rating == rating)&&const DeepCollectionEquality().equals(other._teamMembers, _teamMembers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,orgName,logoUrl,websiteUrl,const DeepCollectionEquality().hash(_industries),missionStatement,bio,const DeepCollectionEquality().hash(_coreValues),hqLocation,linkedinUrl,projectsFunded,studentsHired,rating,const DeepCollectionEquality().hash(_teamMembers));

@override
String toString() {
  return 'EmployerProfileModel(uid: $uid, orgName: $orgName, logoUrl: $logoUrl, websiteUrl: $websiteUrl, industries: $industries, missionStatement: $missionStatement, bio: $bio, coreValues: $coreValues, hqLocation: $hqLocation, linkedinUrl: $linkedinUrl, projectsFunded: $projectsFunded, studentsHired: $studentsHired, rating: $rating, teamMembers: $teamMembers)';
}


}

/// @nodoc
abstract mixin class _$EmployerProfileModelCopyWith<$Res> implements $EmployerProfileModelCopyWith<$Res> {
  factory _$EmployerProfileModelCopyWith(_EmployerProfileModel value, $Res Function(_EmployerProfileModel) _then) = __$EmployerProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String orgName, String logoUrl, String websiteUrl, List<String> industries, String missionStatement, String bio, List<String> coreValues, String hqLocation, String linkedinUrl, int projectsFunded, int studentsHired, double rating, List<Map<String, String>> teamMembers
});




}
/// @nodoc
class __$EmployerProfileModelCopyWithImpl<$Res>
    implements _$EmployerProfileModelCopyWith<$Res> {
  __$EmployerProfileModelCopyWithImpl(this._self, this._then);

  final _EmployerProfileModel _self;
  final $Res Function(_EmployerProfileModel) _then;

/// Create a copy of EmployerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? orgName = null,Object? logoUrl = null,Object? websiteUrl = null,Object? industries = null,Object? missionStatement = null,Object? bio = null,Object? coreValues = null,Object? hqLocation = null,Object? linkedinUrl = null,Object? projectsFunded = null,Object? studentsHired = null,Object? rating = null,Object? teamMembers = null,}) {
  return _then(_EmployerProfileModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,orgName: null == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String,logoUrl: null == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String,websiteUrl: null == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String,industries: null == industries ? _self._industries : industries // ignore: cast_nullable_to_non_nullable
as List<String>,missionStatement: null == missionStatement ? _self.missionStatement : missionStatement // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,coreValues: null == coreValues ? _self._coreValues : coreValues // ignore: cast_nullable_to_non_nullable
as List<String>,hqLocation: null == hqLocation ? _self.hqLocation : hqLocation // ignore: cast_nullable_to_non_nullable
as String,linkedinUrl: null == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String,projectsFunded: null == projectsFunded ? _self.projectsFunded : projectsFunded // ignore: cast_nullable_to_non_nullable
as int,studentsHired: null == studentsHired ? _self.studentsHired : studentsHired // ignore: cast_nullable_to_non_nullable
as int,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,teamMembers: null == teamMembers ? _self._teamMembers : teamMembers // ignore: cast_nullable_to_non_nullable
as List<Map<String, String>>,
  ));
}


}

// dart format on
