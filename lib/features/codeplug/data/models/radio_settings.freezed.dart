// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'radio_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RadioSettings {

 int get dmrId; String get callsign; String get introLine1; String get introLine2; bool get keyTone; int get backlightTimeout; int get squelchLevel; int get voxLevel; bool get voxEnabled;
/// Create a copy of RadioSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RadioSettingsCopyWith<RadioSettings> get copyWith => _$RadioSettingsCopyWithImpl<RadioSettings>(this as RadioSettings, _$identity);

  /// Serializes this RadioSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RadioSettings&&(identical(other.dmrId, dmrId) || other.dmrId == dmrId)&&(identical(other.callsign, callsign) || other.callsign == callsign)&&(identical(other.introLine1, introLine1) || other.introLine1 == introLine1)&&(identical(other.introLine2, introLine2) || other.introLine2 == introLine2)&&(identical(other.keyTone, keyTone) || other.keyTone == keyTone)&&(identical(other.backlightTimeout, backlightTimeout) || other.backlightTimeout == backlightTimeout)&&(identical(other.squelchLevel, squelchLevel) || other.squelchLevel == squelchLevel)&&(identical(other.voxLevel, voxLevel) || other.voxLevel == voxLevel)&&(identical(other.voxEnabled, voxEnabled) || other.voxEnabled == voxEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dmrId,callsign,introLine1,introLine2,keyTone,backlightTimeout,squelchLevel,voxLevel,voxEnabled);

@override
String toString() {
  return 'RadioSettings(dmrId: $dmrId, callsign: $callsign, introLine1: $introLine1, introLine2: $introLine2, keyTone: $keyTone, backlightTimeout: $backlightTimeout, squelchLevel: $squelchLevel, voxLevel: $voxLevel, voxEnabled: $voxEnabled)';
}


}

