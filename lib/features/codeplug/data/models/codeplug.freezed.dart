// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'codeplug.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Codeplug {

 String get id; String get name; String get radioModel; List<Channel> get channels; List<Zone> get zones; List<Contact> get contacts; List<ScanList> get scanLists; RadioSettings get settings; DateTime? get createdAt; DateTime? get modifiedAt;
/// Create a copy of Codeplug
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeplugCopyWith<Codeplug> get copyWith => _$CodeplugCopyWithImpl<Codeplug>(this as Codeplug, _$identity);

  /// Serializes this Codeplug to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Codeplug&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.radioModel, radioModel) || other.radioModel == radioModel)&&const DeepCollectionEquality().equals(other.channels, channels)&&const DeepCollectionEquality().equals(other.zones, zones)&&const DeepCollectionEquality().equals(other.contacts, contacts)&&const DeepCollectionEquality().equals(other.scanLists, scanLists)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,radioModel,const DeepCollectionEquality().hash(channels),const DeepCollectionEquality().hash(zones),const DeepCollectionEquality().hash(contacts),const DeepCollectionEquality().hash(scanLists),settings,createdAt,modifiedAt);

@override
String toString() {
  return 'Codeplug(id: $id, name: $name, radioModel: $radioModel, channels: $channels, zones: $zones, contacts: $contacts, scanLists: $scanLists, settings: $settings, createdAt: $createdAt, modifiedAt: $modifiedAt)';
}


}

