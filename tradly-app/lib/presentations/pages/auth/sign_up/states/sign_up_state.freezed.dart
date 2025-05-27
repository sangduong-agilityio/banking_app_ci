// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignUpStatus {
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
    required TResult Function(SignUpStatusInitial value) initial,
    required TResult Function(SignUpStatusLoading value) loading,
    required TResult Function(SignUpStatusSuccess value) success,
    required TResult Function(SignUpStatusFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStatusInitial value)? initial,
    TResult? Function(SignUpStatusLoading value)? loading,
    TResult? Function(SignUpStatusSuccess value)? success,
    TResult? Function(SignUpStatusFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStatusInitial value)? initial,
    TResult Function(SignUpStatusLoading value)? loading,
    TResult Function(SignUpStatusSuccess value)? success,
    TResult Function(SignUpStatusFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpStatusCopyWith<$Res> {
  factory $SignUpStatusCopyWith(
          SignUpStatus value, $Res Function(SignUpStatus) then) =
      _$SignUpStatusCopyWithImpl<$Res, SignUpStatus>;
}

/// @nodoc
class _$SignUpStatusCopyWithImpl<$Res, $Val extends SignUpStatus>
    implements $SignUpStatusCopyWith<$Res> {
  _$SignUpStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignUpStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SignUpStatusInitialImplCopyWith<$Res> {
  factory _$$SignUpStatusInitialImplCopyWith(_$SignUpStatusInitialImpl value,
          $Res Function(_$SignUpStatusInitialImpl) then) =
      __$$SignUpStatusInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStatusInitialImplCopyWithImpl<$Res>
    extends _$SignUpStatusCopyWithImpl<$Res, _$SignUpStatusInitialImpl>
    implements _$$SignUpStatusInitialImplCopyWith<$Res> {
  __$$SignUpStatusInitialImplCopyWithImpl(_$SignUpStatusInitialImpl _value,
      $Res Function(_$SignUpStatusInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignUpStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignUpStatusInitialImpl implements SignUpStatusInitial {
  const _$SignUpStatusInitialImpl();

  @override
  String toString() {
    return 'SignUpStatus.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStatusInitialImpl);
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
    required TResult Function(SignUpStatusInitial value) initial,
    required TResult Function(SignUpStatusLoading value) loading,
    required TResult Function(SignUpStatusSuccess value) success,
    required TResult Function(SignUpStatusFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStatusInitial value)? initial,
    TResult? Function(SignUpStatusLoading value)? loading,
    TResult? Function(SignUpStatusSuccess value)? success,
    TResult? Function(SignUpStatusFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStatusInitial value)? initial,
    TResult Function(SignUpStatusLoading value)? loading,
    TResult Function(SignUpStatusSuccess value)? success,
    TResult Function(SignUpStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SignUpStatusInitial implements SignUpStatus {
  const factory SignUpStatusInitial() = _$SignUpStatusInitialImpl;
}

/// @nodoc
abstract class _$$SignUpStatusLoadingImplCopyWith<$Res> {
  factory _$$SignUpStatusLoadingImplCopyWith(_$SignUpStatusLoadingImpl value,
          $Res Function(_$SignUpStatusLoadingImpl) then) =
      __$$SignUpStatusLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStatusLoadingImplCopyWithImpl<$Res>
    extends _$SignUpStatusCopyWithImpl<$Res, _$SignUpStatusLoadingImpl>
    implements _$$SignUpStatusLoadingImplCopyWith<$Res> {
  __$$SignUpStatusLoadingImplCopyWithImpl(_$SignUpStatusLoadingImpl _value,
      $Res Function(_$SignUpStatusLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignUpStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignUpStatusLoadingImpl implements SignUpStatusLoading {
  const _$SignUpStatusLoadingImpl();

  @override
  String toString() {
    return 'SignUpStatus.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStatusLoadingImpl);
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
    required TResult Function(SignUpStatusInitial value) initial,
    required TResult Function(SignUpStatusLoading value) loading,
    required TResult Function(SignUpStatusSuccess value) success,
    required TResult Function(SignUpStatusFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStatusInitial value)? initial,
    TResult? Function(SignUpStatusLoading value)? loading,
    TResult? Function(SignUpStatusSuccess value)? success,
    TResult? Function(SignUpStatusFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStatusInitial value)? initial,
    TResult Function(SignUpStatusLoading value)? loading,
    TResult Function(SignUpStatusSuccess value)? success,
    TResult Function(SignUpStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SignUpStatusLoading implements SignUpStatus {
  const factory SignUpStatusLoading() = _$SignUpStatusLoadingImpl;
}

/// @nodoc
abstract class _$$SignUpStatusSuccessImplCopyWith<$Res> {
  factory _$$SignUpStatusSuccessImplCopyWith(_$SignUpStatusSuccessImpl value,
          $Res Function(_$SignUpStatusSuccessImpl) then) =
      __$$SignUpStatusSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStatusSuccessImplCopyWithImpl<$Res>
    extends _$SignUpStatusCopyWithImpl<$Res, _$SignUpStatusSuccessImpl>
    implements _$$SignUpStatusSuccessImplCopyWith<$Res> {
  __$$SignUpStatusSuccessImplCopyWithImpl(_$SignUpStatusSuccessImpl _value,
      $Res Function(_$SignUpStatusSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignUpStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignUpStatusSuccessImpl implements SignUpStatusSuccess {
  const _$SignUpStatusSuccessImpl();

  @override
  String toString() {
    return 'SignUpStatus.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStatusSuccessImpl);
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
    required TResult Function(SignUpStatusInitial value) initial,
    required TResult Function(SignUpStatusLoading value) loading,
    required TResult Function(SignUpStatusSuccess value) success,
    required TResult Function(SignUpStatusFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStatusInitial value)? initial,
    TResult? Function(SignUpStatusLoading value)? loading,
    TResult? Function(SignUpStatusSuccess value)? success,
    TResult? Function(SignUpStatusFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStatusInitial value)? initial,
    TResult Function(SignUpStatusLoading value)? loading,
    TResult Function(SignUpStatusSuccess value)? success,
    TResult Function(SignUpStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SignUpStatusSuccess implements SignUpStatus {
  const factory SignUpStatusSuccess() = _$SignUpStatusSuccessImpl;
}

/// @nodoc
abstract class _$$SignUpStatusFailureImplCopyWith<$Res> {
  factory _$$SignUpStatusFailureImplCopyWith(_$SignUpStatusFailureImpl value,
          $Res Function(_$SignUpStatusFailureImpl) then) =
      __$$SignUpStatusFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignUpStatusFailureImplCopyWithImpl<$Res>
    extends _$SignUpStatusCopyWithImpl<$Res, _$SignUpStatusFailureImpl>
    implements _$$SignUpStatusFailureImplCopyWith<$Res> {
  __$$SignUpStatusFailureImplCopyWithImpl(_$SignUpStatusFailureImpl _value,
      $Res Function(_$SignUpStatusFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignUpStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignUpStatusFailureImpl implements SignUpStatusFailure {
  const _$SignUpStatusFailureImpl();

  @override
  String toString() {
    return 'SignUpStatus.failure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpStatusFailureImpl);
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
    required TResult Function(SignUpStatusInitial value) initial,
    required TResult Function(SignUpStatusLoading value) loading,
    required TResult Function(SignUpStatusSuccess value) success,
    required TResult Function(SignUpStatusFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignUpStatusInitial value)? initial,
    TResult? Function(SignUpStatusLoading value)? loading,
    TResult? Function(SignUpStatusSuccess value)? success,
    TResult? Function(SignUpStatusFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignUpStatusInitial value)? initial,
    TResult Function(SignUpStatusLoading value)? loading,
    TResult Function(SignUpStatusSuccess value)? success,
    TResult Function(SignUpStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SignUpStatusFailure implements SignUpStatus {
  const factory SignUpStatusFailure() = _$SignUpStatusFailureImpl;
}
