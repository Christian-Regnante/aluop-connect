// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opportunity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpportunityModel {

 String get id; String get employerId; String get title; String get company; String get industry; String get type; String get duration; String get locationMode; String get locationName; String get stipend; String get openings; String get description; List<String> get requirements; List<String> get tags; DateTime get postedTime; DateTime get deadline; int get applicantsCount; String get status;
/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpportunityModelCopyWith<OpportunityModel> get copyWith => _$OpportunityModelCopyWithImpl<OpportunityModel>(this as OpportunityModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employerId, employerId) || other.employerId == employerId)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.locationMode, locationMode) || other.locationMode == locationMode)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.stipend, stipend) || other.stipend == stipend)&&(identical(other.openings, openings) || other.openings == openings)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.requirements, requirements)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.postedTime, postedTime) || other.postedTime == postedTime)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.applicantsCount, applicantsCount) || other.applicantsCount == applicantsCount)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,employerId,title,company,industry,type,duration,locationMode,locationName,stipend,openings,description,const DeepCollectionEquality().hash(requirements),const DeepCollectionEquality().hash(tags),postedTime,deadline,applicantsCount,status);

@override
String toString() {
  return 'OpportunityModel(id: $id, employerId: $employerId, title: $title, company: $company, industry: $industry, type: $type, duration: $duration, locationMode: $locationMode, locationName: $locationName, stipend: $stipend, openings: $openings, description: $description, requirements: $requirements, tags: $tags, postedTime: $postedTime, deadline: $deadline, applicantsCount: $applicantsCount, status: $status)';
}


}

/// @nodoc
abstract mixin class $OpportunityModelCopyWith<$Res>  {
  factory $OpportunityModelCopyWith(OpportunityModel value, $Res Function(OpportunityModel) _then) = _$OpportunityModelCopyWithImpl;
@useResult
$Res call({
 String id, String employerId, String title, String company, String industry, String type, String duration, String locationMode, String locationName, String stipend, String openings, String description, List<String> requirements, List<String> tags, DateTime postedTime, DateTime deadline, int applicantsCount, String status
});




}
/// @nodoc
class _$OpportunityModelCopyWithImpl<$Res>
    implements $OpportunityModelCopyWith<$Res> {
  _$OpportunityModelCopyWithImpl(this._self, this._then);

  final OpportunityModel _self;
  final $Res Function(OpportunityModel) _then;

/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employerId = null,Object? title = null,Object? company = null,Object? industry = null,Object? type = null,Object? duration = null,Object? locationMode = null,Object? locationName = null,Object? stipend = null,Object? openings = null,Object? description = null,Object? requirements = null,Object? tags = null,Object? postedTime = null,Object? deadline = null,Object? applicantsCount = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employerId: null == employerId ? _self.employerId : employerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,industry: null == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,locationMode: null == locationMode ? _self.locationMode : locationMode // ignore: cast_nullable_to_non_nullable
as String,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,stipend: null == stipend ? _self.stipend : stipend // ignore: cast_nullable_to_non_nullable
as String,openings: null == openings ? _self.openings : openings // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self.requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,postedTime: null == postedTime ? _self.postedTime : postedTime // ignore: cast_nullable_to_non_nullable
as DateTime,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,applicantsCount: null == applicantsCount ? _self.applicantsCount : applicantsCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OpportunityModel].
extension OpportunityModelPatterns on OpportunityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpportunityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpportunityModel value)  $default,){
final _that = this;
switch (_that) {
case _OpportunityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpportunityModel value)?  $default,){
final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String employerId,  String title,  String company,  String industry,  String type,  String duration,  String locationMode,  String locationName,  String stipend,  String openings,  String description,  List<String> requirements,  List<String> tags,  DateTime postedTime,  DateTime deadline,  int applicantsCount,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
return $default(_that.id,_that.employerId,_that.title,_that.company,_that.industry,_that.type,_that.duration,_that.locationMode,_that.locationName,_that.stipend,_that.openings,_that.description,_that.requirements,_that.tags,_that.postedTime,_that.deadline,_that.applicantsCount,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String employerId,  String title,  String company,  String industry,  String type,  String duration,  String locationMode,  String locationName,  String stipend,  String openings,  String description,  List<String> requirements,  List<String> tags,  DateTime postedTime,  DateTime deadline,  int applicantsCount,  String status)  $default,) {final _that = this;
switch (_that) {
case _OpportunityModel():
return $default(_that.id,_that.employerId,_that.title,_that.company,_that.industry,_that.type,_that.duration,_that.locationMode,_that.locationName,_that.stipend,_that.openings,_that.description,_that.requirements,_that.tags,_that.postedTime,_that.deadline,_that.applicantsCount,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String employerId,  String title,  String company,  String industry,  String type,  String duration,  String locationMode,  String locationName,  String stipend,  String openings,  String description,  List<String> requirements,  List<String> tags,  DateTime postedTime,  DateTime deadline,  int applicantsCount,  String status)?  $default,) {final _that = this;
switch (_that) {
case _OpportunityModel() when $default != null:
return $default(_that.id,_that.employerId,_that.title,_that.company,_that.industry,_that.type,_that.duration,_that.locationMode,_that.locationName,_that.stipend,_that.openings,_that.description,_that.requirements,_that.tags,_that.postedTime,_that.deadline,_that.applicantsCount,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _OpportunityModel extends OpportunityModel {
  const _OpportunityModel({required this.id, required this.employerId, required this.title, required this.company, required this.industry, required this.type, required this.duration, required this.locationMode, required this.locationName, required this.stipend, required this.openings, required this.description, required final  List<String> requirements, required final  List<String> tags, required this.postedTime, required this.deadline, this.applicantsCount = 0, this.status = 'active'}): _requirements = requirements,_tags = tags,super._();
  

@override final  String id;
@override final  String employerId;
@override final  String title;
@override final  String company;
@override final  String industry;
@override final  String type;
@override final  String duration;
@override final  String locationMode;
@override final  String locationName;
@override final  String stipend;
@override final  String openings;
@override final  String description;
 final  List<String> _requirements;
@override List<String> get requirements {
  if (_requirements is EqualUnmodifiableListView) return _requirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requirements);
}

 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  DateTime postedTime;
@override final  DateTime deadline;
@override@JsonKey() final  int applicantsCount;
@override@JsonKey() final  String status;

/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpportunityModelCopyWith<_OpportunityModel> get copyWith => __$OpportunityModelCopyWithImpl<_OpportunityModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpportunityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employerId, employerId) || other.employerId == employerId)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.industry, industry) || other.industry == industry)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.locationMode, locationMode) || other.locationMode == locationMode)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.stipend, stipend) || other.stipend == stipend)&&(identical(other.openings, openings) || other.openings == openings)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._requirements, _requirements)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.postedTime, postedTime) || other.postedTime == postedTime)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.applicantsCount, applicantsCount) || other.applicantsCount == applicantsCount)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,employerId,title,company,industry,type,duration,locationMode,locationName,stipend,openings,description,const DeepCollectionEquality().hash(_requirements),const DeepCollectionEquality().hash(_tags),postedTime,deadline,applicantsCount,status);

