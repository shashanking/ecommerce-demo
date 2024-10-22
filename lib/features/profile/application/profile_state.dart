// To parse this JSON data, do
//
//     final editProfile = editProfileFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whatsinit/features/profile/application/contact_form_data.dart';
import 'dart:convert';

import 'package:whatsinit/features/profile/application/user_profile.dart';

import '../domain/order_model.dart';
import '../domain/user_review_model.dart';

part 'profile_state.freezed.dart';
part 'profile_state.g.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) isLoading,
    @Default(UserProfile()) UserProfile userProfile,
    @Default(ContactData()) ContactData contactData,
    @Default([]) List<OrderData> orderDataList,
    OrderData? fetchedOrder,
    @Default([]) List<UserReviewModel> userReviewList,
    int? orderPages,
    @Default(1) int currentOrderPage,
    int? tempRating,
  }) = _ProfileState;

  factory ProfileState.fromJson(Map<String, dynamic> json) =>
      _$ProfileStateFromJson(json);
}
