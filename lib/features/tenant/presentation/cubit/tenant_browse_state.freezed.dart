// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tenant_browse_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TenantBrowseState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantBrowseState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TenantBrowseState()';
}


}

/// @nodoc
class $TenantBrowseStateCopyWith<$Res>  {
$TenantBrowseStateCopyWith(TenantBrowseState _, $Res Function(TenantBrowseState) __);
}


/// Adds pattern-matching-related methods to [TenantBrowseState].
extension TenantBrowseStatePatterns on TenantBrowseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TenantBrowseInitial value)?  initial,TResult Function( TenantBrowseLoading value)?  loading,TResult Function( TenantBrowseLoaded value)?  loaded,TResult Function( TenantBrowseError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TenantBrowseInitial() when initial != null:
return initial(_that);case TenantBrowseLoading() when loading != null:
return loading(_that);case TenantBrowseLoaded() when loaded != null:
return loaded(_that);case TenantBrowseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TenantBrowseInitial value)  initial,required TResult Function( TenantBrowseLoading value)  loading,required TResult Function( TenantBrowseLoaded value)  loaded,required TResult Function( TenantBrowseError value)  error,}){
final _that = this;
switch (_that) {
case TenantBrowseInitial():
return initial(_that);case TenantBrowseLoading():
return loading(_that);case TenantBrowseLoaded():
return loaded(_that);case TenantBrowseError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TenantBrowseInitial value)?  initial,TResult? Function( TenantBrowseLoading value)?  loading,TResult? Function( TenantBrowseLoaded value)?  loaded,TResult? Function( TenantBrowseError value)?  error,}){
final _that = this;
switch (_that) {
case TenantBrowseInitial() when initial != null:
return initial(_that);case TenantBrowseLoading() when loading != null:
return loading(_that);case TenantBrowseLoaded() when loaded != null:
return loaded(_that);case TenantBrowseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PropertyEntity> properties,  String? currentQuery,  num? minPrice,  num? maxPrice,  int? bedrooms,  bool? isFurnished,  String? district)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TenantBrowseInitial() when initial != null:
return initial();case TenantBrowseLoading() when loading != null:
return loading();case TenantBrowseLoaded() when loaded != null:
return loaded(_that.properties,_that.currentQuery,_that.minPrice,_that.maxPrice,_that.bedrooms,_that.isFurnished,_that.district);case TenantBrowseError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PropertyEntity> properties,  String? currentQuery,  num? minPrice,  num? maxPrice,  int? bedrooms,  bool? isFurnished,  String? district)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case TenantBrowseInitial():
return initial();case TenantBrowseLoading():
return loading();case TenantBrowseLoaded():
return loaded(_that.properties,_that.currentQuery,_that.minPrice,_that.maxPrice,_that.bedrooms,_that.isFurnished,_that.district);case TenantBrowseError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PropertyEntity> properties,  String? currentQuery,  num? minPrice,  num? maxPrice,  int? bedrooms,  bool? isFurnished,  String? district)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case TenantBrowseInitial() when initial != null:
return initial();case TenantBrowseLoading() when loading != null:
return loading();case TenantBrowseLoaded() when loaded != null:
return loaded(_that.properties,_that.currentQuery,_that.minPrice,_that.maxPrice,_that.bedrooms,_that.isFurnished,_that.district);case TenantBrowseError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class TenantBrowseInitial implements TenantBrowseState {
  const TenantBrowseInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantBrowseInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TenantBrowseState.initial()';
}


}




/// @nodoc


class TenantBrowseLoading implements TenantBrowseState {
  const TenantBrowseLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantBrowseLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TenantBrowseState.loading()';
}


}




/// @nodoc


class TenantBrowseLoaded implements TenantBrowseState {
  const TenantBrowseLoaded({required  List<PropertyEntity> properties, this.currentQuery, this.minPrice, this.maxPrice, this.bedrooms, this.isFurnished, this.district}): _properties = properties;
  

 final  List<PropertyEntity> _properties;
 List<PropertyEntity> get properties {
  if (_properties is EqualUnmodifiableListView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_properties);
}

 final  String? currentQuery;
 final  num? minPrice;
 final  num? maxPrice;
 final  int? bedrooms;
 final  bool? isFurnished;
 final  String? district;

/// Create a copy of TenantBrowseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TenantBrowseLoadedCopyWith<TenantBrowseLoaded> get copyWith => _$TenantBrowseLoadedCopyWithImpl<TenantBrowseLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantBrowseLoaded&&const DeepCollectionEquality().equals(other.properties, _properties)&&(identical(other.currentQuery, currentQuery) || other.currentQuery == currentQuery)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.isFurnished, isFurnished) || other.isFurnished == isFurnished)&&(identical(other.district, district) || other.district == district));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_properties),currentQuery,minPrice,maxPrice,bedrooms,isFurnished,district);
}

@override
String toString() {
    return 'TenantBrowseState.loaded(properties: $properties, currentQuery: $currentQuery, minPrice: $minPrice, maxPrice: $maxPrice, bedrooms: $bedrooms, isFurnished: $isFurnished, district: $district)';
}


}

/// @nodoc
abstract mixin class $TenantBrowseLoadedCopyWith<$Res> implements $TenantBrowseStateCopyWith<$Res> {
  factory $TenantBrowseLoadedCopyWith(TenantBrowseLoaded value, $Res Function(TenantBrowseLoaded) _then) = _$TenantBrowseLoadedCopyWithImpl;
@useResult
$Res call({
 List<PropertyEntity> properties, String? currentQuery, num? minPrice, num? maxPrice, int? bedrooms, bool? isFurnished, String? district
});




}
/// @nodoc
class _$TenantBrowseLoadedCopyWithImpl<$Res>
    implements $TenantBrowseLoadedCopyWith<$Res> {
  _$TenantBrowseLoadedCopyWithImpl(this._self, this._then);

  final TenantBrowseLoaded _self;
  final $Res Function(TenantBrowseLoaded) _then;

/// Create a copy of TenantBrowseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? properties = null,Object? currentQuery = freezed,Object? minPrice = freezed,Object? maxPrice = freezed,Object? bedrooms = freezed,Object? isFurnished = freezed,Object? district = freezed,}) {
  return _then(TenantBrowseLoaded(
properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as List<PropertyEntity>,currentQuery: freezed == currentQuery ? _self.currentQuery : currentQuery // ignore: cast_nullable_to_non_nullable
as String?,minPrice: freezed == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as num?,maxPrice: freezed == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as num?,bedrooms: freezed == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int?,isFurnished: freezed == isFurnished ? _self.isFurnished : isFurnished // ignore: cast_nullable_to_non_nullable
as bool?,district: freezed == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TenantBrowseError implements TenantBrowseState {
  const TenantBrowseError(this.message);
  

 final  String message;

/// Create a copy of TenantBrowseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TenantBrowseErrorCopyWith<TenantBrowseError> get copyWith => _$TenantBrowseErrorCopyWithImpl<TenantBrowseError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TenantBrowseError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'TenantBrowseState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TenantBrowseErrorCopyWith<$Res> implements $TenantBrowseStateCopyWith<$Res> {
  factory $TenantBrowseErrorCopyWith(TenantBrowseError value, $Res Function(TenantBrowseError) _then) = _$TenantBrowseErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TenantBrowseErrorCopyWithImpl<$Res>
    implements $TenantBrowseErrorCopyWith<$Res> {
  _$TenantBrowseErrorCopyWithImpl(this._self, this._then);

  final TenantBrowseError _self;
  final $Res Function(TenantBrowseError) _then;

/// Create a copy of TenantBrowseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TenantBrowseError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
