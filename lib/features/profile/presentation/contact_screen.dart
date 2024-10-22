import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsinit/core/utils/common_util.dart';
import 'package:whatsinit/core/utils/toast.dart';
import 'package:whatsinit/features/profile/shared/provider.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/widget/app_bar_widget.dart';
import '../../../core/widget/app_button.dart';
import '../../../core/widget/secondary_text_input_field.dart';

@RoutePage()
class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => ContactPageState();
}

class ContactPageState extends ConsumerState<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final profileNotifier = ref.watch(profileNotifierProvider.notifier);
    final state = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.colorBlack1,
      appBar: const AppBarWidget(
        title: 'Contact us',
      ),
      body: state.isLoading
          ? loaderPrimaryColor()
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                8.verticalSpace,
                SecondaryTextInputField(
                  controller: profileNotifier.contactEmailController,
                  hintText: 'Email ID',
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    if (value.trim() != "") {
                      profileNotifier.setContactData(email: value);
                    }
                  },
                ),
                15.verticalSpace,
                SecondaryTextInputField(
                  controller: profileNotifier.contactPhoneController,
                  hintText: 'Mobile Number',
                  // maxLength: 15,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.trim() != "") {
                      profileNotifier.setContactData(mobileNumber: value);
                    }
                  },
                ),
                15.verticalSpace,
                SecondaryTextInputField(
                  controller: profileNotifier.contactDescriptionController,
                  hintText: 'Enter Description',
                  keyboardType: TextInputType.text,
                  isMultiline: true,
                  onChanged: (value) {
                    if (value.trim() != "") {
                      profileNotifier.setContactData(description: value);
                    }
                  },
                ),
                30.verticalSpace,
                AppButton(
                  text: 'Submit',
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    profileNotifier.createContact(
                      onSuccess: () {
                        showToastMessage(
                            'Your Query has submitted successfully.');
                        context.popRoute();
                      },
                    );
                  },
                ),
                100.verticalSpace,
              ],
            ),
    );
  }
}
