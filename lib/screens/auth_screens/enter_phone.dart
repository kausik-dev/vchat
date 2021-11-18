import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:vchat/main.dart';
import 'package:vchat/styles/styles.dart';
import 'package:vchat/widgets/custom_button.dart';

class EnterPhone extends ConsumerWidget {
  const EnterPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAndroid = Platform.isAndroid;
    final phoneController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10.h),
              Consumer(
                builder: (context, ref, _) {
                  final isDark = ref.watch(themeProvider).isDark;
                  return SvgPicture.asset(
                    'assets/vizdale.svg',
                    fit: BoxFit.contain,
                    color: isDark ? VStyle.white : VStyle.darkBlack,
                  );
                },
              ),
              Text("Welcome to VChat",
                  style: isAndroid
                      ? Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 20.sp, fontWeight: FontWeight.w700)
                      : null),
              SizedBox(height: 1.h),
              Text("Enter your phone number to get started",
                  style: isAndroid
                      ? Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.w500)
                      : null),
              SizedBox(height: 3.h),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: _PhoneField(controller: phoneController),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final authPro = ref.watch(authProvider);
                  if (authPro.isEnterPhoneLoading) {
                    return const CupertinoActivityIndicator();
                  }
                  return CustomButton(
                    callback: () {
                      final phoneNo = phoneController.text.trim();
                      if (phoneNo.isNotEmpty && phoneNo.length == 10) {
                        authPro.setEnterPhoneLoading(true);
                        authPro.getStartedWithPhone(
                            context: context, phoneNo: phoneNo);
                      } else {
                        _showSnack(
                            context: context, message: "Enter a Valid Number");
                      }
                    },
                    width: 70.w,
                    name: 'continue',
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.phone,
      autofocus: true,
      controller: controller,
      textAlign: TextAlign.left,
      style:
          Theme.of(context).textTheme.headline1!.copyWith(color: Colors.grey),
      decoration: InputDecoration(
        prefixText: "+91 ",
        hintStyle:
            Theme.of(context).textTheme.headline1!.copyWith(color: Colors.grey),
        hintText: "Phone number",
        fillColor: Theme.of(context).canvasColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent)),
      ),
    );
  }
}
