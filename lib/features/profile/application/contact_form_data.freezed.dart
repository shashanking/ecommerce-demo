// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContactData _$ContactDataFromJson(Map<String, dynamic> json) {
  return _ContactData.fromJson(json);
}

/// @nodoc
mixin _$ContactData {
  String? get mobileNumber => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContactDataCopyWith<ContactData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContactDataCopyWith<$Res> {
  factory $ContactDataCopyWith(
          ContactData value, $Res Function(ContactData) then) =
      _$ContactDataCopyWithImpl<$Res, ContactData>;
  @useResult
  $Res call({String? mobileNumber, String? email, String? description});
}

/// @nodoc
class _$ContactDataCopyWithImpl<$Res, $Val extends ContactData>
    implements $ContactDataCopyWith<$Res> {
  _$ContactDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mobileNumber = freezed,
    Object? email = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      mobileNumber: freezed == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContactDataImplCopyWith<$Res>
    implements $ContactDataCopyWith<$Res> {
  factory _$$ContactDataImplCopyWith(
          _$ContactDataImpl value, $Res Function(_$ContactDataImpl) then) =
      __$$ContactDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? mobileNumber, String? email, String? description});
}

/// @nodoc
class __$$ContactDataImplCopyWithImpl<$Res>
    extends _$ContactDataCopyWithImpl<$Res, _$ContactDataImpl>
    implements _$$ContactDataImplCopyWith<$Res> {
  __$$ContactDataImplCopyWithImpl(
      _$ContactDataImpl _value, $Res Function(_$ContactDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mobileNumber = freezed,
    Object? email = freezed,
    Object? description = freezed,
  }) {
    return _then(_$ContactDataImpl(
      mobileNumber: freezed == mobileNumber
          ? _value.mobileNumber
          : mobileNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ContactDataImpl implements _ContactData {
  const _$ContactDataImpl({this.mobileNumber, this.email, this.description});

  factory _$ContactDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContactDataImplFromJson(json);

  @override
  final String? mobileNumber;
  @override
  final String? email;
  @override
  final String? description;

  @override
  String toString() {
    return 'ContactData(mobileNumber: $mobileNumber, email: $email, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContactDataImpl &&
            (identical(other.mobileNumber, mobileNumber) ||
                other.mobileNumber == mobileNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mobileNumber, email, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContactDataImplCopyWith<_$ContactDataImpl> get copyWith =>
      __$$ContactDataImplCopyWithImpl<_$ContactDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContactDataImplToJson(
      this,
    );
  }
}

abstract class _ContactData implements ContactData {
  const factory _ContactData(
      {final String? mobileNumber,
      final String? email,
      final String? description}) = _$ContactDataImpl;

  factory _ContactData.fromJson(Map<String, dynamic> json) =
      _$ContactDataImpl.fromJson;

  @override
  String? get mobileNumber;
  @override
  String? get email;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$ContactDataImplCopyWith<_$ContactDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
