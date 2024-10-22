import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsinit/core/utils/check_list.dart';
import 'package:whatsinit/core/utils/toast.dart';
import 'package:whatsinit/features/cart/domain/address_list.dart';
import 'package:whatsinit/features/cart/domain/cart_items.dart';
import 'package:whatsinit/features/cart/shared/provider.dart';
import 'package:whatsinit/features/checkout/application/checkout_state.dart';
import 'package:whatsinit/features/checkout/domain/card_model.dart';
import 'package:whatsinit/features/checkout/shared/provider.dart';
import 'package:whatsinit/features/profile/shared/provider.dart';

import '../../../core/infrastructure/api_url.dart';
import '../../../core/infrastructure/hive_database.dart';
import '../../../core/infrastructure/network_api_services.dart';
import '../../../core/utils/app_log.dart';
import '../../../core/utils/extract_id_part.dart';
import '../domain/product_details.dart';

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier(this._networkApiService, this._hiveDatabase)
      : super(CheckoutState()) {}

  final NetworkApiService _networkApiService;
  final HiveDatabase _hiveDatabase;

  final cardNumberTextController = TextEditingController();
  final cardHolderNameTextController = TextEditingController();
  final expMonthTextController = TextEditingController();
  final expYearTextController = TextEditingController();
  final cvcTextController = TextEditingController();

  clearFields() {
    cardNumberTextController.clear();
    cardHolderNameTextController.clear();
    expMonthTextController.clear();
    expYearTextController.clear();
    cvcTextController.clear();
  }

  setSelectedCard(CardModel card) {
    state = state.copyWith(selectedCard: card);
  }

  // setSelectedAddress(AddressList address) {
  //   state = state.copyWith(selectedCard: address);
  // }

  Future<void> removeCard(String cardId) async {
    state = state.copyWith(isLoading: true);
    final body = {"card_id": cardId};
    try {
      var (response, dioException) = await _networkApiService
          .postApiRequestWithToken(url: AppUrl.removeCard, body: body);

      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        AppLog.log('removeCard----${jsonData.toString()}');
        if (jsonData['status'] == 200) {
          //success

          state = state.copyWith(cardList: []);
          showToastMessage('${jsonData['message']}');
          await getCardList();

          // if (voidCallback != null) {
          //   voidCallback.call();
          // }
        } else {
          showToastMessage('${jsonData['status']}: ${jsonData['message']}');
        }
      }
    } catch (error, stacktrace) {
      state = state.copyWith(isLoading: false);
      AppLog.log('removeCard Total Error: $error');
      showconnectionWasInterruptedToastMesage();
      print("Error: $error, Stacktrace: $stacktrace");
    }
  }

  Future<void> getCardList() async {
    state = state.copyWith(isLoading: true);
    try {
      var (response, dioException) =
          await _networkApiService.getApiRequestWithToken(url: AppUrl.listCard);

      state = state.copyWith(isLoading: false);

      if (response == null && dioException == null) {
        showconnectionWasInterruptedToastMesage();
      } else if (dioException != null) {
        showDioError(dioException);
      } else {
        Map<String, dynamic> jsonData = response.data;
        final List<CardModel> cards = [];
        AppLog.log('getCard----${jsonData.toString()}');
        if (jsonData['status'] == 200 && jsonData['data'] != null) {
          //success

          for (Map<String, dynamic> item in jsonData['data']) {
            final CardModel card = CardModel.fromJson(item);
            cards.add(card);
          }

          if (state.cardList.isEmpty) {
            state = state.copyWith(cardList: cards);
            // showToastMessage(jsonData['message']);
          }
          // else if (isCardInList(card, state.cardList)) {
          //   // card already inside cardList
          //   showToastMessage('Card already in list');
          // }
          else {
            // populate card list with
            state = state.copyWith(cardList: [...state.cardList, ...cards]);
            // showToastMessage(jsonData['message']);
          }

          state = state.copyWith(selectedCard: state.cardList.first);

          // if (voidCallback != null) {
          //   voidCallback.call();
          // }
        } else {
          // showToastMessage('${jsonData['status']}: ${jsonData['message']}');
        }
      }
    } catch (error, stacktrace) {
      state = state.copyWith(isLoading: false);
      AppLog.log('cardList Total Error: $error');
      showconnectionWasInterruptedToastMesage();
      print("Error: $error, Stacktrace: $stacktrace");
    }
  }

  Future<void> createCard({VoidCallback? voidCallback}) async {
    if (cardHolderNameTextController.text.isEmpty ||
        cardNumberTextController.text.isEmpty ||
        expMonthTextController.text.isEmpty ||
        expYearTextController.text.isEmpty ||
        cvcTextController.text.isEmpty) {
      showToastMessage('Please Complete The Form');
    } else if (expMonthTextController.text.length != 2) {
      showToastMessage('Enter 2 digit Month Correctly');
    } else if (expYearTextController.text.length != 4) {
      showToastMessage('Enter 4 digit Year Correctly');
    } else if (cvcTextController.text.length < 3) {
      showToastMessage('Enter your CVC pin Correctly');
    } else {
      state = state.copyWith(isLoading: true);
      final body = {
        "card_number": cardNumberTextController.text.replaceAll(' ', '').trim(),
        "exp_month": expMonthTextController.text.trim(),
        "exp_year": expYearTextController.text.trim(),
        "cvc": cvcTextController.text.trim(),
        "card_holder_name": cardHolderNameTextController.text.trim()
      };
      try {
        var (response, dioException) = await _networkApiService
            .postApiRequestWithToken(url: AppUrl.createCard, body: body);

        state = state.copyWith(isLoading: false);

        if (response == null && dioException == null) {
          showconnectionWasInterruptedToastMesage();
        } else if (dioException != null) {
          showDioError(dioException);
        } else {
          Map<String, dynamic> jsonData = response.data;
          AppLog.log('cardCreate----${jsonData.toString()}');
          if (jsonData['status'] == 200 && jsonData['data'] != null) {
            //success

            final CardModel card = CardModel.fromJson(jsonData['data']);

            if (state.cardList.isEmpty) {
              state = state.copyWith(cardList: [card], selectedCard: card);
              showToastMessage(jsonData['message']);
            }
            // else if (isCardInList(card, state.cardList)) {
            //   // card already inside cardList
            //   showToastMessage('Card already in list');
            // }
            else {
              // populate card list with
              state = state.copyWith(cardList: [...state.cardList, card]);
              showToastMessage(jsonData['message']);
            }

            clearFields();

            if (voidCallback != null) {
              voidCallback.call();
            }
          } else {
            showToastMessage('${jsonData['message']}');
          }
        }
      } catch (error, stacktrace) {
        state = state.copyWith(isLoading: false);
        AppLog.log('createCard Total Error: $error');
        showconnectionWasInterruptedToastMesage();
        print("Error: $error, Stacktrace: $stacktrace");
      }
    }
  }

  createOrder(WidgetRef ref, VoidCallback? voidCallback) async {
    final cartState = ref.watch(cartProvider);
    // var profileState = ref.watch(profileNotifierProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    // final profileNotifier = ref.watch(profileNotifierProvider.notifier);

    state = state.copyWith(isLoading: true);
    List<ProductDetails> products = [];

    if (cartState.cartItems != null) {
      for (CartData item in cartState.cartItems!.data as Iterable) {
        final productDetails = ProductDetails(
            produt_id: item.productId!,
            quantity: item.quantity.toString(),
            price: item.productPrice!,
            title: item.productData?.title ?? '',
            vendor: item.productData?.vendor ?? '',
            image_url: item.productData?.images?.nodes?.first.originalSrc ?? '',
            inventory_item_id: extractIdPart(item.productData?.variants?.nodes
                    ?.first.inventoryItem?.inventoryLevels?.nodes?.first.id ??
                ''),
            location_id: extractLocationIdPart(item
                    .productData
                    ?.variants
                    ?.nodes
                    ?.first
                    .inventoryItem
                    ?.inventoryLevels
                    ?.nodes
                    ?.first
                    .location
                    ?.id ??
                ''));

        products.add(productDetails);
      }

      final body = {
        "paymentMethod_id": checkoutState.selectedCard!.paymentMethodId,
        "amount": cartState.totalPrice,
        "product_details": products,
        "shipping_address_id": cartState.defaultAddressEntity?.addressId ??
            cartState.addressList
                .firstWhere((element) => element.isDefault == true)
                .addressId
      };

      try {
        var (response, dioException) = await _networkApiService
            .postApiRequestWithToken(url: AppUrl.createOrder, body: body);

        state = state.copyWith(isLoading: false);

        if (response == null && dioException == null) {
          showconnectionWasInterruptedToastMesage();
        } else if (dioException != null) {
          showDioError(dioException);
        } else {
          Map<String, dynamic> jsonData = response.data;
          AppLog.log('orderCreate----${jsonData.toString()}');
          if (jsonData['status'] == 200) {
            //success
            showToastMessage(jsonData['message']);

            await cartNotifier.listItems();

            if (voidCallback != null) {
              voidCallback.call();
            }
          } else {
            showToastMessage('${jsonData['status']}: ${jsonData['message']}');
          }
        }
      } catch (error, stacktrace) {
        state = state.copyWith(isLoading: false);
        AppLog.log('Checkout-createOrder Total Error: $error');
        showconnectionWasInterruptedToastMesage();
        print("Error: $error, Stacktrace: $stacktrace");
      }
    } else {
      showToastMessage('cartItems not found');
    }
  }
}

/*
      "produt_id": "string",
      "qty": "string",
      "price": "string",
      "title": "string",
      "vendor": "string",
      "image_url": "string",
      "location_id": "string",
      "inventory_item_id": "string"
 */