/// @nodoc
abstract mixin class $RadioSettingsCopyWith<$Res>  {
  factory $RadioSettingsCopyWith(RadioSettings value, $Res Function(RadioSettings) _then) = _$RadioSettingsCopyWithImpl;
@useResult
$Res call({
 int dmrId, String callsign, String introLine1, String introLine2, bool keyTone, int backlightTimeout, int squelchLevel, int voxLevel, bool voxEnabled
});




}
/// @nodoc
class _$RadioSettingsCopyWithImpl<$Res>
    implements $RadioSettingsCopyWith<$Res> {
  _$RadioSettingsCopyWithImpl(this._self, this._then);

  final RadioSettings _self;
  final $Res Function(RadioSettings) _then;

/// Create a copy of RadioSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dmrId = null,Object? callsign = null,Object? introLine1 = null,Object? introLine2 = null,Object? keyTone = null,Object? backlightTimeout = null,Object? squelchLevel = null,Object? voxLevel = null,Object? voxEnabled = null,}) {
  return _then(_self.copyWith(
dmrId: null == dmrId ? _self.dmrId : dmrId // ignore: cast_nullable_to_non_nullable
as int,callsign: null == callsign ? _self.callsign : callsign // ignore: cast_nullable_to_non_nullable
as String,introLine1: null == introLine1 ? _self.introLine1 : introLine1 // ignore: cast_nullable_to_non_nullable
as String,introLine2: null == introLine2 ? _self.introLine2 : introLine2 // ignore: cast_nullable_to_non_nullable
as String,keyTone: null == keyTone ? _self.keyTone : keyTone // ignore: cast_nullable_to_non_nullable
as bool,backlightTimeout: null == backlightTimeout ? _self.backlightTimeout : backlightTimeout // ignore: cast_nullable_to_non_nullable
as int,squelchLevel: null == squelchLevel ? _self.squelchLevel : squelchLevel // ignore: cast_nullable_to_non_nullable
as int,voxLevel: null == voxLevel ? _self.voxLevel : voxLevel // ignore: cast_nullable_to_non_nullable
as int,voxEnabled: null == voxEnabled ? _self.voxEnabled : voxEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RadioSettings].
extension RadioSettingsPatterns on RadioSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RadioSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RadioSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RadioSettings value)  $default,){
final _that = this;
switch (_that) {
case _RadioSettings():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RadioSettings value)?  $default,){
final _that = this;
switch (_that) {
case _RadioSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dmrId,  String callsign,  String introLine1,  String introLine2,  bool keyTone,  int backlightTimeout,  int squelchLevel,  int voxLevel,  bool voxEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RadioSettings() when $default != null:
return $default(_that.dmrId,_that.callsign,_that.introLine1,_that.introLine2,_that.keyTone,_that.backlightTimeout,_that.squelchLevel,_that.voxLevel,_that.voxEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dmrId,  String callsign,  String introLine1,  String introLine2,  bool keyTone,  int backlightTimeout,  int squelchLevel,  int voxLevel,  bool voxEnabled)  $default,) {final _that = this;
switch (_that) {
case _RadioSettings():
return $default(_that.dmrId,_that.callsign,_that.introLine1,_that.introLine2,_that.keyTone,_that.backlightTimeout,_that.squelchLevel,_that.voxLevel,_that.voxEnabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dmrId,  String callsign,  String introLine1,  String introLine2,  bool keyTone,  int backlightTimeout,  int squelchLevel,  int voxLevel,  bool voxEnabled)?  $default,) {final _that = this;
switch (_that) {
case _RadioSettings() when $default != null:
return $default(_that.dmrId,_that.callsign,_that.introLine1,_that.introLine2,_that.keyTone,_that.backlightTimeout,_that.squelchLevel,_that.voxLevel,_that.voxEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RadioSettings implements RadioSettings {
  const _RadioSettings({this.dmrId = 0, this.callsign = '', this.introLine1 = 'Ndmr', this.introLine2 = '', this.keyTone = true, this.backlightTimeout = 5, this.squelchLevel = 3, this.voxLevel = 5, this.voxEnabled = false});
  factory _RadioSettings.fromJson(Map<String, dynamic> json) => _$RadioSettingsFromJson(json);

@override@JsonKey() final  int dmrId;
@override@JsonKey() final  String callsign;
@override@JsonKey() final  String introLine1;
@override@JsonKey() final  String introLine2;
@override@JsonKey() final  bool keyTone;
@override@JsonKey() final  int backlightTimeout;
@override@JsonKey() final  int squelchLevel;
@override@JsonKey() final  int voxLevel;
@override@JsonKey() final  bool voxEnabled;

/// Create a copy of RadioSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RadioSettingsCopyWith<_RadioSettings> get copyWith => __$RadioSettingsCopyWithImpl<_RadioSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RadioSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RadioSettings&&(identical(other.dmrId, dmrId) || other.dmrId == dmrId)&&(identical(other.callsign, callsign) || other.callsign == callsign)&&(identical(other.introLine1, introLine1) || other.introLine1 == introLine1)&&(identical(other.introLine2, introLine2) || other.introLine2 == introLine2)&&(identical(other.keyTone, keyTone) || other.keyTone == keyTone)&&(identical(other.backlightTimeout, backlightTimeout) || other.backlightTimeout == backlightTimeout)&&(identical(other.squelchLevel, squelchLevel) || other.squelchLevel == squelchLevel)&&(identical(other.voxLevel, voxLevel) || other.voxLevel == voxLevel)&&(identical(other.voxEnabled, voxEnabled) || other.voxEnabled == voxEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dmrId,callsign,introLine1,introLine2,keyTone,backlightTimeout,squelchLevel,voxLevel,voxEnabled);

@override
String toString() {
  return 'RadioSettings(dmrId: $dmrId, callsign: $callsign, introLine1: $introLine1, introLine2: $introLine2, keyTone: $keyTone, backlightTimeout: $backlightTimeout, squelchLevel: $squelchLevel, voxLevel: $voxLevel, voxEnabled: $voxEnabled)';
}


}

/// @nodoc
abstract mixin class _$RadioSettingsCopyWith<$Res> implements $RadioSettingsCopyWith<$Res> {
  factory _$RadioSettingsCopyWith(_RadioSettings value, $Res Function(_RadioSettings) _then) = __$RadioSettingsCopyWithImpl;
@override @useResult
$Res call({
 int dmrId, String callsign, String introLine1, String introLine2, bool keyTone, int backlightTimeout, int squelchLevel, int voxLevel, bool voxEnabled
});




}
/// @nodoc
class __$RadioSettingsCopyWithImpl<$Res>
    implements _$RadioSettingsCopyWith<$Res> {
  __$RadioSettingsCopyWithImpl(this._self, this._then);

  final _RadioSettings _self;
  final $Res Function(_RadioSettings) _then;

/// Create a copy of RadioSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dmrId = null,Object? callsign = null,Object? introLine1 = null,Object? introLine2 = null,Object? keyTone = null,Object? backlightTimeout = null,Object? squelchLevel = null,Object? voxLevel = null,Object? voxEnabled = null,}) {
  return _then(_RadioSettings(
dmrId: null == dmrId ? _self.dmrId : dmrId // ignore: cast_nullable_to_non_nullable
as int,callsign: null == callsign ? _self.callsign : callsign // ignore: cast_nullable_to_non_nullable
as String,introLine1: null == introLine1 ? _self.introLine1 : introLine1 // ignore: cast_nullable_to_non_nullable
as String,introLine2: null == introLine2 ? _self.introLine2 : introLine2 // ignore: cast_nullable_to_non_nullable
as String,keyTone: null == keyTone ? _self.keyTone : keyTone // ignore: cast_nullable_to_non_nullable
as bool,backlightTimeout: null == backlightTimeout ? _self.backlightTimeout : backlightTimeout // ignore: cast_nullable_to_non_nullable
as int,squelchLevel: null == squelchLevel ? _self.squelchLevel : squelchLevel // ignore: cast_nullable_to_non_nullable
as int,voxLevel: null == voxLevel ? _self.voxLevel : voxLevel // ignore: cast_nullable_to_non_nullable
as int,voxEnabled: null == voxEnabled ? _self.voxEnabled : voxEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
