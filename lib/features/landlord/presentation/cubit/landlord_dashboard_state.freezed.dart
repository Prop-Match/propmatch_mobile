// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landlord_dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LandlordDashboardState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LandlordDashboardState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LandlordDashboardState()';
}


}

/// @nodoc
class $LandlordDashboardStateCopyWith<$Res>  {
$LandlordDashboardStateCopyWith(LandlordDashboardState _, $Res Function(LandlordDashboardState) __);
}


/// Adds pattern-matching-related methods to [LandlordDashboardState].
extension LandlordDashboardStatePatterns on LandlordDashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LandlordDashboardInitial value)?  initial,TResult Function( LandlordDashboardLoading value)?  loading,TResult Function( LandlordDashboardLoaded value)?  loaded,TResult Function( LandlordDashboardError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LandlordDashboardInitial() when initial != null:
return initial(_that);case LandlordDashboardLoading() when loading != null:
return loading(_that);case LandlordDashboardLoaded() when loaded != null:
return loaded(_that);case LandlordDashboardError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LandlordDashboardInitial value)  initial,required TResult Function( LandlordDashboardLoading value)  loading,required TResult Function( LandlordDashboardLoaded value)  loaded,required TResult Function( LandlordDashboardError value)  error,}){
final _that = this;
switch (_that) {
case LandlordDashboardInitial():
return initial(_that);case LandlordDashboardLoading():
return loading(_that);case LandlordDashboardLoaded():
return loaded(_that);case LandlordDashboardError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LandlordDashboardInitial value)?  initial,TResult? Function( LandlordDashboardLoading value)?  loading,TResult? Function( LandlordDashboardLoaded value)?  loaded,TResult? Function( LandlordDashboardError value)?  error,}){
final _that = this;
switch (_that) {
case LandlordDashboardInitial() when initial != null:
return initial(_that);case LandlordDashboardLoading() when loading != null:
return loading(_that);case LandlordDashboardLoaded() when loaded != null:
return loaded(_that);case LandlordDashboardError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( LandlordDashboardData data)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LandlordDashboardInitial() when initial != null:
return initial();case LandlordDashboardLoading() when loading != null:
return loading();case LandlordDashboardLoaded() when loaded != null:
return loaded(_that.data);case LandlordDashboardError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( LandlordDashboardData data)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case LandlordDashboardInitial():
return initial();case LandlordDashboardLoading():
return loading();case LandlordDashboardLoaded():
return loaded(_that.data);case LandlordDashboardError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( LandlordDashboardData data)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case LandlordDashboardInitial() when initial != null:
return initial();case LandlordDashboardLoading() when loading != null:
return loading();case LandlordDashboardLoaded() when loaded != null:
return loaded(_that.data);case LandlordDashboardError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class LandlordDashboardInitial implements LandlordDashboardState {
  const LandlordDashboardInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LandlordDashboardInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LandlordDashboardState.initial()';
}


}




/// @nodoc


class LandlordDashboardLoading implements LandlordDashboardState {
  const LandlordDashboardLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LandlordDashboardLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'LandlordDashboardState.loading()';
}


}




/// @nodoc


class LandlordDashboardLoaded implements LandlordDashboardState {
  const LandlordDashboardLoaded(this.data);
  

 final  LandlordDashboardData data;

/// Create a copy of LandlordDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LandlordDashboardLoadedCopyWith<LandlordDashboardLoaded> get copyWith => _$LandlordDashboardLoadedCopyWithImpl<LandlordDashboardLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LandlordDashboardLoaded&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,data);
}

@override
String toString() {
    return 'LandlordDashboardState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class $LandlordDashboardLoadedCopyWith<$Res> implements $LandlordDashboardStateCopyWith<$Res> {
  factory $LandlordDashboardLoadedCopyWith(LandlordDashboardLoaded value, $Res Function(LandlordDashboardLoaded) _then) = _$LandlordDashboardLoadedCopyWithImpl;
@useResult
$Res call({
 LandlordDashboardData data
});




}
/// @nodoc
class _$LandlordDashboardLoadedCopyWithImpl<$Res>
    implements $LandlordDashboardLoadedCopyWith<$Res> {
  _$LandlordDashboardLoadedCopyWithImpl(this._self, this._then);

  final LandlordDashboardLoaded _self;
  final $Res Function(LandlordDashboardLoaded) _then;

/// Create a copy of LandlordDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(LandlordDashboardLoaded(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as LandlordDashboardData,
  ));
}


}

/// @nodoc


class LandlordDashboardError implements LandlordDashboardState {
  const LandlordDashboardError(this.message);
  

 final  String message;

/// Create a copy of LandlordDashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LandlordDashboardErrorCopyWith<LandlordDashboardError> get copyWith => _$LandlordDashboardErrorCopyWithImpl<LandlordDashboardError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is LandlordDashboardError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'LandlordDashboardState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $LandlordDashboardErrorCopyWith<$Res> implements $LandlordDashboardStateCopyWith<$Res> {
  factory $LandlordDashboardErrorCopyWith(LandlordDashboardError value, $Res Function(LandlordDashboardError) _then) = _$LandlordDashboardErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LandlordDashboardErrorCopyWithImpl<$Res>
    implements $LandlordDashboardErrorCopyWith<$Res> {
  _$LandlordDashboardErrorCopyWithImpl(this._self, this._then);

  final LandlordDashboardError _self;
  final $Res Function(LandlordDashboardError) _then;

/// Create a copy of LandlordDashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LandlordDashboardError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
