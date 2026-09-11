// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatState()';
}


}

/// @nodoc
class $ChatStateCopyWith<$Res>  {
$ChatStateCopyWith(ChatState _, $Res Function(ChatState) __);
}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ChatInitial value)?  initial,TResult Function( ChatLoading value)?  loading,TResult Function( ConnectionsLoaded value)?  connectionsLoaded,TResult Function( MessagesLoaded value)?  messagesLoaded,TResult Function( ChatError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial(_that);case ChatLoading() when loading != null:
return loading(_that);case ConnectionsLoaded() when connectionsLoaded != null:
return connectionsLoaded(_that);case MessagesLoaded() when messagesLoaded != null:
return messagesLoaded(_that);case ChatError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ChatInitial value)  initial,required TResult Function( ChatLoading value)  loading,required TResult Function( ConnectionsLoaded value)  connectionsLoaded,required TResult Function( MessagesLoaded value)  messagesLoaded,required TResult Function( ChatError value)  error,}){
final _that = this;
switch (_that) {
case ChatInitial():
return initial(_that);case ChatLoading():
return loading(_that);case ConnectionsLoaded():
return connectionsLoaded(_that);case MessagesLoaded():
return messagesLoaded(_that);case ChatError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ChatInitial value)?  initial,TResult? Function( ChatLoading value)?  loading,TResult? Function( ConnectionsLoaded value)?  connectionsLoaded,TResult? Function( MessagesLoaded value)?  messagesLoaded,TResult? Function( ChatError value)?  error,}){
final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial(_that);case ChatLoading() when loading != null:
return loading(_that);case ConnectionsLoaded() when connectionsLoaded != null:
return connectionsLoaded(_that);case MessagesLoaded() when messagesLoaded != null:
return messagesLoaded(_that);case ChatError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<MatchConnectionEntity> connections)?  connectionsLoaded,TResult Function( String connectionId,  List<MessageEntity> messages)?  messagesLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial();case ChatLoading() when loading != null:
return loading();case ConnectionsLoaded() when connectionsLoaded != null:
return connectionsLoaded(_that.connections);case MessagesLoaded() when messagesLoaded != null:
return messagesLoaded(_that.connectionId,_that.messages);case ChatError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<MatchConnectionEntity> connections)  connectionsLoaded,required TResult Function( String connectionId,  List<MessageEntity> messages)  messagesLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ChatInitial():
return initial();case ChatLoading():
return loading();case ConnectionsLoaded():
return connectionsLoaded(_that.connections);case MessagesLoaded():
return messagesLoaded(_that.connectionId,_that.messages);case ChatError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<MatchConnectionEntity> connections)?  connectionsLoaded,TResult? Function( String connectionId,  List<MessageEntity> messages)?  messagesLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ChatInitial() when initial != null:
return initial();case ChatLoading() when loading != null:
return loading();case ConnectionsLoaded() when connectionsLoaded != null:
return connectionsLoaded(_that.connections);case MessagesLoaded() when messagesLoaded != null:
return messagesLoaded(_that.connectionId,_that.messages);case ChatError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ChatInitial implements ChatState {
  const ChatInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatState.initial()';
}


}




/// @nodoc


class ChatLoading implements ChatState {
  const ChatLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ChatState.loading()';
}


}




/// @nodoc


class ConnectionsLoaded implements ChatState {
  const ConnectionsLoaded( List<MatchConnectionEntity> connections): _connections = connections;
  

 final  List<MatchConnectionEntity> _connections;
 List<MatchConnectionEntity> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}


/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionsLoadedCopyWith<ConnectionsLoaded> get copyWith => _$ConnectionsLoadedCopyWithImpl<ConnectionsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionsLoaded&&const DeepCollectionEquality().equals(other.connections, _connections));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_connections));
}

@override
String toString() {
    return 'ChatState.connectionsLoaded(connections: $connections)';
}


}

/// @nodoc
abstract mixin class $ConnectionsLoadedCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $ConnectionsLoadedCopyWith(ConnectionsLoaded value, $Res Function(ConnectionsLoaded) _then) = _$ConnectionsLoadedCopyWithImpl;
@useResult
$Res call({
 List<MatchConnectionEntity> connections
});




}
/// @nodoc
class _$ConnectionsLoadedCopyWithImpl<$Res>
    implements $ConnectionsLoadedCopyWith<$Res> {
  _$ConnectionsLoadedCopyWithImpl(this._self, this._then);

  final ConnectionsLoaded _self;
  final $Res Function(ConnectionsLoaded) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connections = null,}) {
  return _then(ConnectionsLoaded(
null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<MatchConnectionEntity>,
  ));
}


}

/// @nodoc


class MessagesLoaded implements ChatState {
  const MessagesLoaded({required this.connectionId, required  List<MessageEntity> messages}): _messages = messages;
  

 final  String connectionId;
 final  List<MessageEntity> _messages;
 List<MessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessagesLoadedCopyWith<MessagesLoaded> get copyWith => _$MessagesLoadedCopyWithImpl<MessagesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MessagesLoaded&&(identical(other.connectionId, connectionId) || other.connectionId == connectionId)&&const DeepCollectionEquality().equals(other.messages, _messages));
}


@override
int get hashCode {
    return Object.hash(runtimeType,connectionId,const DeepCollectionEquality().hash(_messages));
}

@override
String toString() {
    return 'ChatState.messagesLoaded(connectionId: $connectionId, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $MessagesLoadedCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $MessagesLoadedCopyWith(MessagesLoaded value, $Res Function(MessagesLoaded) _then) = _$MessagesLoadedCopyWithImpl;
@useResult
$Res call({
 String connectionId, List<MessageEntity> messages
});




}
/// @nodoc
class _$MessagesLoadedCopyWithImpl<$Res>
    implements $MessagesLoadedCopyWith<$Res> {
  _$MessagesLoadedCopyWithImpl(this._self, this._then);

  final MessagesLoaded _self;
  final $Res Function(MessagesLoaded) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? connectionId = null,Object? messages = null,}) {
  return _then(MessagesLoaded(
connectionId: null == connectionId ? _self.connectionId : connectionId // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageEntity>,
  ));
}


}

/// @nodoc


class ChatError implements ChatState {
  const ChatError(this.message);
  

 final  String message;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatErrorCopyWith<ChatError> get copyWith => _$ChatErrorCopyWithImpl<ChatError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ChatState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ChatErrorCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory $ChatErrorCopyWith(ChatError value, $Res Function(ChatError) _then) = _$ChatErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ChatErrorCopyWithImpl<$Res>
    implements $ChatErrorCopyWith<$Res> {
  _$ChatErrorCopyWithImpl(this._self, this._then);

  final ChatError _self;
  final $Res Function(ChatError) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ChatError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
