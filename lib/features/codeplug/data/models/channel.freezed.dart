// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Channel {

 String get id; String get name; double get rxFrequency; double get txFrequency; ChannelMode get mode; Power get power; Bandwidth get bandwidth;// DMR specific
 int get timeslot; int get colorCode; String? get contactId;// Analog specific
 double? get rxTone; double? get txTone;// Optional
 String? get scanListId; String? get zoneId;
/// Create a copy of Channel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChannelCopyWith<Channel> get copyWith => _$ChannelCopyWithImpl<Channel>(this as Channel, _$identity);

  /// Serializes this Channel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Channel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.rxFrequency, rxFrequency) || other.rxFrequency == rxFrequency)&&(identical(other.txFrequency, txFrequency) || other.txFrequency == txFrequency)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.power, power) || other.power == power)&&(identical(other.bandwidth, bandwidth) || other.bandwidth == bandwidth)&&(identical(other.timeslot, timeslot) || other.timeslot == timeslot)&&(identical(other.colorCode, colorCode) || other.colorCode == colorCode)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.rxTone, rxTone) || other.rxTone == rxTone)&&(identical(other.txTone, txTone) || other.txTone == txTone)&&(identical(other.scanListId, scanListId) || other.scanListId == scanListId)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,rxFrequency,txFrequency,mode,power,bandwidth,timeslot,colorCode,contactId,rxTone,txTone,scanListId,zoneId);

@override
String toString() {
  return 'Channel(id: $id, name: $name, rxFrequency: $rxFrequency, txFrequency: $txFrequency, mode: $mode, power: $power, bandwidth: $bandwidth, timeslot: $timeslot, colorCode: $colorCode, contactId: $contactId, rxTone: $rxTone, txTone: $txTone, scanListId: $scanListId, zoneId: $zoneId)';
}


}

