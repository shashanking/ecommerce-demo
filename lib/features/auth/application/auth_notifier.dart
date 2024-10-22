// ignore_for_file: parameter_assignments, empty_catches

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whatsinit/core/infrastructure/api_url.dart';
import 'package:whatsinit/features/auth/domain/city_entiry.dart';
import 'package:whatsinit/features/auth/domain/country_entiry.dart';

import '../../../core/infrastructure/hive_database.dart';
import '../../../core/infrastructure/network_api_services.dart';
import '../../../core/utils/app_log.dart';
import '../../../core/utils/toast.dart';
import '../../../core/utils/validator.dart';
import 'auth_state.dart';
import 'dart:io' show Platform;

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._networkApiService, this._hiveDatabase)
      : super(const AuthState()) {
    fetchCountry();
  }

  final NetworkApiService _networkApiService;

  final HiveDatabase _hiveDatabase;

  //login
  final TextEditingController loginEmailTextController =
      TextEditingController();
  final TextEditingController loginPasswordTextController =
      TextEditingController();

  //signup
  final TextEditingController signupEmailTextController =
      TextEditingController();
  final TextEditingController signupNameTextController =
      TextEditingController();
  final TextEditingController signupMobileTextController =
      TextEditingController();
  final TextEditingController signupPasswordTextController =
      TextEditingController();
  //forgot password

  final TextEditingController otpTextController = TextEditingController();

  final TextEditingController forgotMobileTextController =
      TextEditingController();
  // final TextEditingController forgotEmailTextController =
  //     TextEditingController();
  final TextEditingController forgotPassowrdTextController =
      TextEditingController();
  final TextEditingController forgotCPassowrdTextController =
      TextEditingController();
  final TextEditingController changeOPassowrdTextController =
      TextEditingController();
  final TextEditingController changePassowrdTextController =
      TextEditingController();
  final TextEditingController changeCPassowrdTextController =
      TextEditingController();
  void resetValues() {
    loginEmailTextController.clear();
    loginPasswordTextController.clear();
    signupEmailTextController.clear();
    signupNameTextController.clear();
    signupMobileTextController.clear();
    signupPasswordTextController.clear();
    otpTextController.clear();
    forgotMobileTextController.clear();
    forgotPassowrdTextController.clear();
    forgotCPassowrdTextController.clear();
    changeOPassowrdTextController.clear();
    changePassowrdTextController.clear();
    changeCPassowrdTextController.clear();
    // var pass = _hiveDatabase.box.get(AppPreferenceKeys.password);
    // if (pass != null) {
    //   print(" from hive : $pass");
    // }
    state = state.copyWith(
      checked: false,
      selectedCity: null,
      selectedCode: null,
    );
  }

  bool validateLoginFields() {
    if (loginEmailTextController.text.isEmpty) {
      showToastMessage('Please enter email');
      return false;
    } else if (!Validator.validateEmail(loginEmailTextController.text)) {
      showToastMessage('Please enter valid email');
      return false;
    } else if (loginPasswordTextController.text.isEmpty) {
      showToastMessage('Please enter password');
      return false;
    } else {
      return true;
    }
  }

  bool validateForgotPassowrdFields() {
    if (forgotMobileTextController.text.isEmpty) {
      showToastMessage('Please enter mobile number');
      return false;
    } else if (forgotMobileTextController.text.length < 10) {
      showToastMessage('Please enter valid mobile number');
      return false;
    } else {
      return true;
    }
  }

  bool validateChangeFields() {
    if (forgotPassowrdTextController.text.isEmpty) {
      showToastMessage('Please enter password');
      return false;
    } else if (forgotPassowrdTextController.text.length < 6) {
      showToastMessage('Please enter atlease 6 digit password');
      return false;
    } else if (forgotCPassowrdTextController.text.isEmpty) {
      showToastMessage('Please enter confirm password');
      return false;
    } else if (forgotCPassowrdTextController.text.length < 6) {
      showToastMessage('Please enter atlease 6 digit confirm password');
      return false;
    } else if (forgotPassowrdTextController.text !=
        forgotCPassowrdTextController.text) {
      showToastMessage('Password mismatch');
      // forgotCPassowrdTextController.text = '';
      // forgotPassowrdTextController.text = '';
      return false;
    } else {
      return true;
    }
  }

  bool validateChangePasswordFields() {
    if (changeOPassowrdTextController.text.isEmpty) {
      showToastMessage('Please enter old password');
      return false;
    } else if (changeOPassowrdTextController.text.length < 6) {
      showToastMessage('Please enter atlease 6 digit old password');
      return false;
    } else if (changePassowrdTextController.text.isEmpty) {
      showToastMessage('Please enter password');
      return false;
    } else if (changePassowrdTextController.text.length < 6) {
      showToastMessage('Please enter atlease 6 digit password');
      return false;
    } else if (changeCPassowrdTextController.text.isEmpty) {
      showToastMessage('Please enter confirm password');
      return false;
    } else if (changeCPassowrdTextController.text.length < 6) {
      showToastMessage('Please enter atlease 6 digit confirm password');
      return false;
    } else if (changePassowrdTextController.text !=
        changeCPassowrdTextController.text) {
      showToastMessage('Password mismatch');
      return false;
    } else {
      return true;
    }
  }

  bool validateSignupFields() {
    if (signupNameTextController.text.isEmpty) {
      showToastMessage('Please enter name');
      return false;
    } else if (signupEmailTextController.text.isEmpty) {
      showToastMessage('Please enter email');
      return false;
    } else if (!Validator.validateEmail(signupEmailTextController.text)) {
      showToastMessage('Please enter valid email');
      return false;
    } else if (state.selectedCountry == null) {
      showToastMessage('Please select country');
      return false;
    } else if (state.selectedCity == null) {
      showToastMessage('Please select city');
      return false;
    } else if (signupMobileTextController.text.isEmpty ||
        signupMobileTextController.text.length < 12) {
      showToastMessage('Please enter mobile');
      return false;
    } else if (signupPasswordTextController.text.isEmpty) {
      showToastMessage('Please enter password');
      return false;
    } else if (signupPasswordTextController.text.length < 6) {
      showToastMessage('Please enter atlease 6 digit password');
      return false;
    } else if (state.checked == false) {
      showToastMessage('Please accept terms and condition');
      return false;
    } else {
      return true;
    }
  }

  bool validateCompleteProfileFields() {
    if (signupNameTextController.text.isEmpty) {
      showToastMessage('Please enter name');
      return false;
    } else if (state.selectedCountry == null) {
      showToastMessage('Please select country');
      return false;
    } else if (state.selectedCity == null) {
      showToastMessage('Please select city');
      return false;
    } else if (signupMobileTextController.text.isEmpty ||
        signupMobileTextController.text.length < 12) {
      showToastMessage('Please enter mobile');
      return false;
    } else if (state.checked == false) {
      showToastMessage('Please accept terms and condition');
      return false;
    } else {
      return true;
    }
  }

  bool validateSigninFields() {
    if (loginEmailTextController.text.isEmpty) {
      showToastMessage('Please enter email');
      return false;
    } else if (!Validator.validateEmail(loginEmailTextController.text)) {
      showToastMessage('Please enter valid email');
      return false;
    } else if (loginPasswordTextController.text.isEmpty) {
      showToastMessage('Please enter password');
      return false;
    } else {
      return true;
    }
    /* else if (state.checked == false) {
      showToastMessage('Please accept terms and condition');
      return false;
    }  */
  }

  populateProfileForm() async {
    String? email = await _hiveDatabase.box.get(AppPreferenceKeys.email);
    String? fullName = await _hiveDatabase.box.get(AppPreferenceKeys.fullName);
    if (email != null && email.isNotEmpty) {
      signupEmailTextController.text = email;
    }
    if (fullName != null && fullName.isNotEmpty) {
      signupNameTextController.text = fullName;
    }
  }

  void onChangedMobile(String value) {
    if (state.selectedCountry == null && state.selectedCode == null) {
      showToastMessage('Please select country or country code');
    }
    if (state.selectedCountry == null) {
      signupMobileTextController.clear();
    } else {
      String countryCode = '+${state.selectedCountry?.code ?? ''}';
      if (signupMobileTextController.text.contains(countryCode, 0)) {
        String temp = value.replaceAll(countryCode, '').trim();
        if (temp.isEmpty) {
          signupMobileTextController.clear();
        } else {
          signupMobileTextController.text = '$countryCode $temp';
        }
      } else {
        signupMobileTextController.text = '$countryCode $value';
      }
    }
  }

  void onChangedMobileForgotPassword(String value) {
    if (state.selectedCode == null) {
      showToastMessage('Please select country or country code');
      forgotMobileTextController.clear();
    } else {
      String countryCode = '+${state.selectedCode?.code ?? ''}';
      if (forgotMobileTextController.text.contains(countryCode)) {
        String temp = value.replaceAll(countryCode, '').trim();
        if (temp.isEmpty) {
          forgotMobileTextController.clear();
        } else {
          forgotMobileTextController.text = '$temp';
        }
      } else {
        forgotMobileTextController.text = '$value';
      }
    }
  }

  Future<void> signUp(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      Map<String, dynamic> requestBody = {
        "full_name": signupNameTextController.text,
        "email": signupEmailTextController.text.toLowerCase(),
        "phone": signupMobileTextController.text,
        "password": signupPasswordTextController.text,
        "country_id": state.selectedCountry?.id,
        "city_id": state.selectedCity?.id
      };

      var (response, dioException) = await _networkApiService.postApiRequest(
          url: '/user/signup', body: requestBody);
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        if (jsonData['status'] == 200) {
          AppLog.log(jsonData.toString());
          showToastMessage(jsonData['message']);
          signupNameTextController.clear();
          signupEmailTextController.clear();
          signupMobileTextController.clear();
          signupPasswordTextController.clear();
          state = state.copyWith(
              selectedCity: null, selectedCountry: null, checked: false);
          voidCallback.call();
        } else {
          showToastMessage(jsonData['message']);
        }

        // state = state.copyWith(
        //     userDetails: UserResponse.fromJson(jsonData['data']));
        // if (state.userDetails != null) {
        //   _hiveDatabase.box
        //       .put(AppPreferenceKeys.code, state.userDetails?.code ?? '');
        //   _hiveDatabase.box.put(
        //       AppPreferenceKeys.firstName, state.userDetails?.firstName ?? '');
        //   _hiveDatabase.box.put(
        //       AppPreferenceKeys.lastName, state.userDetails?.lastName ?? '');
        //   _hiveDatabase.box
        //       .put(AppPreferenceKeys.role, state.userDetails?.role ?? '');
        //   _hiveDatabase.box
        //       .put(AppPreferenceKeys.code, state.userDetails?.code ?? '');
        //   _hiveDatabase.box
        //       .put(AppPreferenceKeys.title, state.userDetails?.title ?? '');
        //   _hiveDatabase.box
        //       .put(AppPreferenceKeys.email, state.userDetails?.email ?? '');
        //   _hiveDatabase.box.put(
        //       AppPreferenceKeys.phone, state.userDetails?.phoneNumber ?? '');
        // }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  Future<void> fetchCountry() async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService.postApiRequest(
          url: '/country/list', body: {"search": "", "page": "", "limit": ""});
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        if (response.statusCode == 200) {
          AppLog.log(jsonEncode(jsonData));
          state = state.copyWith(
              countryList: (jsonData['data']['docs'] as List)
                  .map<CountryEntiry>(
                      (e) => CountryEntiry.fromJson(e as Map<String, dynamic>))
                  .toList());
        } else {
          state = state.copyWith(countryList: []);
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  void onSelectCountry(CountryEntiry entity) {
    state = state.copyWith(
        selectedCountry: entity, cityList: [], selectedCity: null);
    signupMobileTextController.clear();
    fetchCity();
  }

  void onSelectCity(CityEntiry entity) {
    state = state.copyWith(selectedCity: entity);
  }

  Future<void> fetchCity() async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService.postApiRequest(
          url: '/city/list',
          body: {
            "search": "",
            "page": "",
            "limit": "",
            "country_id": state.selectedCountry?.id
          });
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        if (response.statusCode == 200) {
          AppLog.log(jsonEncode(jsonData));
          state = state.copyWith(
              cityList: (jsonData['data']['docs'] as List)
                  .map<CityEntiry>(
                      (e) => CityEntiry.fromJson(e as Map<String, dynamic>))
                  .toList());
        } else {
          state = state.copyWith(cityList: []);
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  void acceptTAC() {
    state = state.copyWith(checked: !state.checked);
  }

  Future<void> signIn(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) =
          await _networkApiService.postApiRequest(url: '/user/login', body: {
        "email": loginEmailTextController.text.toLowerCase(),
        "password": loginPasswordTextController.text,
      });
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        if (response.statusCode == 200) {
          AppLog.log(jsonEncode(jsonData));

          if (state.rememberMe) {
            await _hiveDatabase.box.put(AppPreferenceKeys.rememberMePassword,
                loginPasswordTextController.text);
            await _hiveDatabase.box.put(AppPreferenceKeys.rememberMeEmail,
                loginEmailTextController.text);
            print(
                'emaill: ${_hiveDatabase.box.get(AppPreferenceKeys.rememberMeEmail)} and password: ${_hiveDatabase.box.get(AppPreferenceKeys.rememberMePassword)}');
          } else {
            await _hiveDatabase.box
                .delete(AppPreferenceKeys.rememberMePassword);
            await _hiveDatabase.box.delete(AppPreferenceKeys.rememberMeEmail);
          }

          _hiveDatabase.box
              .put(AppPreferenceKeys.token, jsonData['token'] ?? '');
          // print(jsonEncode(jsonData));
          _hiveDatabase.box
              .put(AppPreferenceKeys.id, jsonData['data']['_id'] ?? '');
          _hiveDatabase.box.put(AppPreferenceKeys.firstName,
              jsonData['data']['first_name'] ?? '');
          _hiveDatabase.box.put(
              AppPreferenceKeys.lastName, jsonData['data']['last_name'] ?? '');
          _hiveDatabase.box.put(
              AppPreferenceKeys.fullName, jsonData['data']['full_name'] ?? '');
          _hiveDatabase.box
              .put(AppPreferenceKeys.phone, jsonData['data']['phone'] ?? '');
          _hiveDatabase.box
              .put(AppPreferenceKeys.email, jsonData['data']['email'] ?? '');
          _hiveDatabase.box.put(AppPreferenceKeys.countryId,
              jsonData['data']['country_id'] ?? '');
          _hiveDatabase.box
              .put(AppPreferenceKeys.cityId, jsonData['data']['city_id'] ?? '');
          _hiveDatabase.box.put(AppPreferenceKeys.profileImage,
              jsonData['data']['profile_image'] ?? '');

          loginEmailTextController.clear();
          loginPasswordTextController.clear();
          state = state.copyWith(checked: false);
          voidCallback.call();
        } else if (jsonData['message'] ==
            "Sorry user is deleted by admin. Please contact with admin.") {
          showToastMessage('Account has been deleted by Admin');
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  void onSelectCode(CountryEntiry entity) {
    state =
        state.copyWith(selectedCode: entity, cityList: [], selectedCity: null);
    forgotMobileTextController.clear();
  }

  Future<void> sendOTP(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequest(url: '/user/resetpassword/sendotp', body: {
        "phone":
            '+${state.selectedCode?.code ?? ''} ${forgotMobileTextController.text}',
      });
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log(jsonEncode(jsonData));
        if (response.statusCode == 200) {
          // forgotMobileTextController.clear();
          showToastMessage(jsonData['message']);
          voidCallback.call();
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  Future<void> verifyOTP(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequest(url: '/user/resetpassword/verifyotp', body: {
        "phone":
            '+${state.selectedCode?.code ?? ''} ${forgotMobileTextController.text}',
        "otp": otpTextController.text,
      });
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;

        if (response.statusCode == 200) {
          AppLog.log(jsonEncode(jsonData));
          _hiveDatabase.box
              .put(AppPreferenceKeys.token, jsonData['token'] ?? '');

          forgotMobileTextController.clear();
          otpTextController.clear();
          state = state.copyWith(selectedCode: null, token: jsonData['token']);
          voidCallback.call();
        } else {
          showToastMessage(jsonData['message']);
          otpTextController.text = '';
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  Future<void> resetPassword(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: '/user/resetpassword', body: {
        "password": forgotCPassowrdTextController.text,
      });
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;

        if (response.statusCode == 200) {
          forgotCPassowrdTextController.clear();
          forgotPassowrdTextController.clear();
          showToastMessage('Password Changed Successfully');
          voidCallback.call();
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  Future<void> changePassword(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: '/user/change-password', body: {
        "old_password": changeOPassowrdTextController.text,
        "password": changePassowrdTextController.text,
      });
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;

        if (response.statusCode == 200) {
          changeOPassowrdTextController.clear();
          changePassowrdTextController.clear();
          changeCPassowrdTextController.clear();
          voidCallback.call();
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  Future<void> termsCond(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) = await _networkApiService.getApiRequest(
          url: '/cms/terms_and_condition');
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        if (response.statusCode == 200) {
          AppLog.log(jsonEncode(jsonData));
          _hiveDatabase.box
              .put(AppPreferenceKeys.terms, jsonData['data']['content'] ?? '');
          voidCallback.call();
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }

  void rememberUser() {
    state = state.copyWith(rememberMe: !(state.rememberMe));
    print(state.rememberMe);
  }

  void checksavedUser() {
    String email = _hiveDatabase.box.get(AppPreferenceKeys.rememberMeEmail);
    String pass = _hiveDatabase.box.get(AppPreferenceKeys.rememberMePassword);
    if ((_hiveDatabase.box.get(AppPreferenceKeys.rememberMePassword) != null &&
        _hiveDatabase.box.get(AppPreferenceKeys.rememberMeEmail) != null)) {
      state = state.copyWith(rememberMe: true);
      loginEmailTextController.text = email;
      loginPasswordTextController.text = pass;
    }
    print('pass from hive: $pass');
  }

  // Future<void> logout() async {
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.token);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.email);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.id);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.firstName);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.lastName);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.fullName);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.phone);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.countryId);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.cityId);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.terms);
  //   await _hiveDatabase.box.delete(AppPreferenceKeys.profileImage);
  //   if (!(state.rememberMe)) {
  //     await _hiveDatabase.box.delete(AppPreferenceKeys.rememberMeEmail);
  //     await _hiveDatabase.box.delete(AppPreferenceKeys.rememberMePassword);
  //   }
  // }

  /// Sign in with google
  Future<User?> signInWithGoogle(
      {required BuildContext context,
      required VoidCallback voidCallback}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        //AppLog.log('googleUser---$user');
        if (user != null) {
          Map<String, dynamic> requestBody = {
            "first_name": user.displayName!.split(' ').first,
            "last_name": user.displayName!.split(' ').last,
            "socialId": user.uid,
            "registerType": "Google",
            "email": user.email,
            "deviceType": Platform.operatingSystem,
            // "deviceToken": "string"
          };

          var (response, dioException) = await _networkApiService
              .postApiRequest(url: '/user/social-signup', body: requestBody);
          state = state.copyWith(isLoading: false);

          if (response == null && dioException == null) {
            showconnectionWasInterruptedToastMesage();
          } else if (dioException != null) {
            showDioError(dioException);
          } else {
            Map<String, dynamic> jsonData = response.data;

            //AppLog.log('googleSocialUser---${jsonData.toString()}');

            // showToastMessage(jsonData['message']);
            if (jsonData["status"] == 200) {
              _hiveDatabase.box.put(
                  AppPreferenceKeys.token, jsonData['data']['token'] ?? '');
              _hiveDatabase.box.put(AppPreferenceKeys.id,
                  jsonData['data']['userDetails']['_id'] ?? '');
              _hiveDatabase.box.put(AppPreferenceKeys.firstName,
                  jsonData['data']['userDetails']['first_name'] ?? '');
              _hiveDatabase.box.put(AppPreferenceKeys.lastName,
                  jsonData['data']['userDetails']['last_name'] ?? '');
              _hiveDatabase.box.put(
                  AppPreferenceKeys.fullName,
                  '${jsonData['data']['userDetails']['first_name']} ${jsonData['data']['userDetails']['last_name']}' ??
                      '');
              _hiveDatabase.box.put(AppPreferenceKeys.phone,
                  jsonData['data']['userDetails']['phone'] ?? '');
              _hiveDatabase.box.put(AppPreferenceKeys.email,
                  jsonData['data']['userDetails']['email'] ?? '');
              _hiveDatabase.box.put(AppPreferenceKeys.countryId,
                  jsonData['data']['userDetails']['country_id'] ?? '');
              _hiveDatabase.box.put(AppPreferenceKeys.cityId,
                  jsonData['data']['userDetails']['city_id'] ?? '');
              _hiveDatabase.box.put(AppPreferenceKeys.profileImage,
                  jsonData['data']['userDetails']['profile_image'] ?? '');
              // state = state.copyWith(
              //     selectedCity: null, selectedCountry: null, checked: false);
              voidCallback.call();
            } else {
              showToastMessage(jsonData["message"].toString());
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  Future<void> deleteAccount(VoidCallback voidCallback) async {
    state = state.copyWith(isLoading: true);
    try {
      AppLog.log('${_hiveDatabase.box.get(AppPreferenceKeys.token)}');
      var (response, dioException) = await _networkApiService
          .getApiRequestWithToken(url: AppUrl.deleteAccount);
      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        if (response.statusCode == 200) {
          await _hiveDatabase.box.delete(AppPreferenceKeys.token);
          await _hiveDatabase.box.delete(AppPreferenceKeys.email);
          await _hiveDatabase.box.delete(AppPreferenceKeys.id);
          await _hiveDatabase.box.delete(AppPreferenceKeys.firstName);
          await _hiveDatabase.box.delete(AppPreferenceKeys.lastName);
          await _hiveDatabase.box.delete(AppPreferenceKeys.fullName);
          await _hiveDatabase.box.delete(AppPreferenceKeys.phone);
          await _hiveDatabase.box.delete(AppPreferenceKeys.countryId);
          await _hiveDatabase.box.delete(AppPreferenceKeys.cityId);
          await _hiveDatabase.box.delete(AppPreferenceKeys.terms);
          await _hiveDatabase.box.delete(AppPreferenceKeys.verifiedToken);
          await _hiveDatabase.box.delete(AppPreferenceKeys.profileImage);
          await _hiveDatabase.box.delete(AppPreferenceKeys.rememberMeEmail);
          await _hiveDatabase.box.delete(AppPreferenceKeys.rememberMePassword);
          voidCallback.call();
          showToastMessage(jsonData['message']);
        } else {
          showToastMessage(jsonData['message']);
        }
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      showconnectionWasInterruptedToastMesage();
    }
  }
}
