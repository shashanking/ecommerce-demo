import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsinit/core/infrastructure/api_url.dart';
import 'package:whatsinit/core/utils/common_util.dart';
import 'package:whatsinit/core/widget/cached_img.dart';
import 'package:whatsinit/core/widget/pop_up.dart';
import 'package:whatsinit/routes/app_router.gr.dart';

import '../../../core/constants/assets.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widget/app_bar_widget.dart';
import '../../../core/widget/app_button.dart';
import '../../../core/widget/app_dropdown_button.dart';
import '../../../core/widget/bottom_sheet_dropdown.dart';
import '../../../core/widget/drop_down_tile.dart';
import '../../../core/widget/secondary_text_input_field.dart';
import '../shared/provider.dart';

@RoutePage()
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends ConsumerState<EditProfilePage> {
  File? img;
  TextEditingController fullName = TextEditingController();

  Future<void> selectPhoto() async {
    final status = await Permission.photos.status;
    if (status.isPermanentlyDenied || status.isRestricted || status.isDenied) {
      await _requestPermissionAndPickImage();
    } else {
      await _pickImage();
    }
  }

  Future<void> _requestPermissionAndPickImage() async {
    if (Platform.isAndroid) {
      final storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) {
        await _pickImage();
      } else if (storageStatus.isPermanentlyDenied || storageStatus.isDenied) {
        if (await Permission.storage.request().isGranted) {
          await _pickImage();
        } else {
          _showPermissionDeniedDialog();
        }
      }
    } else if (Platform.isIOS) {
      final photoStatus = await Permission.photos.request();
      if (photoStatus.isGranted) {
        await _pickImage();
      } else if (photoStatus.isPermanentlyDenied || photoStatus.isDenied) {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Denied'),
        content: Text(
            'Please enable the required permission from the app settings.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print(
          'File(pickedFile.path).path.toString(): ${File(pickedFile.path).path.toString()}');
      setState(() {
        img = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      final profileState = ref.watch(profileNotifierProvider);
      final profileData = profileState.userProfile.data;
      fullName.text = profileData?.fullName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileNotifier = ref.watch(profileNotifierProvider.notifier);
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.colorBlack1,
      appBar: const AppBarWidget(
        title: 'Edit Profile',
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: profileState.isLoading
            ? Center(
                child: SizedBox(
                  height: 350.h,
                  child: loaderPrimaryColor(),
                ),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  8.verticalSpace,

                  Container(
                    height: 120,
                    width: 120,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF3C7008), Color(0xFF1F3806)])),
                    child: GestureDetector(
                      onTap: selectPhoto,
                      child: Container(
                        margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(6.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.colorBlack1),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: img != null
                              ? Image.file(img!)
                              : CachedImg(
                                  img: AppUrl.profileImgBaseUrl +
                                      (profileState
                                              .userProfile.data?.profileImage ??
                                          ''),
                                  fit: BoxFit.scaleDown,
                                ),
                          // Image.asset(
                          //     Assets.person,
                          //   ),
                        ),
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  SecondaryTextInputField(
                    controller: fullName,
                    hintText: 'Full Name',
                    keyboardType: TextInputType.text,
                  ),
                  // 15.verticalSpace,
                  // SecondaryTextInputField(
                  //   controller: TextEditingController(text: email),
                  //   hintText: 'Email ID',
                  //   keyboardType: TextInputType.text,
                  // ),
                  // 15.verticalSpace,
                  // SecondaryTextInputField(
                  //   controller: TextEditingController(text: mobileNumber),
                  //   hintText: 'Mobile Number',
                  //   keyboardType: TextInputType.number,
                  // ),
                  // 15.verticalSpace,
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: AppDropdownButton(
                  //         selectedValue: '',
                  //         hintText: 'Country',
                  //         onTap: () {
                  //           FocusScope.of(context).unfocus();
                  //           List<String> dropdownList = [
                  //             'Test',
                  //           ];
                  //           bottomSheetDropdown(
                  //               context,
                  //               'Country',
                  //               Column(
                  //                 children: List.generate(
                  //                     dropdownList.length,
                  //                     (index) => DropDownTile(
                  //                         onTap: () {
                  //                           // stateNotifier
                  //                           //     .onSelectPacking(dropdownList[index]);
                  //                           Navigator.pop(context);
                  //                         },
                  //                         text: dropdownList[index])).toList(),
                  //               ));
                  //         },
                  //       ),
                  //     ),
                  //     15.horizontalSpace,
                  //     Expanded(
                  //       child: AppDropdownButton(
                  //         selectedValue: '',
                  //         hintText: 'City',
                  //         onTap: () {
                  //           FocusScope.of(context).unfocus();
                  //           List<String> dropdownList = [
                  //             'Test',
                  //           ];
                  //           bottomSheetDropdown(
                  //               context,
                  //               'City',
                  //               Column(
                  //                 children: List.generate(
                  //                     dropdownList.length,
                  //                     (index) => DropDownTile(
                  //                         onTap: () {
                  //                           // stateNotifier
                  //                           //     .onSelectPacking(dropdownList[index]);
                  //                           Navigator.pop(context);
                  //                         },
                  //                         text: dropdownList[index])).toList(),
                  //               ));
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // 15.verticalSpace,
                  // SecondaryTextInputField(
                  //   controller: TextEditingController(),
                  //   hintText: 'Desired Password',
                  //   keyboardType: TextInputType.visiblePassword,
                  //   suffixWidget: InkWell(
                  //     onTap: () => context.pushRoute(const ChangePasswordRoute()),
                  //     child: Text(
                  //       'Change',
                  //       style: AppTextStyles.textStyleOpenSansBold.copyWith(
                  //         color: AppColors.colorTextGreen,
                  //         decoration: TextDecoration.underline,
                  //         fontSize: 13.sp,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  30.verticalSpace,
                  AppButton(
                    text: 'Save',
                    onPressed: () {
                      profileNotifier.update(
                          fullName.text, img?.path.toString() ?? '', () {
                        context.popRoute();
                      });
                    },
                  ),
                  100.verticalSpace,
                ],
              ),
      ),
    );
  }
}