/// @nodoc
abstract mixin class $ChannelCopyWith<$Res>  {
  factory $ChannelCopyWith(Channel value, $Res Function(Channel) _then) = _$ChannelCopyWithImpl;
@useResult
$Res call({
 String id, String name, double rxFrequency, double txFrequency, ChannelMode mode, Power power, Bandwidth bandwidth, int timeslot, int colorCode, String? contactId, double? rxTone, double? txTone, String? scanListId, String? zoneId
});




}
/// @nodoc
class _$ChannelCopyWithImpl<$Res>
    implements $ChannelCopyWith<$Res> {
  _$ChannelCopyWithImpl(this._self, this._then);

  final Channel _self;
  final $Res Function(Channel) _then;

/// Create a copy of Channel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? rxFrequency = null,Object? txFrequency = null,Object? mode = null,Object? power = null,Object? bandwidth = null,Object? timeslot = null,Object? colorCode = null,Object? contactId = freezed,Object? rxTone = freezed,Object? txTone = freezed,Object? scanListId = freezed,Object? zoneId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rxFrequency: null == rxFrequency ? _self.rxFrequency : rxFrequency // ignore: cast_nullable_to_non_nullable
as double,txFrequency: null == txFrequency ? _self.txFrequency : txFrequency // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ChannelMode,power: null == power ? _self.power : power // ignore: cast_nullable_to_non_nullable
as Power,bandwidth: null == bandwidth ? _self.bandwidth : bandwidth // ignore: cast_nullable_to_non_nullable
as Bandwidth,timeslot: null == timeslot ? _self.timeslot : timeslot // ignore: cast_nullable_to_non_nullable
as int,colorCode: null == colorCode ? _self.colorCode : colorCode // ignore: cast_nullable_to_non_nullable
as int,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,rxTone: freezed == rxTone ? _self.rxTone : rxTone // ignore: cast_nullable_to_non_nullable
as double?,txTone: freezed == txTone ? _self.txTone : txTone // ignore: cast_nullable_to_non_nullable
as double?,scanListId: freezed == scanListId ? _self.scanListId : scanListId // ignore: cast_nullable_to_non_nullable
as String?,zoneId: freezed == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Channel].
extension ChannelPatterns on Channel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Channel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Channel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Channel value)  $default,){
final _that = this;
switch (_that) {
case _Channel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Channel value)?  $default,){
final _that = this;
switch (_that) {
case _Channel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double rxFrequency,  double txFrequency,  ChannelMode mode,  Power power,  Bandwidth bandwidth,  int timeslot,  int colorCode,  String? contactId,  double? rxTone,  double? txTone,  String? scanListId,  String? zoneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Channel() when $default != null:
return $default(_that.id,_that.name,_that.rxFrequency,_that.txFrequency,_that.mode,_that.power,_that.bandwidth,_that.timeslot,_that.colorCode,_that.contactId,_that.rxTone,_that.txTone,_that.scanListId,_that.zoneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double rxFrequency,  double txFrequency,  ChannelMode mode,  Power power,  Bandwidth bandwidth,  int timeslot,  int colorCode,  String? contactId,  double? rxTone,  double? txTone,  String? scanListId,  String? zoneId)  $default,) {final _that = this;
switch (_that) {
case _Channel():
return $default(_that.id,_that.name,_that.rxFrequency,_that.txFrequency,_that.mode,_that.power,_that.bandwidth,_that.timeslot,_that.colorCode,_that.contactId,_that.rxTone,_that.txTone,_that.scanListId,_that.zoneId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double rxFrequency,  double txFrequency,  ChannelMode mode,  Power power,  Bandwidth bandwidth,  int timeslot,  int colorCode,  String? contactId,  double? rxTone,  double? txTone,  String? scanListId,  String? zoneId)?  $default,) {final _that = this;
switch (_that) {
case _Channel() when $default != null:
return $default(_that.id,_that.name,_that.rxFrequency,_that.txFrequency,_that.mode,_that.power,_that.bandwidth,_that.timeslot,_that.colorCode,_that.contactId,_that.rxTone,_that.txTone,_that.scanListId,_that.zoneId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Channel implements Channel {
  const _Channel({required this.id, required this.name, required this.rxFrequency, required this.txFrequency, this.mode = ChannelMode.digital, this.power = Power.high, this.bandwidth = Bandwidth.narrow, this.timeslot = 1, this.colorCode = 1, this.contactId, this.rxTone, this.txTone, this.scanListId, this.zoneId});
  factory _Channel.fromJson(Map<String, dynamic> json) => _$ChannelFromJson(json);

@override final  String id;
@override final  String name;
@override final  double rxFrequency;
@override final  double txFrequency;
@override@JsonKey() final  ChannelMode mode;
@override@JsonKey() final  Power power;
@override@JsonKey() final  Bandwidth bandwidth;
// DMR specific
@override@JsonKey() final  int timeslot;
@override@JsonKey() final  int colorCode;
@override final  String? contactId;
// Analog specific
@override final  double? rxTone;
@override final  double? txTone;
// Optional
@override final  String? scanListId;
@override final  String? zoneId;

/// Create a copy of Channel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChannelCopyWith<_Channel> get copyWith => __$ChannelCopyWithImpl<_Channel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChannelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Channel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.rxFrequency, rxFrequency) || other.rxFrequency == rxFrequency)&&(identical(other.txFrequency, txFrequency) || other.txFrequency == txFrequency)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.power, power) || other.power == power)&&(identical(other.bandwidth, bandwidth) || other.bandwidth == bandwidth)&&(identical(other.timeslot, timeslot) || other.timeslot == timeslot)&&(identical(other.colorCode, colorCode) || other.colorCode == colorCode)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.rxTone, rxTone) || other.rxTone == rxTone)&&(identical(other.txTone, txTone) || other.txTone == txTone)&&(identical(other.scanListId, scanListId) || other.scanListId == scanListId)&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,rxFrequency,txFrequency,mode,power,bandwidth,timeslot,colorCode,contactId,rxTone,txTone,scanListId,zoneId);

@override
String toString() {
  return 'Channel(id: $id, name: $name, rxFrequency: $rxFrequency, txFrequency: $txFrequency, mode: $mode, power: $power, bandwidth: $bandwidth, timeslot: $timeslot, colorCode: $colorCode, contactId: $contactId, rxTone: $rxTone, txTone: $txTone, scanListId: $scanListId, zoneId: $zoneId)';
}


}

/// @nodoc
abstract mixin class _$ChannelCopyWith<$Res> implements $ChannelCopyWith<$Res> {
  factory _$ChannelCopyWith(_Channel value, $Res Function(_Channel) _then) = __$ChannelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double rxFrequency, double txFrequency, ChannelMode mode, Power power, Bandwidth bandwidth, int timeslot, int colorCode, String? contactId, double? rxTone, double? txTone, String? scanListId, String? zoneId
});




}
/// @nodoc
class __$ChannelCopyWithImpl<$Res>
    implements _$ChannelCopyWith<$Res> {
  __$ChannelCopyWithImpl(this._self, this._then);

  final _Channel _self;
  final $Res Function(_Channel) _then;

/// Create a copy of Channel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? rxFrequency = null,Object? txFrequency = null,Object? mode = null,Object? power = null,Object? bandwidth = null,Object? timeslot = null,Object? colorCode = null,Object? contactId = freezed,Object? rxTone = freezed,Object? txTone = freezed,Object? scanListId = freezed,Object? zoneId = freezed,}) {
  return _then(_Channel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rxFrequency: null == rxFrequency ? _self.rxFrequency : rxFrequency // ignore: cast_nullable_to_non_nullable
as double,txFrequency: null == txFrequency ? _self.txFrequency : txFrequency // ignore: cast_nullable_to_non_nullable
as double,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ChannelMode,power: null == power ? _self.power : power // ignore: cast_nullable_to_non_nullable
as Power,bandwidth: null == bandwidth ? _self.bandwidth : bandwidth // ignore: cast_nullable_to_non_nullable
as Bandwidth,timeslot: null == timeslot ? _self.timeslot : timeslot // ignore: cast_nullable_to_non_nullable
as int,colorCode: null == colorCode ? _self.colorCode : colorCode // ignore: cast_nullable_to_non_nullable
as int,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,rxTone: freezed == rxTone ? _self.rxTone : rxTone // ignore: cast_nullable_to_non_nullable
as double?,txTone: freezed == txTone ? _self.txTone : txTone // ignore: cast_nullable_to_non_nullable
as double?,scanListId: freezed == scanListId ? _self.scanListId : scanListId // ignore: cast_nullable_to_non_nullable
as String?,zoneId: freezed == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
