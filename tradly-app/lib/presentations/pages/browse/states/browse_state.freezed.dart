// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browse_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BrowseStatus {
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
    required TResult Function(BrowseStatusInitial value) initial,
    required TResult Function(BrowseStatusLoading value) loading,
    required TResult Function(BrowseStatusSuccess value) success,
    required TResult Function(BrowseStatusFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BrowseStatusInitial value)? initial,
    TResult? Function(BrowseStatusLoading value)? loading,
    TResult? Function(BrowseStatusSuccess value)? success,
    TResult? Function(BrowseStatusFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BrowseStatusInitial value)? initial,
    TResult Function(BrowseStatusLoading value)? loading,
    TResult Function(BrowseStatusSuccess value)? success,
    TResult Function(BrowseStatusFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrowseStatusCopyWith<$Res> {
  factory $BrowseStatusCopyWith(
          BrowseStatus value, $Res Function(BrowseStatus) then) =
      _$BrowseStatusCopyWithImpl<$Res, BrowseStatus>;
}

/// @nodoc
class _$BrowseStatusCopyWithImpl<$Res, $Val extends BrowseStatus>
    implements $BrowseStatusCopyWith<$Res> {
  _$BrowseStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrowseStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BrowseStatusInitialImplCopyWith<$Res> {
  factory _$$BrowseStatusInitialImplCopyWith(_$BrowseStatusInitialImpl value,
          $Res Function(_$BrowseStatusInitialImpl) then) =
      __$$BrowseStatusInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BrowseStatusInitialImplCopyWithImpl<$Res>
    extends _$BrowseStatusCopyWithImpl<$Res, _$BrowseStatusInitialImpl>
    implements _$$BrowseStatusInitialImplCopyWith<$Res> {
  __$$BrowseStatusInitialImplCopyWithImpl(_$BrowseStatusInitialImpl _value,
      $Res Function(_$BrowseStatusInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowseStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BrowseStatusInitialImpl implements BrowseStatusInitial {
  const _$BrowseStatusInitialImpl();

  @override
  String toString() {
    return 'BrowseStatus.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowseStatusInitialImpl);
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
    required TResult Function(BrowseStatusInitial value) initial,
    required TResult Function(BrowseStatusLoading value) loading,
    required TResult Function(BrowseStatusSuccess value) success,
    required TResult Function(BrowseStatusFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BrowseStatusInitial value)? initial,
    TResult? Function(BrowseStatusLoading value)? loading,
    TResult? Function(BrowseStatusSuccess value)? success,
    TResult? Function(BrowseStatusFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BrowseStatusInitial value)? initial,
    TResult Function(BrowseStatusLoading value)? loading,
    TResult Function(BrowseStatusSuccess value)? success,
    TResult Function(BrowseStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class BrowseStatusInitial implements BrowseStatus {
  const factory BrowseStatusInitial() = _$BrowseStatusInitialImpl;
}

/// @nodoc
abstract class _$$BrowseStatusLoadingImplCopyWith<$Res> {
  factory _$$BrowseStatusLoadingImplCopyWith(_$BrowseStatusLoadingImpl value,
          $Res Function(_$BrowseStatusLoadingImpl) then) =
      __$$BrowseStatusLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BrowseStatusLoadingImplCopyWithImpl<$Res>
    extends _$BrowseStatusCopyWithImpl<$Res, _$BrowseStatusLoadingImpl>
    implements _$$BrowseStatusLoadingImplCopyWith<$Res> {
  __$$BrowseStatusLoadingImplCopyWithImpl(_$BrowseStatusLoadingImpl _value,
      $Res Function(_$BrowseStatusLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowseStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BrowseStatusLoadingImpl implements BrowseStatusLoading {
  const _$BrowseStatusLoadingImpl();

  @override
  String toString() {
    return 'BrowseStatus.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowseStatusLoadingImpl);
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
    required TResult Function(BrowseStatusInitial value) initial,
    required TResult Function(BrowseStatusLoading value) loading,
    required TResult Function(BrowseStatusSuccess value) success,
    required TResult Function(BrowseStatusFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BrowseStatusInitial value)? initial,
    TResult? Function(BrowseStatusLoading value)? loading,
    TResult? Function(BrowseStatusSuccess value)? success,
    TResult? Function(BrowseStatusFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BrowseStatusInitial value)? initial,
    TResult Function(BrowseStatusLoading value)? loading,
    TResult Function(BrowseStatusSuccess value)? success,
    TResult Function(BrowseStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BrowseStatusLoading implements BrowseStatus {
  const factory BrowseStatusLoading() = _$BrowseStatusLoadingImpl;
}

/// @nodoc
abstract class _$$BrowseStatusSuccessImplCopyWith<$Res> {
  factory _$$BrowseStatusSuccessImplCopyWith(_$BrowseStatusSuccessImpl value,
          $Res Function(_$BrowseStatusSuccessImpl) then) =
      __$$BrowseStatusSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BrowseStatusSuccessImplCopyWithImpl<$Res>
    extends _$BrowseStatusCopyWithImpl<$Res, _$BrowseStatusSuccessImpl>
    implements _$$BrowseStatusSuccessImplCopyWith<$Res> {
  __$$BrowseStatusSuccessImplCopyWithImpl(_$BrowseStatusSuccessImpl _value,
      $Res Function(_$BrowseStatusSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowseStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BrowseStatusSuccessImpl implements BrowseStatusSuccess {
  const _$BrowseStatusSuccessImpl();

  @override
  String toString() {
    return 'BrowseStatus.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowseStatusSuccessImpl);
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
    required TResult Function(BrowseStatusInitial value) initial,
    required TResult Function(BrowseStatusLoading value) loading,
    required TResult Function(BrowseStatusSuccess value) success,
    required TResult Function(BrowseStatusFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BrowseStatusInitial value)? initial,
    TResult? Function(BrowseStatusLoading value)? loading,
    TResult? Function(BrowseStatusSuccess value)? success,
    TResult? Function(BrowseStatusFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BrowseStatusInitial value)? initial,
    TResult Function(BrowseStatusLoading value)? loading,
    TResult Function(BrowseStatusSuccess value)? success,
    TResult Function(BrowseStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class BrowseStatusSuccess implements BrowseStatus {
  const factory BrowseStatusSuccess() = _$BrowseStatusSuccessImpl;
}

/// @nodoc
abstract class _$$BrowseStatusFailureImplCopyWith<$Res> {
  factory _$$BrowseStatusFailureImplCopyWith(_$BrowseStatusFailureImpl value,
          $Res Function(_$BrowseStatusFailureImpl) then) =
      __$$BrowseStatusFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BrowseStatusFailureImplCopyWithImpl<$Res>
    extends _$BrowseStatusCopyWithImpl<$Res, _$BrowseStatusFailureImpl>
    implements _$$BrowseStatusFailureImplCopyWith<$Res> {
  __$$BrowseStatusFailureImplCopyWithImpl(_$BrowseStatusFailureImpl _value,
      $Res Function(_$BrowseStatusFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowseStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BrowseStatusFailureImpl implements BrowseStatusFailure {
  const _$BrowseStatusFailureImpl();

  @override
  String toString() {
    return 'BrowseStatus.failure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowseStatusFailureImpl);
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
    required TResult Function(BrowseStatusInitial value) initial,
    required TResult Function(BrowseStatusLoading value) loading,
    required TResult Function(BrowseStatusSuccess value) success,
    required TResult Function(BrowseStatusFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BrowseStatusInitial value)? initial,
    TResult? Function(BrowseStatusLoading value)? loading,
    TResult? Function(BrowseStatusSuccess value)? success,
    TResult? Function(BrowseStatusFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BrowseStatusInitial value)? initial,
    TResult Function(BrowseStatusLoading value)? loading,
    TResult Function(BrowseStatusSuccess value)? success,
    TResult Function(BrowseStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class BrowseStatusFailure implements BrowseStatus {
  const factory BrowseStatusFailure() = _$BrowseStatusFailureImpl;
}