/// @nodoc
abstract mixin class $CodeplugCopyWith<$Res>  {
  factory $CodeplugCopyWith(Codeplug value, $Res Function(Codeplug) _then) = _$CodeplugCopyWithImpl;
@useResult
$Res call({
 String id, String name, String radioModel, List<Channel> channels, List<Zone> zones, List<Contact> contacts, List<ScanList> scanLists, RadioSettings settings, DateTime? createdAt, DateTime? modifiedAt
});


$RadioSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$CodeplugCopyWithImpl<$Res>
    implements $CodeplugCopyWith<$Res> {
  _$CodeplugCopyWithImpl(this._self, this._then);

  final Codeplug _self;
  final $Res Function(Codeplug) _then;

/// Create a copy of Codeplug
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? radioModel = null,Object? channels = null,Object? zones = null,Object? contacts = null,Object? scanLists = null,Object? settings = null,Object? createdAt = freezed,Object? modifiedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,radioModel: null == radioModel ? _self.radioModel : radioModel // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<Channel>,zones: null == zones ? _self.zones : zones // ignore: cast_nullable_to_non_nullable
as List<Zone>,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<Contact>,scanLists: null == scanLists ? _self.scanLists : scanLists // ignore: cast_nullable_to_non_nullable
as List<ScanList>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RadioSettings,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,modifiedAt: freezed == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Codeplug
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadioSettingsCopyWith<$Res> get settings {
  
  return $RadioSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [Codeplug].
extension CodeplugPatterns on Codeplug {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Codeplug value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Codeplug() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Codeplug value)  $default,){
final _that = this;
switch (_that) {
case _Codeplug():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Codeplug value)?  $default,){
final _that = this;
switch (_that) {
case _Codeplug() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String radioModel,  List<Channel> channels,  List<Zone> zones,  List<Contact> contacts,  List<ScanList> scanLists,  RadioSettings settings,  DateTime? createdAt,  DateTime? modifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Codeplug() when $default != null:
return $default(_that.id,_that.name,_that.radioModel,_that.channels,_that.zones,_that.contacts,_that.scanLists,_that.settings,_that.createdAt,_that.modifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String radioModel,  List<Channel> channels,  List<Zone> zones,  List<Contact> contacts,  List<ScanList> scanLists,  RadioSettings settings,  DateTime? createdAt,  DateTime? modifiedAt)  $default,) {final _that = this;
switch (_that) {
case _Codeplug():
return $default(_that.id,_that.name,_that.radioModel,_that.channels,_that.zones,_that.contacts,_that.scanLists,_that.settings,_that.createdAt,_that.modifiedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String radioModel,  List<Channel> channels,  List<Zone> zones,  List<Contact> contacts,  List<ScanList> scanLists,  RadioSettings settings,  DateTime? createdAt,  DateTime? modifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _Codeplug() when $default != null:
return $default(_that.id,_that.name,_that.radioModel,_that.channels,_that.zones,_that.contacts,_that.scanLists,_that.settings,_that.createdAt,_that.modifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Codeplug extends Codeplug {
  const _Codeplug({required this.id, this.name = 'New Codeplug', this.radioModel = 'Anytone AT-D878UV', final  List<Channel> channels = const [], final  List<Zone> zones = const [], final  List<Contact> contacts = const [], final  List<ScanList> scanLists = const [], this.settings = const RadioSettings(), this.createdAt, this.modifiedAt}): _channels = channels,_zones = zones,_contacts = contacts,_scanLists = scanLists,super._();
  factory _Codeplug.fromJson(Map<String, dynamic> json) => _$CodeplugFromJson(json);

@override final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String radioModel;
 final  List<Channel> _channels;
@override@JsonKey() List<Channel> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

 final  List<Zone> _zones;
@override@JsonKey() List<Zone> get zones {
  if (_zones is EqualUnmodifiableListView) return _zones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_zones);
}

 final  List<Contact> _contacts;
@override@JsonKey() List<Contact> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

 final  List<ScanList> _scanLists;
@override@JsonKey() List<ScanList> get scanLists {
  if (_scanLists is EqualUnmodifiableListView) return _scanLists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scanLists);
}

@override@JsonKey() final  RadioSettings settings;
@override final  DateTime? createdAt;
@override final  DateTime? modifiedAt;

/// Create a copy of Codeplug
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CodeplugCopyWith<_Codeplug> get copyWith => __$CodeplugCopyWithImpl<_Codeplug>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CodeplugToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Codeplug&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.radioModel, radioModel) || other.radioModel == radioModel)&&const DeepCollectionEquality().equals(other._channels, _channels)&&const DeepCollectionEquality().equals(other._zones, _zones)&&const DeepCollectionEquality().equals(other._contacts, _contacts)&&const DeepCollectionEquality().equals(other._scanLists, _scanLists)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,radioModel,const DeepCollectionEquality().hash(_channels),const DeepCollectionEquality().hash(_zones),const DeepCollectionEquality().hash(_contacts),const DeepCollectionEquality().hash(_scanLists),settings,createdAt,modifiedAt);

@override
String toString() {
  return 'Codeplug(id: $id, name: $name, radioModel: $radioModel, channels: $channels, zones: $zones, contacts: $contacts, scanLists: $scanLists, settings: $settings, createdAt: $createdAt, modifiedAt: $modifiedAt)';
}


}

/// @nodoc
abstract mixin class _$CodeplugCopyWith<$Res> implements $CodeplugCopyWith<$Res> {
  factory _$CodeplugCopyWith(_Codeplug value, $Res Function(_Codeplug) _then) = __$CodeplugCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String radioModel, List<Channel> channels, List<Zone> zones, List<Contact> contacts, List<ScanList> scanLists, RadioSettings settings, DateTime? createdAt, DateTime? modifiedAt
});


@override $RadioSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$CodeplugCopyWithImpl<$Res>
    implements _$CodeplugCopyWith<$Res> {
  __$CodeplugCopyWithImpl(this._self, this._then);

  final _Codeplug _self;
  final $Res Function(_Codeplug) _then;

/// Create a copy of Codeplug
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? radioModel = null,Object? channels = null,Object? zones = null,Object? contacts = null,Object? scanLists = null,Object? settings = null,Object? createdAt = freezed,Object? modifiedAt = freezed,}) {
  return _then(_Codeplug(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,radioModel: null == radioModel ? _self.radioModel : radioModel // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<Channel>,zones: null == zones ? _self._zones : zones // ignore: cast_nullable_to_non_nullable
as List<Zone>,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<Contact>,scanLists: null == scanLists ? _self._scanLists : scanLists // ignore: cast_nullable_to_non_nullable
as List<ScanList>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as RadioSettings,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,modifiedAt: freezed == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Codeplug
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RadioSettingsCopyWith<$Res> get settings {
  
  return $RadioSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
