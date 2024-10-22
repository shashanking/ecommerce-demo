import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsinit/features/profile/application/profile_state.dart';
import 'package:whatsinit/features/profile/application/user_profile.dart';
import 'package:whatsinit/features/profile/domain/order_model.dart';

import '../../../core/infrastructure/api_url.dart';
import '../../../core/infrastructure/hive_database.dart';
import '../../../core/infrastructure/network_api_services.dart';
import '../../../core/utils/app_log.dart';
import '../../../core/utils/toast.dart';
import '../domain/user_review_model.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._networkApiService, this._hiveDatabase)
      : super(const ProfileState()) {}

  final NetworkApiService _networkApiService;
  final HiveDatabase _hiveDatabase;
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController contactDescriptionController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // refreshController.dispose();
  }

  void clearOrderList() {
    state = state.copyWith(
      userReviewList: [],
      isLoading: true,
      tempRating: null,
      currentOrderPage: 1,
      orderPages: null,
      orderDataList: [],
    );
  }

  Future<void> updateReview({
    required String reviewID,
    required int rating,
    required String desc,
    VoidCallback? voidCallback,
  }) async {
    if (rating == 0) {
      showToastMessage('Rating cannot be 0');
    }
    // else if (desc.isEmpty) {
    //   showToastMessage('Please Add Description');
    // }
    // else if (desc.length < 4) {
    //   showToastMessage('Description too short');
    // }
    else {
      state = state.copyWith(isLoading: true);
      final body = {
        "review_id": reviewID,
        "rating": rating,
        "description": desc
      };
      try {
        var (response, dioException) = await _networkApiService
            .postApiRequestWithToken(url: AppUrl.updateReview, body: body);
        state = state.copyWith(isLoading: false);
        if (response == null && dioException == null) {
          showconnectionWasInterruptedToastMesage();
        } else if (dioException != null) {
          showDioError(dioException);
        } else {
          final Map<String, dynamic> jsonData = response.data;
          AppLog.log('reviewupdate----${jsonData.toString()}');
          if (jsonData['status'] == 200) {
            clearOrderList();
            // await getOrdersList(voidCallback: () {});
            await getReviewList(
              () {},
            );
            state = state.copyWith(isLoading: false);
            if (voidCallback != null) {
              voidCallback.call();
            }
          } else {
            showToastMessage(jsonData['message']);
          }
        }
      } catch (error, stacktrace) {
        state = state.copyWith(isLoading: false);
        AppLog.log('review-update Total Error: $error');
        showconnectionWasInterruptedToastMesage();
        print("Error: $error, Stacktrace: $stacktrace");
      }
    }
  }

  Future<void> removeReview({
    required String reviewId,
    VoidCallback? voidCallback,
  }) async {
    state = state.copyWith(isLoading: true);
    final body = {"review_id": reviewId};
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: AppUrl.removeReview, body: body);
      state = state.copyWith(isLoading: false);
      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log('reviewcreated----${jsonData.toString()}');
        state = state.copyWith(isLoading: false);
        if (jsonData['status'] == 200) {
          //success
          clearOrderList();
          await getReviewList(() {});
          // await getOrdersList(voidCallback: () {});

          showToastMessage(jsonData['message']);
          if (voidCallback != null) voidCallback.call();
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error, stacktrace) {
      state = state.copyWith(isLoading: false);
      AppLog.log('review deletion Total Error: $error');
      showconnectionWasInterruptedToastMesage();
      print("Error: $error, Stacktrace: $stacktrace");
    }
  }

  Future<void> createReview({
    required String rating,
    required String desc,
    required String orderId,
    required String productId,
    // VoidCallback? voidCallback,
  }) async {
    if (state.tempRating == 0) {
      showToastMessage('Rating cannot be 0');
    }
    // else if (desc.isEmpty) {
    //   showToastMessage('Please Add Description');
    // }
    // else if (desc.length < 4) {
    //   showToastMessage('Description too short');
    // }
    else {
      state = state.copyWith(isLoading: true);

      final body = {
        "product_id": productId,
        "rating": rating,
        "order_id": orderId,
        "description": desc,
      };
      // await Future.delayed(Duration(seconds: 3))
      //     .then((value) => showToastMessage('3secs'));
      try {
        var (response, dioException) = await _networkApiService
            .postApiRequestWithToken(url: AppUrl.createRating, body: body);
        state = state.copyWith(isLoading: false);
        if (response == null && dioException == null) {
          showconnectionWasInterruptedToastMesage();
        } else if (dioException != null) {
          showDioError(dioException);
        } else {
          Map<String, dynamic> jsonData = response.data;
          AppLog.log('reviewcreated----${jsonData.toString()}');
          if (jsonData['status'] == 200) {
            clearOrderList();
            await getOrdersList(voidCallback: () {});
            state = state.copyWith(isLoading: false);
            showToastMessage(jsonData['message']);
            // if (voidCallback != null) {
            //   voidCallback.call();
            // }
          } else {
            showToastMessage(jsonData['message']);
          }
        }
      } catch (error, stacktrace) {
        state = state.copyWith(isLoading: false);
        AppLog.log('reviews Total Error: $error');
        showconnectionWasInterruptedToastMesage();
        print("Error: $error, Stacktrace: $stacktrace");
      }
    }
  }

  setTempRating(int val) {
    state = state.copyWith(tempRating: val);
  }

  updateCurrentpage() {
    state = state.copyWith(currentOrderPage: state.currentOrderPage + 1);
  }

  Future<void> getReviewList(VoidCallback? voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService
          .getApiRequestWithToken(url: AppUrl.listReviews);
      state = state.copyWith(isLoading: false);
      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        final List<UserReviewModel> reviewsList = [];
        AppLog.log('reviewlist----${jsonData.toString()}');
        if (jsonData['status'] == 200) {
          for (Map<String, dynamic> item in jsonData['data']) {
            final userReviewData = UserReviewModel.fromJson(item);
            reviewsList.add(userReviewData);
          }
          if (reviewsList.isNotEmpty) {
            state = state.copyWith(userReviewList: reviewsList);
          } else {
            showToastMessage('List could not be populated');
          }

          if (voidCallback != null) {
            voidCallback.call();
          }
        } else {}
      }
    } catch (error, stacktrace) {
      state = state.copyWith(isLoading: false);
      AppLog.log('reviews Total Error: $error');
      showconnectionWasInterruptedToastMesage();
      print("Error: $error, Stacktrace: $stacktrace");
    }
  }

  Future<void> getOrder(
      {required String orderId, required String productId}) async {
    state = state.copyWith(isLoading: true);
    final body = {"order_id": orderId, "product_id": productId};
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: AppUrl.getOrder, body: body);
      state = state.copyWith(isLoading: false);
      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log('order----${jsonData.toString()}');
        if (jsonData['status'] == 200 && jsonData['data'].first != null) {
          final Map<String, dynamic> fetchedOrder = jsonData['data'].first;
          final OrderData order = OrderData.fromJson(fetchedOrder);
          state = state.copyWith(fetchedOrder: order);
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error, stacktrace) {
      state = state.copyWith(isLoading: false);
      AppLog.log('signleOrder Total Error: $error');
      showconnectionWasInterruptedToastMesage();
      print("Error: $error, Stacktrace: $stacktrace");
    }
  }

  Future<void> getOrdersList({
    int? limit,
    VoidCallback? voidCallback,
  }) async {
    state = state.copyWith(isLoading: true);
    final body = {
      "page": state.currentOrderPage,
      "limit": limit ?? "",
    };
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: AppUrl.listOrder, body: body);
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log('orderlist----${jsonData.toString()}');
        if (jsonData['status'] == 200) {
          if (state.orderPages == null ||
              state.orderPages != jsonData['data']['pages']) {
            state = state.copyWith(
                orderPages: jsonData['data']['pages'],
                currentOrderPage: jsonData['data']['page']);
          }
          //success
          // showToastMessage(jsonData['message']);

          var orderDataList = <OrderData>[];
          final ordersData = jsonData['data']['docs'];

          /// save orders in model and save a list of models in state

          for (var item in ordersData) {
            final OrderData order = OrderData(
              id: item["_id"],
              amount: double.parse(item['amount'].toString()),
              orderId: item['order_id'],
              orderDate: item['order_date'],
              status: item['status'],
              productDetails: ProductDetails.fromJson(item['product_details']),
              shippingAddressId: item['shipping_address_id'],
              orderStatus: item['order_status'],
              createdAt: item['createdAt'],
              updatedAt: item['updatedAt'],
              avgRating: item['avg_rating'],
              isDeleted: item['isDeleted'],
              shippingDetails:
                  ShippingDetails.fromJson(item['shipping_details']),
              confirmationDate: item['confirmation_date'],
              deliveryDate: item['delivery_date'],
              shippingDate: item['shipping_date'],
              userReviewData: (item['userReviewdata'] as List<dynamic>)
                  .map((e) => UserReviewData.fromJson(e))
                  .toList(),
            );
            orderDataList.add(order);
          }
          if (orderDataList.isNotEmpty) {
            if (state.orderDataList.isNotEmpty) {
              state = state.copyWith(orderDataList: [
                ...orderDataList,
                ...state.orderDataList,
              ]);
            } else {
              state = state.copyWith(orderDataList: orderDataList);
            }
            if (voidCallback != null) {
              voidCallback.call();
            }
          }
        } else {
          showToastMessage('${jsonData['status']}: ${jsonData['message']}');
        }
      }
    } catch (error, stacktrace) {
      state = state.copyWith(isLoading: false);
      AppLog.log('Orders Total Error: $error');
      showconnectionWasInterruptedToastMesage();
      print("Error: $error, Stacktrace: $stacktrace");
    }
  }

  /// [setContactData] : This method will update Contact Data in state,
  /// If we pass only one or 2 field values here. Other fields will remain intact.
  void setContactData({
    String? mobileNumber,
    String? email,
    String? description,
  }) {
    final updatedEmail = email ?? state.contactData.email;
    final updatedMobileNumber = mobileNumber ?? state.contactData.mobileNumber;
    final updatedDescription = description ?? state.contactData.description;

    state = state.copyWith(
        contactData: state.contactData.copyWith(
      email: updatedEmail,
      mobileNumber: updatedMobileNumber,
      description: updatedDescription,
    ));
  }

  bool validateContactFormFields() {
    final email = contactEmailController.text.trim();
    final phone = contactPhoneController.text.trim();
    final desc = contactDescriptionController.text.trim();

    String emailPattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(emailPattern);

    // if (email == "" || phone == "" || desc == "") {
    //   showToastMessage("All fields are mandatory...");
    //   return false;
    // }

    if (email == "") {
      showToastMessage("Email field is required");
      return false;
    } else if (!regex.hasMatch(email)) {
      showToastMessage("Please Enter a Valid Email");
      return false;
    } else if (phone == "") {
      showToastMessage("Phone Number field is required");
      return false;
    } else if (phone.length < 8) {
      showToastMessage(
          "The phone number should be at least 8 digits in length");
      return false;
    } else if (phone.length > 15) {
      showToastMessage(
          "The phone number should not exceed 15 digits in length");
      return false;
    } else if (desc == "") {
      showToastMessage("Description field is required");
      return false;
    }

    return true;
  }

  Future<void> getUserProfile({VoidCallback? voidCallback}) async {
    state = state.copyWith(isLoading: true);

    try {
      var (response, dioException) = await _networkApiService
          .getApiRequestWithToken(url: AppUrl.userDetails);
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log("userjson---${jsonData.toString()}");
        if (jsonData['status'] == 200) {
          state = state.copyWith(
            userProfile: UserProfile.fromJson(jsonData),
          );
        }

        // showToastMessage(jsonData['message'] ?? '');
        if (jsonData['status'] == 200) {
          if (voidCallback != null) {
            voidCallback.call();
          }
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  Future<void> createContact({
    VoidCallback? onSuccess,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final mobileNumber = state.contactData.mobileNumber;
      final email = state.contactData.email;
      final description = state.contactData.description;
      FormData requestBody = FormData.fromMap({
        "email": email,
        "mobile_number": mobileNumber,
        "description": description,
      });

      final bool validationStatus = validateContactFormFields();

      if (validationStatus) {
        var (response, dioException) =
            await _networkApiService.postApiRequestWithToken(
          url: AppUrl.createContact,
          body: requestBody,
        );
        state = state.copyWith(isLoading: false);

        if (response == null && dioException == null) {
          showconnectionWasInterruptedToastMesage();
        } else if (dioException != null) {
          showDioError(dioException);
        } else {
          Map<String, dynamic> jsonData = response.data;
          AppLog.log("${jsonData.toString()}");

          if (jsonData['status'] == 200) {
            state = state.copyWith(
              contactData: state.contactData.copyWith(
                email: "",
                mobileNumber: "",
                description: "",
              ),
            );
            contactEmailController.text = "";
            contactPhoneController.text = "";
            contactDescriptionController.text = "";
            if (onSuccess != null) {
              onSuccess.call();
            }
          }
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  update(String fullName, String img, VoidCallback? callback) async {
    state = state.copyWith(isLoading: true);

    try {
      final userData = state.userProfile.data;
      final phone = userData?.phone ?? '';
      final email = userData?.email ?? '';
      final countryId =
          _hiveDatabase.box.get(AppPreferenceKeys.countryId) ?? '';
      final cityId = _hiveDatabase.box.get(AppPreferenceKeys.cityId) ?? '';
      // _hiveDatabase.box.get(AppPreferenceKeys.cityId);

      FormData formData = FormData.fromMap({
        "full_name": fullName,
        "phone": _hiveDatabase.box.get(AppPreferenceKeys.phone) ?? phone,
        "email": _hiveDatabase.box.get(AppPreferenceKeys.email) ?? phone,
        "country_id": countryId,
        "city_id": cityId,
        if (img.split('/').last.isNotEmpty)
          "profile_image":
              await MultipartFile.fromFile(img, filename: img.split('/').last),
      });

      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: AppUrl.updateProfile, body: formData);

      _hiveDatabase.box.put(AppPreferenceKeys.fullName, fullName);
      state = state.copyWith(
        isLoading: false,
      );

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log("${jsonData.toString()}");
        if (jsonData['status'] == 200) {
          ///TODO Profile Image need to be updated
          state = state.copyWith(
              userProfile: const UserProfile().copyWith(
                  data: Data(
            fullName: fullName,
            phone: phone,
            email: email,
            profileImage: (jsonData['data']['profile_image'] ?? ''),
          )));
        }
        _hiveDatabase.box.put(AppPreferenceKeys.profileImage,
            state.userProfile.data?.profileImage ?? '');
        showToastMessage(jsonData['message'] ?? '');
        callback?.call();
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      AppLog.log(error.toString());
      showconnectionWasInterruptedToastMesage();
    }
  }

  completeProfile(
      String fullName,
      String img,
      String? userEmail,
      String? phoneNo,
      String? userCityId,
      String? userCountryId,
      VoidCallback? callback) async {
    state = state.copyWith(isLoading: true);

    try {
      final userData = state.userProfile.data;
      final phone = userData?.phone ?? '';
      final email = userData?.email ?? '';
      final countryId =
          _hiveDatabase.box.get(AppPreferenceKeys.countryId) ?? '';
      final cityId = _hiveDatabase.box.get(AppPreferenceKeys.cityId) ?? '';
      // _hiveDatabase.box.get(AppPreferenceKeys.cityId);

      FormData formData = FormData.fromMap({
        "full_name": fullName,
        "phone": phoneNo ?? phone,
        "email": _hiveDatabase.box.get(AppPreferenceKeys.email) ??
            userEmail ??
            email,
        "country_id": userCountryId ?? countryId,
        "city_id": userCityId ?? cityId,
      });

      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: AppUrl.updateProfile, body: formData);

      _hiveDatabase.box.put(AppPreferenceKeys.fullName, fullName);
      state = state.copyWith(
        isLoading: false,
      );

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log("${jsonData.toString()}");
        if (jsonData['status'] == 200) {
          ///TODO Profile Image need to be updated
          state = state.copyWith(
              userProfile: const UserProfile().copyWith(
                  data: Data(
            fullName: fullName,
            phone: phone,
            email: email,
            profileImage: (jsonData['data']['profile_image'] ?? ''),
          )));

          _hiveDatabase.box.put(AppPreferenceKeys.profileImage,
              state.userProfile.data?.profileImage ?? '');

          showToastMessage(jsonData['message'] ?? '');
          callback?.call();
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      AppLog.log(error.toString());
      showconnectionWasInterruptedToastMesage();
    }
  }
}
