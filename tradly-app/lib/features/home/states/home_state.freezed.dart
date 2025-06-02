// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeStatus {
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
    required TResult Function(HomeStatusInitial value) initial,
    required TResult Function(HomeStatusLoading value) loading,
    required TResult Function(HomeStatusSuccess value) success,
    required TResult Function(HomeStatusFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStatusInitial value)? initial,
    TResult? Function(HomeStatusLoading value)? loading,
    TResult? Function(HomeStatusSuccess value)? success,
    TResult? Function(HomeStatusFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStatusInitial value)? initial,
    TResult Function(HomeStatusLoading value)? loading,
    TResult Function(HomeStatusSuccess value)? success,
    TResult Function(HomeStatusFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStatusCopyWith<$Res> {
  factory $HomeStatusCopyWith(
          HomeStatus value, $Res Function(HomeStatus) then) =
      _$HomeStatusCopyWithImpl<$Res, HomeStatus>;
}

/// @nodoc
class _$HomeStatusCopyWithImpl<$Res, $Val extends HomeStatus>
    implements $HomeStatusCopyWith<$Res> {
  _$HomeStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HomeStatusInitialImplCopyWith<$Res> {
  factory _$$HomeStatusInitialImplCopyWith(_$HomeStatusInitialImpl value,
          $Res Function(_$HomeStatusInitialImpl) then) =
      __$$HomeStatusInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeStatusInitialImplCopyWithImpl<$Res>
    extends _$HomeStatusCopyWithImpl<$Res, _$HomeStatusInitialImpl>
    implements _$$HomeStatusInitialImplCopyWith<$Res> {
  __$$HomeStatusInitialImplCopyWithImpl(_$HomeStatusInitialImpl _value,
      $Res Function(_$HomeStatusInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HomeStatusInitialImpl implements HomeStatusInitial {
  const _$HomeStatusInitialImpl();

  @override
  String toString() {
    return 'HomeStatus.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeStatusInitialImpl);
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
    required TResult Function(HomeStatusInitial value) initial,
    required TResult Function(HomeStatusLoading value) loading,
    required TResult Function(HomeStatusSuccess value) success,
    required TResult Function(HomeStatusFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStatusInitial value)? initial,
    TResult? Function(HomeStatusLoading value)? loading,
    TResult? Function(HomeStatusSuccess value)? success,
    TResult? Function(HomeStatusFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStatusInitial value)? initial,
    TResult Function(HomeStatusLoading value)? loading,
    TResult Function(HomeStatusSuccess value)? success,
    TResult Function(HomeStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class HomeStatusInitial implements HomeStatus {
  const factory HomeStatusInitial() = _$HomeStatusInitialImpl;
}

/// @nodoc
abstract class _$$HomeStatusLoadingImplCopyWith<$Res> {
  factory _$$HomeStatusLoadingImplCopyWith(_$HomeStatusLoadingImpl value,
          $Res Function(_$HomeStatusLoadingImpl) then) =
      __$$HomeStatusLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeStatusLoadingImplCopyWithImpl<$Res>
    extends _$HomeStatusCopyWithImpl<$Res, _$HomeStatusLoadingImpl>
    implements _$$HomeStatusLoadingImplCopyWith<$Res> {
  __$$HomeStatusLoadingImplCopyWithImpl(_$HomeStatusLoadingImpl _value,
      $Res Function(_$HomeStatusLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HomeStatusLoadingImpl implements HomeStatusLoading {
  const _$HomeStatusLoadingImpl();

  @override
  String toString() {
    return 'HomeStatus.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeStatusLoadingImpl);
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
    required TResult Function(HomeStatusInitial value) initial,
    required TResult Function(HomeStatusLoading value) loading,
    required TResult Function(HomeStatusSuccess value) success,
    required TResult Function(HomeStatusFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStatusInitial value)? initial,
    TResult? Function(HomeStatusLoading value)? loading,
    TResult? Function(HomeStatusSuccess value)? success,
    TResult? Function(HomeStatusFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStatusInitial value)? initial,
    TResult Function(HomeStatusLoading value)? loading,
    TResult Function(HomeStatusSuccess value)? success,
    TResult Function(HomeStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HomeStatusLoading implements HomeStatus {
  const factory HomeStatusLoading() = _$HomeStatusLoadingImpl;
}

/// @nodoc
abstract class _$$HomeStatusSuccessImplCopyWith<$Res> {
  factory _$$HomeStatusSuccessImplCopyWith(_$HomeStatusSuccessImpl value,
          $Res Function(_$HomeStatusSuccessImpl) then) =
      __$$HomeStatusSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeStatusSuccessImplCopyWithImpl<$Res>
    extends _$HomeStatusCopyWithImpl<$Res, _$HomeStatusSuccessImpl>
    implements _$$HomeStatusSuccessImplCopyWith<$Res> {
  __$$HomeStatusSuccessImplCopyWithImpl(_$HomeStatusSuccessImpl _value,
      $Res Function(_$HomeStatusSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HomeStatusSuccessImpl implements HomeStatusSuccess {
  const _$HomeStatusSuccessImpl();

  @override
  String toString() {
    return 'HomeStatus.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeStatusSuccessImpl);
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
    required TResult Function(HomeStatusInitial value) initial,
    required TResult Function(HomeStatusLoading value) loading,
    required TResult Function(HomeStatusSuccess value) success,
    required TResult Function(HomeStatusFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStatusInitial value)? initial,
    TResult? Function(HomeStatusLoading value)? loading,
    TResult? Function(HomeStatusSuccess value)? success,
    TResult? Function(HomeStatusFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStatusInitial value)? initial,
    TResult Function(HomeStatusLoading value)? loading,
    TResult Function(HomeStatusSuccess value)? success,
    TResult Function(HomeStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class HomeStatusSuccess implements HomeStatus {
  const factory HomeStatusSuccess() = _$HomeStatusSuccessImpl;
}

/// @nodoc
abstract class _$$HomeStatusFailureImplCopyWith<$Res> {
  factory _$$HomeStatusFailureImplCopyWith(_$HomeStatusFailureImpl value,
          $Res Function(_$HomeStatusFailureImpl) then) =
      __$$HomeStatusFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeStatusFailureImplCopyWithImpl<$Res>
    extends _$HomeStatusCopyWithImpl<$Res, _$HomeStatusFailureImpl>
    implements _$$HomeStatusFailureImplCopyWith<$Res> {
  __$$HomeStatusFailureImplCopyWithImpl(_$HomeStatusFailureImpl _value,
      $Res Function(_$HomeStatusFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HomeStatusFailureImpl implements HomeStatusFailure {
  const _$HomeStatusFailureImpl();

  @override
  String toString() {
    return 'HomeStatus.failure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeStatusFailureImpl);
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
    required TResult Function(HomeStatusInitial value) initial,
    required TResult Function(HomeStatusLoading value) loading,
    required TResult Function(HomeStatusSuccess value) success,
    required TResult Function(HomeStatusFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeStatusInitial value)? initial,
    TResult? Function(HomeStatusLoading value)? loading,
    TResult? Function(HomeStatusSuccess value)? success,
    TResult? Function(HomeStatusFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeStatusInitial value)? initial,
    TResult Function(HomeStatusLoading value)? loading,
    TResult Function(HomeStatusSuccess value)? success,
    TResult Function(HomeStatusFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class HomeStatusFailure implements HomeStatus {
  const factory HomeStatusFailure() = _$HomeStatusFailureImpl;
}
