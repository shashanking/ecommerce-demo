import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:whatsinit/core/utils/common_util.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widget/app_bar_widget.dart';
import '../../../../core/widget/cached_img.dart';
import '../../../../routes/app_router.gr.dart';
import '../../application/shop_notifier.dart';
import '../../domain/product/products.dart';
import '../../shared/provider.dart';

class SpecialProductListItem extends ConsumerWidget {
  const SpecialProductListItem({
    super.key,
    required this.title,
    required this.img,
    required this.actualPrice,
    required this.sellingPrice,
  });
  final String title;
  final String img;
  final String actualPrice;
  final String sellingPrice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopState = ref.watch(shopNotifierProvider);
    final shopNotifier = ref.watch(shopNotifierProvider.notifier);

    return Center(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.colorBottom,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Image.asset(image),
                GestureDetector(
                  onTap: () {
                    // shopNotifier.getDetails(productId: productId);
                    // context.pushRoute(ProductDetailsRoute(
                    //     productDetails: shopState.productDetails));
                  },
                  // width: 230,
                  // height: 174,
                  child: Container(
                    width: 110,
                    height: 110,
                    child: Stack(
                      children: [
                        CachedImg(
                          img: img,
                          width: 110,
                          height: 110,
                        ),
                        //Image.asset(Assets.product),
                        // Positioned(
                        //   bottom: 5,
                        //   left: 5,
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 8, vertical: 4),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(5),
                        //         gradient: const LinearGradient(
                        //           begin: Alignment.centerLeft,
                        //           end: Alignment.centerRight,
                        //           colors: [
                        //             Color(0xff63a520),
                        //             Color(0xff6db525)
                        //           ],
                        //         )),
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           'Ingredients Alert',
                        //           style: AppTextStyles.textStyleOpenSansSemiBold
                        //               .copyWith(
                        //             color: AppColors.colorText1,
                        //             fontSize: 8.sp,
                        //           ),
                        //         ),
                        //         Text(
                        //           ' 0',
                        //           style: AppTextStyles.textStyleOpenSansBold
                        //               .copyWith(
                        //             color: AppColors.colorWhite,
                        //             fontSize: 8.sp,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),

                15.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // 'Orange Juice',
                        title,
                        style: AppTextStyles.textStyleOpenSansRegular.copyWith(
                            color: AppColors.colorWhite1,
                            fontSize: 16.sp,
                            letterSpacing: -1.3),
                      ),
                      //6.verticalSpace,
                      // Offstage(
                      //   offstage: floatRating <= 0.0,
                      //   child: RateWidget(rating: rating),
                      // ),
                      12.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            actualPrice, // '\$35.99',
                            style:
                                AppTextStyles.textStyleOpenSansRegular.copyWith(
                              color: AppColors.colorWhite,
                              fontSize: 13.sp,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors
                                  .white, // This sets the line color to red
                              decorationThickness: 4,
                            ),
                          ),
                          8.horizontalSpace,
                          Text(
                            sellingPrice, // '\$35.99',
                            style: AppTextStyles.textStyleOpenSansSemiBold
                                .copyWith(
                              color: AppColors.colorTextGreen,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          15.verticalSpace,
        ],
      ),
    );
  }
}
