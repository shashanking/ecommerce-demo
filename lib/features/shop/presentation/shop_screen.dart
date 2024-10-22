import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import 'package:whatsinit/core/utils/common_util.dart';
import 'package:whatsinit/core/widget/cached_img.dart';
import 'package:whatsinit/features/scan/presentation/widget/product_card.dart';
import 'package:whatsinit/features/shop/presentation/search_products.dart';
import 'package:whatsinit/features/shop/presentation/special_products.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../routes/app_router.gr.dart';
import '../../scan/presentation/widget/divider_cover_card.dart';
import '../application/shop_notifier.dart';
import '../application/shop_state.dart';
import '../domain/product/products.dart';
import '../shared/provider.dart';
import 'widget/modified_product_card.dart';
import 'widget/scan_appbar.dart';

import 'package:html/parser.dart' show parse;

@RoutePage()
class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => SShopPageState();
}

class SShopPageState extends ConsumerState<ShopPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
        Permission.photos,
        Permission.storage,
        // Add more permissions as needed
      ].request();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final shopState = ref.watch(shopNotifierProvider);
    final shopNotifier = ref.watch(shopNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.colorBlack1,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              40.verticalSpace,
              ScanAppBar(notifier: shopNotifier),
              (shopState.searchActive == true)
                  ? buildSearchResultScreen(shopState, shopNotifier)
                  : buildShopScreen(shopState, shopNotifier),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildShopScreen(ShopState shopState, ShopNotifier shopNotifier) {
    final productDetailImg =
        shopState.productDetails.data.images?.nodes.isNotEmpty ?? false
            ? shopState.productDetails.data.images?.nodes.first.originalSrc ??
                ''
            : '';
    final description = shopState.productDetails.data.descriptionHtml ?? '';
    final topSellerProductsTitleLists =
        shopState.topSellerProducts.data.map((product) => product.node.title);
    final exclusiveOfferProductsTitleLists = shopState
        .exclusiveOfferProducts.data
        .map((product) => product.node.title);

    return Column(
      children: [
        shopState.collectionResponse.isEmpty
            ? const SizedBox.shrink()
            : 30.verticalSpace,
        Offstage(
          offstage: shopState.collectionResponse.isEmpty,
          child: SizedBox(
            height: 130,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final collection = shopState.collectionResponse[index];
                  return InkWell(
                    onTap: () {
                      // shopifyNotifier.products(
                      //     collectionId: collection.id.toString() ?? '',
                      //     tag: CollectionTag.general);

                      context.pushRoute(
                        CollectionDetails(
                          title: collection.title ?? '',
                          collectionId: collection.id.toString(),
                        ),
                      );
                    },
                    child: ModifiedProductCard(
                      title: collection.title ?? '',
                      img: collection.image?.src ?? '',
                    ),
                  );
                },
                separatorBuilder: (context, index) => 15.horizontalSpace,
                itemCount: shopState.collectionResponse.length),
            // child: ListView.separated(
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) =>
            //         ModifiedProductCard(title: productNames[index]),
            //     separatorBuilder: (context, index) => 15.horizontalSpace,
            //     itemCount: productNames.length),
          ),
        ),
        shopState.sliderList.isEmpty
            ? const SizedBox.shrink()
            : 12.verticalSpace,
        shopState.sliderList.isEmpty
            ? const SizedBox.shrink()
            : SizedBox(
                height: 245,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ModifiedProductCard(
                          title: shopState.sliderList[index].title ?? 'NA',
                          subTitle: shopState.sliderList[index].content ?? 'NA',
                          img: shopState.sliderList[index].image ?? '',
                          expand: true,
                        ),
                    separatorBuilder: (context, index) => 15.horizontalSpace,
                    itemCount: shopState.sliderList.length),
              ),
        30.verticalSpace,
        Offstage(
          offstage: (shopState.topSellerProducts.data.length ?? 0) == 0,
          child: DividerCoverCard(
            title: 'Top Seller',
            subTitle: 'List of recent top-seller products.',
            explore: true,
            exploreOnTap: () {
              context.pushRoute(SpecialProductListRoute(
                  collectionId: '86369697849', tag: CollectionTag.topSeller));
            },
            child: const SizedBox(
              height: 250,
              child: SpecialProducts(
                  tag: CollectionTag.topSeller, collectionId: '86369697849'),
            ),
          ),
        ),
        30.verticalSpace,
        Offstage(
          offstage: (shopState.topSellerProducts.data.length ?? 0) == 0,
          child: DividerCoverCard(
            title: 'Exclusive Offer',
            subTitle: 'List of recent exclusive products.',
            explore: true,
            exploreOnTap: () {
              context.pushRoute(SpecialProductListRoute(
                  collectionId: '34846539833',
                  tag: CollectionTag.exclusiveOffer));
            },
            child: const SpecialProducts(
                tag: CollectionTag.exclusiveOffer, collectionId: '34846539833'),
          ),
        ),
        30.verticalSpace,
        Offstage(
          offstage: shopState.productDetails.data.status?.isEmpty ?? true,
          child: DividerCoverCard(
            title: shopState.productDetails.data.title ?? '', // 'TONGKAT ALI',
            subTitle: '', //'' ,
            explore: false,
            child: Column(
              children: [
                // SizedBox(
                //   width: 343,
                //   height: 250,
                //   child: Image.asset(Assets.productExpand2),
                // ),
                CachedImg(
                  img: productDetailImg,
                  width: 343,
                  height: 250,
                ),
                15.verticalSpace,
                Text(
                  (() {
                    var document = parse(description);
                    String parsedString =
                        parse(document.body?.text).documentElement?.text ??
                            'NA';
                    return parsedString;
                  }()),
                  //'Tongkat Ali 200:1 Extract: Have the best sex of your life at any age. Very Potent, 100% Fresh, 100% Pure, 100% Pharmaceutical Grade, 100% Satisfaction Guarantee',
                  // textAlign: TextAlign.justify,
                  style: AppTextStyles.textStyleOpenSansRegular.copyWith(
                    color: AppColors.colorWhite,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        120.verticalSpace,
      ],
    );
  }

  Widget buildSearchResultScreen(
    ShopState shopState,
    ShopNotifier shopNotifier,
  ) {
    return Container(
      // color: Colors.amber,
      height: MediaQuery.of(context).size.height * 0.8,
      child: shopState.isLoading
          ? loaderPrimaryColor()
          : shopState.searchResponse.isEmpty
              ? const Center(
                  child: Text(
                    'No Data Found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 80),
                    child: ListView.separated(
                      // shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: shopState.searchResponse.length,
                      itemBuilder: (context, index) {
                        var item = shopState.searchResponse[index];

                        final title = item.title ?? '';
                        final img = item.images.nodes.isNotEmpty
                            ? item.images.nodes.first.originalSrc ?? ''
                            : '';
                        final sellingPrice = item.variants.nodes.isNotEmpty
                            ? item.variants.nodes[0].price ?? ''
                            : '';
                        final productId =
                            item.legacyResourceId.toString() ?? '';
                        final status =
                            (item.status ?? '').toLowerCase() == 'active';
                        final vendor = item?.vendor ?? '';

                        return GestureDetector(
                          onTap: () {
                            shopNotifier.resetSearch();

                            shopNotifier.getDetails(productId: productId);

                            context.pushRoute(
                              ProductDetailsRoute(
                                price: sellingPrice,
                                productDetails: shopState.productDetails,
                                productId: productId,
                              ),
                            );
                          },
                          child: SearchProductList(
                            sellingPrice: sellingPrice,
                            title: title,
                            img: img,
                            vendor: vendor,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          15.verticalSpace,
                    ),
                  ),
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
