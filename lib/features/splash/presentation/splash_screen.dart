import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/assets.dart';
import '../../../core/infrastructure/hive_database.dart';
import '../../../core/shared/providers.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../routes/app_router.gr.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), navigate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      child: Material(
        color: AppColors.colorPrimaryAlpha,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Stack(
            children: [
              Column(
                children: [
                  (28 + 18).verticalSpace,
                  SizedBox(
                    height: 217,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Opacity(
                          opacity: 0.1,
                          child: Container(
                              height: 126,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xff63a520),
                                      Color(0xff6db525)
                                    ],
                                  ))),
                        ),
                        Positioned(
                          top: 63,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                Assets.logo,
                                width: 122,
                                height: 122,
                              ),
                              14.verticalSpace,
                              Text(
                                "What’s IN IT",
                                style:
                                    AppTextStyles.textStyleCoutureBold.copyWith(
                                  color: AppColors.colorBottom,
                                  fontSize: 14.39.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  22.verticalSpace,
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      Assets.splashC,
                      width: MediaQuery.of(context).size.width,
                    ),
                  )),
                  (87 + 21).verticalSpace
                ],
              ),
              Positioned(
                bottom: 21,
                left: 0,
                right: 0,
                child: Container(
                  height: 87,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: AssetImage(Assets.splashImage2)),
                      color: const Color(0xff232222)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigate() async {
    final hive = ref.read(hiveProvider);

    final token = await hive.box.get(AppPreferenceKeys.token);
    final id = await hive.box.get(AppPreferenceKeys.id);

    if (token != null && token.toString().isNotEmpty && id != null) {
      AutoRouter.of(context)
          .pushAndPopUntil(const BaseRoute(), predicate: (_) => false);
    } else {
      AutoRouter.of(context)
          .pushAndPopUntil(const LandingRoute(), predicate: (_) => false);
    }
  }
}
