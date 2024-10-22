// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileStateImpl _$$ProfileStateImplFromJson(Map<String, dynamic> json) =>
    _$ProfileStateImpl(
      isLoading: json['isLoading'] ?? false,
      userProfile: json['userProfile'] == null
          ? const UserProfile()
          : UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
      contactData: json['contactData'] == null
          ? const ContactData()
          : ContactData.fromJson(json['contactData'] as Map<String, dynamic>),
      orderDataList: (json['orderDataList'] as List<dynamic>?)
              ?.map((e) => OrderData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      fetchedOrder: json['fetchedOrder'] == null
          ? null
          : OrderData.fromJson(json['fetchedOrder'] as Map<String, dynamic>),
      userReviewList: (json['userReviewList'] as List<dynamic>?)
              ?.map((e) => UserReviewModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      orderPages: json['orderPages'] as int?,
      currentOrderPage: json['currentOrderPage'] as int? ?? 1,
      tempRating: json['tempRating'] as int?,
    );

Map<String, dynamic> _$$ProfileStateImplToJson(_$ProfileStateImpl instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'userProfile': instance.userProfile,
      'contactData': instance.contactData,
      'orderDataList': instance.orderDataList,
      'fetchedOrder': instance.fetchedOrder,
      'userReviewList': instance.userReviewList,
      'orderPages': instance.orderPages,
      'currentOrderPage': instance.currentOrderPage,
      'tempRating': instance.tempRating,
    };