@override
String toString() {
  return 'OpportunityModel(id: $id, employerId: $employerId, title: $title, company: $company, industry: $industry, type: $type, duration: $duration, locationMode: $locationMode, locationName: $locationName, stipend: $stipend, openings: $openings, description: $description, requirements: $requirements, tags: $tags, postedTime: $postedTime, deadline: $deadline, applicantsCount: $applicantsCount, status: $status)';
}


}

/// @nodoc
abstract mixin class _$OpportunityModelCopyWith<$Res> implements $OpportunityModelCopyWith<$Res> {
  factory _$OpportunityModelCopyWith(_OpportunityModel value, $Res Function(_OpportunityModel) _then) = __$OpportunityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String employerId, String title, String company, String industry, String type, String duration, String locationMode, String locationName, String stipend, String openings, String description, List<String> requirements, List<String> tags, DateTime postedTime, DateTime deadline, int applicantsCount, String status
});




}
/// @nodoc
class __$OpportunityModelCopyWithImpl<$Res>
    implements _$OpportunityModelCopyWith<$Res> {
  __$OpportunityModelCopyWithImpl(this._self, this._then);

  final _OpportunityModel _self;
  final $Res Function(_OpportunityModel) _then;

/// Create a copy of OpportunityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employerId = null,Object? title = null,Object? company = null,Object? industry = null,Object? type = null,Object? duration = null,Object? locationMode = null,Object? locationName = null,Object? stipend = null,Object? openings = null,Object? description = null,Object? requirements = null,Object? tags = null,Object? postedTime = null,Object? deadline = null,Object? applicantsCount = null,Object? status = null,}) {
  return _then(_OpportunityModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employerId: null == employerId ? _self.employerId : employerId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,industry: null == industry ? _self.industry : industry // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,locationMode: null == locationMode ? _self.locationMode : locationMode // ignore: cast_nullable_to_non_nullable
as String,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,stipend: null == stipend ? _self.stipend : stipend // ignore: cast_nullable_to_non_nullable
as String,openings: null == openings ? _self.openings : openings // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requirements: null == requirements ? _self._requirements : requirements // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,postedTime: null == postedTime ? _self.postedTime : postedTime // ignore: cast_nullable_to_non_nullable
as DateTime,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,applicantsCount: null == applicantsCount ? _self.applicantsCount : applicantsCount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
