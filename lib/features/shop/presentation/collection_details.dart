import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:whatsinit/core/utils/common_util.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widget/app_bar_widget.dart';
import '../../../core/widget/cached_img.dart';
import '../../../routes/app_router.gr.dart';
import '../application/shop_notifier.dart';
import '../domain/product/products.dart';
import '../shared/provider.dart';

@RoutePage()
class CollectionDetails extends ConsumerStatefulWidget {
  const CollectionDetails({
    super.key,
    required this.title,
    required this.collectionId,
  });
  final String title;
  final String collectionId;

  @override
  ConsumerState<CollectionDetails> createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends ConsumerState<CollectionDetails> {
  PagingController<String, Product> pagingController =
      PagingController(firstPageKey: '');

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      Future.delayed(const Duration(seconds: 0), () {
        _fetchPage(pageKey);
      });
    });

    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   final shopNotifier = ref.read(shopNotifierProvider.notifier);

    //   shopNotifier.products(
    //     tag: CollectionTag.general,
    //     collectionId: widget.collectionId,
    //   );
    // });
  }

  Future<void> _fetchPage(String pageKey) async {
    print("calling Fetch Page: $pageKey");
    final shopState = ref.watch(shopNotifierProvider);
    final shopNotifier = ref.watch(shopNotifierProvider.notifier);
    final nextPage = shopState.products.nextPageCursor;

    await shopNotifier.products(
        collectionId: widget.collectionId,
        tag: CollectionTag.general,
        pageKey: nextPage ?? '',
        onError: (error) {
          pagingController.error = error;
        },
        pagination: (String page, List<Product> newItem) {
          final isLastPage = (page ?? '').isEmpty;
          print("isLastPage: $isLastPage");
          if (isLastPage) {
            pagingController.appendLastPage(newItem);
          } else {
            pagingController.appendPage(newItem, page);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopNotifierProvider);
    final shopNotifier = ref.watch(shopNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.colorBlack1,
      // backgroundColor: Colors.red,

      appBar: AppBarWidget(
        title: widget.title,
      ),
      body: PagedListView<String, Product>(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          noItemsFoundIndicatorBuilder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Item Found",
                style: AppTextStyles.textStyleOpenSansRegular
                    .copyWith(color: AppColors.colorGrey, fontSize: 20.sp),
              ),
            ],
          ),
          newPageProgressIndicatorBuilder: (context) => loaderPrimaryColor(),
          firstPageProgressIndicatorBuilder: (context) => loaderPrimaryColor(),
          itemBuilder: (context, item, index) {
            final node = item.node;
            final title = node.title ?? '';
            final img = node.images.nodes.isNotEmpty
                ? node.images.nodes.first.url ?? ''
                : '';
            final actualPrice = node.variants.edges.isNotEmpty
                ? node.variants.edges[0].node.compareAtPrice ?? ''
                : '';
            final sellingPrice = node.variants.edges.isNotEmpty
                ? node.variants.edges[0].node.price ?? ''
                : '';
            final productId = node.legacyResourceId.toString() ?? '';
            final status = (node.status ?? '').toLowerCase() == 'active';

            print("index: $index");
            print("title: $title");
            print("img: $img");
            print("actualPrice: $actualPrice");
            print("sellingPrice: $sellingPrice");
            if (index == 0) {
              print('Product IDDDDDDDDDDDDx8: $productId');
            }
            return GestureDetector(
              onTap: () {
                shopNotifier.getDetails(productId: productId);

                context.pushRoute(
                  ProductDetailsRoute(
                    price: sellingPrice,
                    productDetails: shopState.productDetails,
                    productId: productId,
                  ),
                );
              },
              child: Center(
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
                          CachedImg(
                            img: shopState.isLoading ? '' : img,
                            width: 110,
                            height: 109,
                          ),
                          15.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // 'Lauren’s',
                                  node?.vendor ?? '',
                                  style: AppTextStyles.textStyleOpenSansRegular
                                      .copyWith(
                                          color: AppColors.colorGrey,
                                          fontSize: 12.sp,
                                          letterSpacing: -1),
                                ),
                                4.verticalSpace,
                                Text(
                                  // 'Orange Juice',
                                  // node.legacyResourceId.toString(),
                                  title,
                                  style: AppTextStyles.textStyleOpenSansRegular
                                      .copyWith(
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
                                      style: AppTextStyles
                                          .textStyleOpenSansRegular
                                          .copyWith(
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
                                      style: AppTextStyles
                                          .textStyleOpenSansSemiBold
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
              ),
            );
          },
        ),
      ),
    );
  }
}
