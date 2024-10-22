import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widget/app_button.dart';
import '../../../routes/app_router.gr.dart';
import '../shared/providers.dart';
import 'widget/auth_background_cover.dart';

@RoutePage()
class VerifyOTPPage extends ConsumerStatefulWidget {
  const VerifyOTPPage({super.key});

  @override
  ConsumerState<VerifyOTPPage> createState() => VerifyOTPPageState();
}

class VerifyOTPPageState extends ConsumerState<VerifyOTPPage> {
  bool _timerRunning = true;
  int _counter = 30;
  Timer ? _timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final stateNotifier = ref.watch(authNotifierProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthBackgroundCover(
        titleText: 'Verify OTP',
        subTitleText: 'Enter OTP received in your phone number',
        children: [
          Pinput(
            length: 4,
            controller: stateNotifier.otpTextController,
            keyboardType: TextInputType.number,
            crossAxisAlignment: CrossAxisAlignment.center,
            defaultPinTheme: PinTheme(
              width: 74.w,
              height: 60.h,
              textStyle: AppTextStyles.textStyleOpenSansRegular
                  .copyWith(fontSize: 13.sp, color: AppColors.colorWhite1),
              decoration: BoxDecoration(
                color: AppColors.colorTextFieldBg,
                border: Border.all(color: AppColors.colorTransparent),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            androidSmsAutofillMethod:
                AndroidSmsAutofillMethod.smsUserConsentApi,
          ),
          30.verticalSpace,
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () {
                     if(_timerRunning == false ){
                       stateNotifier.sendOTP(() {
                         stateNotifier.otpTextController.clear();
                       });
                       startTimer();
                     }
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Resend OTP',
                        style: AppTextStyles.textStyleOpenSansRegular.copyWith(
                          color: AppColors.colorGrey,
                          fontSize: 13.sp,
                        ),
                      ),
                    )),
              ),
              const SizedBox(width: 10),
              Text(
                _counter > 0 ? 'in $_counter sec' : '',
                style: AppTextStyles.textStyleOpenSansRegular.copyWith(
                  color: AppColors.colorTextGreen,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          30.verticalSpace,
          AppButton(
            text: 'Verify',
            onPressed: () {
              if(_counter == 0 || stateNotifier.otpTextController.text.length==4 ) {
                stateNotifier.verifyOTP(
                        () => context.replaceRoute(const ResetPasswordRoute()));
              }
            },
          ),
          200.verticalSpace,
        ],
      ),
    );
  }
  void startTimer() {
    _counter = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerRunning = true;
      setState(() {
        if (_counter > 0) {
            _counter--;
        }
        else {
        _timer!.cancel();
        _timerRunning = false;
        }
      });
    });
  }
}
