// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanList {

 String get id; String get name; List<String> get channelIds; String? get priorityChannelId;
/// Create a copy of ScanList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanListCopyWith<ScanList> get copyWith => _$ScanListCopyWithImpl<ScanList>(this as ScanList, _$identity);

  /// Serializes this ScanList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanList&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.channelIds, channelIds)&&(identical(other.priorityChannelId, priorityChannelId) || other.priorityChannelId == priorityChannelId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(channelIds),priorityChannelId);

@override
String toString() {
  return 'ScanList(id: $id, name: $name, channelIds: $channelIds, priorityChannelId: $priorityChannelId)';
}


}

/// @nodoc
abstract mixin class $ScanListCopyWith<$Res>  {
  factory $ScanListCopyWith(ScanList value, $Res Function(ScanList) _then) = _$ScanListCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> channelIds, String? priorityChannelId
});




}
/// @nodoc
class _$ScanListCopyWithImpl<$Res>
    implements $ScanListCopyWith<$Res> {
  _$ScanListCopyWithImpl(this._self, this._then);

  final ScanList _self;
  final $Res Function(ScanList) _then;

/// Create a copy of ScanList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? channelIds = null,Object? priorityChannelId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,channelIds: null == channelIds ? _self.channelIds : channelIds // ignore: cast_nullable_to_non_nullable
as List<String>,priorityChannelId: freezed == priorityChannelId ? _self.priorityChannelId : priorityChannelId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanList].
extension ScanListPatterns on ScanList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanList value)  $default,){
final _that = this;
switch (_that) {
case _ScanList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanList value)?  $default,){
final _that = this;
switch (_that) {
case _ScanList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> channelIds,  String? priorityChannelId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanList() when $default != null:
return $default(_that.id,_that.name,_that.channelIds,_that.priorityChannelId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> channelIds,  String? priorityChannelId)  $default,) {final _that = this;
switch (_that) {
case _ScanList():
return $default(_that.id,_that.name,_that.channelIds,_that.priorityChannelId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> channelIds,  String? priorityChannelId)?  $default,) {final _that = this;
switch (_that) {
case _ScanList() when $default != null:
return $default(_that.id,_that.name,_that.channelIds,_that.priorityChannelId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanList implements ScanList {
  const _ScanList({required this.id, required this.name, final  List<String> channelIds = const [], this.priorityChannelId}): _channelIds = channelIds;
  factory _ScanList.fromJson(Map<String, dynamic> json) => _$ScanListFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _channelIds;
@override@JsonKey() List<String> get channelIds {
  if (_channelIds is EqualUnmodifiableListView) return _channelIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channelIds);
}

@override final  String? priorityChannelId;

/// Create a copy of ScanList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanListCopyWith<_ScanList> get copyWith => __$ScanListCopyWithImpl<_ScanList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanList&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._channelIds, _channelIds)&&(identical(other.priorityChannelId, priorityChannelId) || other.priorityChannelId == priorityChannelId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_channelIds),priorityChannelId);

@override
String toString() {
  return 'ScanList(id: $id, name: $name, channelIds: $channelIds, priorityChannelId: $priorityChannelId)';
}


}

/// @nodoc
abstract mixin class _$ScanListCopyWith<$Res> implements $ScanListCopyWith<$Res> {
  factory _$ScanListCopyWith(_ScanList value, $Res Function(_ScanList) _then) = __$ScanListCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> channelIds, String? priorityChannelId
});




}
/// @nodoc
class __$ScanListCopyWithImpl<$Res>
    implements _$ScanListCopyWith<$Res> {
  __$ScanListCopyWithImpl(this._self, this._then);

  final _ScanList _self;
  final $Res Function(_ScanList) _then;

/// Create a copy of ScanList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? channelIds = null,Object? priorityChannelId = freezed,}) {
  return _then(_ScanList(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,channelIds: null == channelIds ? _self._channelIds : channelIds // ignore: cast_nullable_to_non_nullable
as List<String>,priorityChannelId: freezed == priorityChannelId ? _self.priorityChannelId : priorityChannelId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
