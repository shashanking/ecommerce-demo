// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProfileState _$ProfileStateFromJson(Map<String, dynamic> json) {
  return _ProfileState.fromJson(json);
}

/// @nodoc
mixin _$ProfileState {
  dynamic get isLoading => throw _privateConstructorUsedError;
  UserProfile get userProfile => throw _privateConstructorUsedError;
  ContactData get contactData => throw _privateConstructorUsedError;
  List<OrderData> get orderDataList => throw _privateConstructorUsedError;
  OrderData? get fetchedOrder => throw _privateConstructorUsedError;
  List<UserReviewModel> get userReviewList =>
      throw _privateConstructorUsedError;
  int? get orderPages => throw _privateConstructorUsedError;
  int get currentOrderPage => throw _privateConstructorUsedError;
  int? get tempRating => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileStateCopyWith<ProfileState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStateCopyWith<$Res> {
  factory $ProfileStateCopyWith(
          ProfileState value, $Res Function(ProfileState) then) =
      _$ProfileStateCopyWithImpl<$Res, ProfileState>;
  @useResult
  $Res call(
      {dynamic isLoading,
      UserProfile userProfile,
      ContactData contactData,
      List<OrderData> orderDataList,
      OrderData? fetchedOrder,
      List<UserReviewModel> userReviewList,
      int? orderPages,
      int currentOrderPage,
      int? tempRating});

  $UserProfileCopyWith<$Res> get userProfile;
  $ContactDataCopyWith<$Res> get contactData;
  $OrderDataCopyWith<$Res>? get fetchedOrder;
}

/// @nodoc
class _$ProfileStateCopyWithImpl<$Res, $Val extends ProfileState>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = freezed,
    Object? userProfile = null,
    Object? contactData = null,
    Object? orderDataList = null,
    Object? fetchedOrder = freezed,
    Object? userReviewList = null,
    Object? orderPages = freezed,
    Object? currentOrderPage = null,
    Object? tempRating = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as dynamic,
      userProfile: null == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      contactData: null == contactData
          ? _value.contactData
          : contactData // ignore: cast_nullable_to_non_nullable
              as ContactData,
      orderDataList: null == orderDataList
          ? _value.orderDataList
          : orderDataList // ignore: cast_nullable_to_non_nullable
              as List<OrderData>,
      fetchedOrder: freezed == fetchedOrder
          ? _value.fetchedOrder
          : fetchedOrder // ignore: cast_nullable_to_non_nullable
              as OrderData?,
      userReviewList: null == userReviewList
          ? _value.userReviewList
          : userReviewList // ignore: cast_nullable_to_non_nullable
              as List<UserReviewModel>,
      orderPages: freezed == orderPages
          ? _value.orderPages
          : orderPages // ignore: cast_nullable_to_non_nullable
              as int?,
      currentOrderPage: null == currentOrderPage
          ? _value.currentOrderPage
          : currentOrderPage // ignore: cast_nullable_to_non_nullable
              as int,
      tempRating: freezed == tempRating
          ? _value.tempRating
          : tempRating // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res> get userProfile {
    return $UserProfileCopyWith<$Res>(_value.userProfile, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ContactDataCopyWith<$Res> get contactData {
    return $ContactDataCopyWith<$Res>(_value.contactData, (value) {
      return _then(_value.copyWith(contactData: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrderDataCopyWith<$Res>? get fetchedOrder {
    if (_value.fetchedOrder == null) {
      return null;
    }

    return $OrderDataCopyWith<$Res>(_value.fetchedOrder!, (value) {
      return _then(_value.copyWith(fetchedOrder: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileStateImplCopyWith<$Res>
    implements $ProfileStateCopyWith<$Res> {
  factory _$$ProfileStateImplCopyWith(
          _$ProfileStateImpl value, $Res Function(_$ProfileStateImpl) then) =
      __$$ProfileStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic isLoading,
      UserProfile userProfile,
      ContactData contactData,
      List<OrderData> orderDataList,
      OrderData? fetchedOrder,
      List<UserReviewModel> userReviewList,
      int? orderPages,
      int currentOrderPage,
      int? tempRating});

  @override
  $UserProfileCopyWith<$Res> get userProfile;
  @override
  $ContactDataCopyWith<$Res> get contactData;
  @override
  $OrderDataCopyWith<$Res>? get fetchedOrder;
}

/// @nodoc
class __$$ProfileStateImplCopyWithImpl<$Res>
    extends _$ProfileStateCopyWithImpl<$Res, _$ProfileStateImpl>
    implements _$$ProfileStateImplCopyWith<$Res> {
  __$$ProfileStateImplCopyWithImpl(
      _$ProfileStateImpl _value, $Res Function(_$ProfileStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = freezed,
    Object? userProfile = null,
    Object? contactData = null,
    Object? orderDataList = null,
    Object? fetchedOrder = freezed,
    Object? userReviewList = null,
    Object? orderPages = freezed,
    Object? currentOrderPage = null,
    Object? tempRating = freezed,
  }) {
    return _then(_$ProfileStateImpl(
      isLoading: freezed == isLoading ? _value.isLoading! : isLoading,
      userProfile: null == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile,
      contactData: null == contactData
          ? _value.contactData
          : contactData // ignore: cast_nullable_to_non_nullable
              as ContactData,
      orderDataList: null == orderDataList
          ? _value._orderDataList
          : orderDataList // ignore: cast_nullable_to_non_nullable
              as List<OrderData>,
      fetchedOrder: freezed == fetchedOrder
          ? _value.fetchedOrder
          : fetchedOrder // ignore: cast_nullable_to_non_nullable
              as OrderData?,
      userReviewList: null == userReviewList
          ? _value._userReviewList
          : userReviewList // ignore: cast_nullable_to_non_nullable
              as List<UserReviewModel>,
      orderPages: freezed == orderPages
          ? _value.orderPages
          : orderPages // ignore: cast_nullable_to_non_nullable
              as int?,
      currentOrderPage: null == currentOrderPage
          ? _value.currentOrderPage
          : currentOrderPage // ignore: cast_nullable_to_non_nullable
              as int,
      tempRating: freezed == tempRating
          ? _value.tempRating
          : tempRating // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileStateImpl implements _ProfileState {
  const _$ProfileStateImpl(
      {this.isLoading = false,
      this.userProfile = const UserProfile(),
      this.contactData = const ContactData(),
      final List<OrderData> orderDataList = const [],
      this.fetchedOrder,
      final List<UserReviewModel> userReviewList = const [],
      this.orderPages,
      this.currentOrderPage = 1,
      this.tempRating})
      : _orderDataList = orderDataList,
        _userReviewList = userReviewList;

  factory _$ProfileStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileStateImplFromJson(json);

  @override
  @JsonKey()
  final dynamic isLoading;
  @override
  @JsonKey()
  final UserProfile userProfile;
  @override
  @JsonKey()
  final ContactData contactData;
  final List<OrderData> _orderDataList;
  @override
  @JsonKey()
  List<OrderData> get orderDataList {
    if (_orderDataList is EqualUnmodifiableListView) return _orderDataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderDataList);
  }

  @override
  final OrderData? fetchedOrder;
  final List<UserReviewModel> _userReviewList;
  @override
  @JsonKey()
  List<UserReviewModel> get userReviewList {
    if (_userReviewList is EqualUnmodifiableListView) return _userReviewList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userReviewList);
  }

  @override
  final int? orderPages;
  @override
  @JsonKey()
  final int currentOrderPage;
  @override
  final int? tempRating;

  @override
  String toString() {
    return 'ProfileState(isLoading: $isLoading, userProfile: $userProfile, contactData: $contactData, orderDataList: $orderDataList, fetchedOrder: $fetchedOrder, userReviewList: $userReviewList, orderPages: $orderPages, currentOrderPage: $currentOrderPage, tempRating: $tempRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStateImpl &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            (identical(other.contactData, contactData) ||
                other.contactData == contactData) &&
            const DeepCollectionEquality()
                .equals(other._orderDataList, _orderDataList) &&
            (identical(other.fetchedOrder, fetchedOrder) ||
                other.fetchedOrder == fetchedOrder) &&
            const DeepCollectionEquality()
                .equals(other._userReviewList, _userReviewList) &&
            (identical(other.orderPages, orderPages) ||
                other.orderPages == orderPages) &&
            (identical(other.currentOrderPage, currentOrderPage) ||
                other.currentOrderPage == currentOrderPage) &&
            (identical(other.tempRating, tempRating) ||
                other.tempRating == tempRating));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLoading),
      userProfile,
      contactData,
      const DeepCollectionEquality().hash(_orderDataList),
      fetchedOrder,
      const DeepCollectionEquality().hash(_userReviewList),
      orderPages,
      currentOrderPage,
      tempRating);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      __$$ProfileStateImplCopyWithImpl<_$ProfileStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileStateImplToJson(
      this,
    );
  }
}

abstract class _ProfileState implements ProfileState {
  const factory _ProfileState(
      {final dynamic isLoading,
      final UserProfile userProfile,
      final ContactData contactData,
      final List<OrderData> orderDataList,
      final OrderData? fetchedOrder,
      final List<UserReviewModel> userReviewList,
      final int? orderPages,
      final int currentOrderPage,
      final int? tempRating}) = _$ProfileStateImpl;

  factory _ProfileState.fromJson(Map<String, dynamic> json) =
      _$ProfileStateImpl.fromJson;

  @override
  dynamic get isLoading;
  @override
  UserProfile get userProfile;
  @override
  ContactData get contactData;
  @override
  List<OrderData> get orderDataList;
  @override
  OrderData? get fetchedOrder;
  @override
  List<UserReviewModel> get userReviewList;
  @override
  int? get orderPages;
  @override
  int get currentOrderPage;
  @override
  int? get tempRating;
  @override
  @JsonKey(ignore: true)
  _$$ProfileStateImplCopyWith<_$ProfileStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
