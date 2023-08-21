// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kagura.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Kagura _$KaguraFromJson(Map<String, dynamic> json) {
  return _Kagura.fromJson(json);
}

/// @nodoc
mixin _$Kagura {
  String get id => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $KaguraCopyWith<Kagura> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KaguraCopyWith<$Res> {
  factory $KaguraCopyWith(Kagura value, $Res Function(Kagura) then) =
      _$KaguraCopyWithImpl<$Res, Kagura>;
  @useResult
  $Res call({String id, String uid});
}

/// @nodoc
class _$KaguraCopyWithImpl<$Res, $Val extends Kagura>
    implements $KaguraCopyWith<$Res> {
  _$KaguraCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_KaguraCopyWith<$Res> implements $KaguraCopyWith<$Res> {
  factory _$$_KaguraCopyWith(_$_Kagura value, $Res Function(_$_Kagura) then) =
      __$$_KaguraCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String uid});
}

/// @nodoc
class __$$_KaguraCopyWithImpl<$Res>
    extends _$KaguraCopyWithImpl<$Res, _$_Kagura>
    implements _$$_KaguraCopyWith<$Res> {
  __$$_KaguraCopyWithImpl(_$_Kagura _value, $Res Function(_$_Kagura) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uid = null,
  }) {
    return _then(_$_Kagura(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Kagura implements _Kagura {
  const _$_Kagura({required this.id, this.uid = ''});

  factory _$_Kagura.fromJson(Map<String, dynamic> json) =>
      _$$_KaguraFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String uid;

  @override
  String toString() {
    return 'Kagura(id: $id, uid: $uid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Kagura &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, uid);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_KaguraCopyWith<_$_Kagura> get copyWith =>
      __$$_KaguraCopyWithImpl<_$_Kagura>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_KaguraToJson(
      this,
    );
  }
}

abstract class _Kagura implements Kagura {
  const factory _Kagura({required final String id, final String uid}) =
      _$_Kagura;

  factory _Kagura.fromJson(Map<String, dynamic> json) = _$_Kagura.fromJson;

  @override
  String get id;
  @override
  String get uid;
  @override
  @JsonKey(ignore: true)
  _$$_KaguraCopyWith<_$_Kagura> get copyWith =>
      throw _privateConstructorUsedError;
}
