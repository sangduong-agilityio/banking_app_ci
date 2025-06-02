// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignInStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function()? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInStatusInitial value) initial,
    required TResult Function(SignInStatusLoading value) loading,
    required TResult Function(SignInStatusSuccess value) success,
    required TResult Function(SignInStatusFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInStatusInitial value)? initial,
    TResult? Function(SignInStatusLoading value)? loading,
    TResult? Function(SignInStatusSuccess value)? success,
    TResult? Function(SignInStatusFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInStatusInitial value)? initial,
    TResult Function(SignInStatusLoading value)? loading,
    TResult Function(SignInStatusSuccess value)? success,
    TResult Function(SignInStatusFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInStatusCopyWith<$Res> {
  factory $SignInStatusCopyWith(
          SignInStatus value, $Res Function(SignInStatus) then) =
      _$SignInStatusCopyWithImpl<$Res, SignInStatus>;
}

/// @nodoc
class _$SignInStatusCopyWithImpl<$Res, $Val extends SignInStatus>
    implements $SignInStatusCopyWith<$Res> {
  _$SignInStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignInStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SignInStatusInitialImplCopyWith<$Res> {
  factory _$$SignInStatusInitialImplCopyWith(_$SignInStatusInitialImpl value,
          $Res Function(_$SignInStatusInitialImpl) then) =
      __$$SignInStatusInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignInStatusInitialImplCopyWithImpl<$Res>
    extends _$SignInStatusCopyWithImpl<$Res, _$SignInStatusInitialImpl>
    implements _$$SignInStatusInitialImplCopyWith<$Res> {
  __$$SignInStatusInitialImplCopyWithImpl(_$SignInStatusInitialImpl _value,
      $Res Function(_$SignInStatusInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignInStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignInStatusInitialImpl implements SignInStatusInitial {
  const _$SignInStatusInitialImpl();

  @override
  String toString() {
    return 'SignInStatus.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInStatusInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function()? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInStatusInitial value) initial,
    required TResult Function(SignInStatusLoading value) loading,
    required TResult Function(SignInStatusSuccess value) success,
    required TResult Function(SignInStatusFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInStatusInitial value)? initial,
    TResult? Function(SignInStatusLoading value)? loading,
    TResult? Function(SignInStatusSuccess value)? success,
    TResult? Function(SignInStatusFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInStatusInitial value)? initial,
    TResult Function(SignInStatusLoading value)? loading,
    TResult Function(SignInStatusSuccess value)? success,
    TResult Function(SignInStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SignInStatusInitial implements SignInStatus {
  const factory SignInStatusInitial() = _$SignInStatusInitialImpl;
}

/// @nodoc
abstract class _$$SignInStatusLoadingImplCopyWith<$Res> {
  factory _$$SignInStatusLoadingImplCopyWith(_$SignInStatusLoadingImpl value,
          $Res Function(_$SignInStatusLoadingImpl) then) =
      __$$SignInStatusLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignInStatusLoadingImplCopyWithImpl<$Res>
    extends _$SignInStatusCopyWithImpl<$Res, _$SignInStatusLoadingImpl>
    implements _$$SignInStatusLoadingImplCopyWith<$Res> {
  __$$SignInStatusLoadingImplCopyWithImpl(_$SignInStatusLoadingImpl _value,
      $Res Function(_$SignInStatusLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignInStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignInStatusLoadingImpl implements SignInStatusLoading {
  const _$SignInStatusLoadingImpl();

  @override
  String toString() {
    return 'SignInStatus.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInStatusLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function()? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInStatusInitial value) initial,
    required TResult Function(SignInStatusLoading value) loading,
    required TResult Function(SignInStatusSuccess value) success,
    required TResult Function(SignInStatusFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInStatusInitial value)? initial,
    TResult? Function(SignInStatusLoading value)? loading,
    TResult? Function(SignInStatusSuccess value)? success,
    TResult? Function(SignInStatusFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInStatusInitial value)? initial,
    TResult Function(SignInStatusLoading value)? loading,
    TResult Function(SignInStatusSuccess value)? success,
    TResult Function(SignInStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SignInStatusLoading implements SignInStatus {
  const factory SignInStatusLoading() = _$SignInStatusLoadingImpl;
}

/// @nodoc
abstract class _$$SignInStatusSuccessImplCopyWith<$Res> {
  factory _$$SignInStatusSuccessImplCopyWith(_$SignInStatusSuccessImpl value,
          $Res Function(_$SignInStatusSuccessImpl) then) =
      __$$SignInStatusSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignInStatusSuccessImplCopyWithImpl<$Res>
    extends _$SignInStatusCopyWithImpl<$Res, _$SignInStatusSuccessImpl>
    implements _$$SignInStatusSuccessImplCopyWith<$Res> {
  __$$SignInStatusSuccessImplCopyWithImpl(_$SignInStatusSuccessImpl _value,
      $Res Function(_$SignInStatusSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignInStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignInStatusSuccessImpl implements SignInStatusSuccess {
  const _$SignInStatusSuccessImpl();

  @override
  String toString() {
    return 'SignInStatus.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInStatusSuccessImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() failure,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function()? failure,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInStatusInitial value) initial,
    required TResult Function(SignInStatusLoading value) loading,
    required TResult Function(SignInStatusSuccess value) success,
    required TResult Function(SignInStatusFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInStatusInitial value)? initial,
    TResult? Function(SignInStatusLoading value)? loading,
    TResult? Function(SignInStatusSuccess value)? success,
    TResult? Function(SignInStatusFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInStatusInitial value)? initial,
    TResult Function(SignInStatusLoading value)? loading,
    TResult Function(SignInStatusSuccess value)? success,
    TResult Function(SignInStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SignInStatusSuccess implements SignInStatus {
  const factory SignInStatusSuccess() = _$SignInStatusSuccessImpl;
}

/// @nodoc
abstract class _$$SignInStatusFailureImplCopyWith<$Res> {
  factory _$$SignInStatusFailureImplCopyWith(_$SignInStatusFailureImpl value,
          $Res Function(_$SignInStatusFailureImpl) then) =
      __$$SignInStatusFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignInStatusFailureImplCopyWithImpl<$Res>
    extends _$SignInStatusCopyWithImpl<$Res, _$SignInStatusFailureImpl>
    implements _$$SignInStatusFailureImplCopyWith<$Res> {
  __$$SignInStatusFailureImplCopyWithImpl(_$SignInStatusFailureImpl _value,
      $Res Function(_$SignInStatusFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignInStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignInStatusFailureImpl implements SignInStatusFailure {
  const _$SignInStatusFailureImpl();

  @override
  String toString() {
    return 'SignInStatus.failure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInStatusFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function() failure,
  }) {
    return failure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function()? failure,
  }) {
    return failure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function()? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInStatusInitial value) initial,
    required TResult Function(SignInStatusLoading value) loading,
    required TResult Function(SignInStatusSuccess value) success,
    required TResult Function(SignInStatusFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInStatusInitial value)? initial,
    TResult? Function(SignInStatusLoading value)? loading,
    TResult? Function(SignInStatusSuccess value)? success,
    TResult? Function(SignInStatusFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInStatusInitial value)? initial,
    TResult Function(SignInStatusLoading value)? loading,
    TResult Function(SignInStatusSuccess value)? success,
    TResult Function(SignInStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SignInStatusFailure implements SignInStatus {
  const factory SignInStatusFailure() = _$SignInStatusFailureImpl;
}
