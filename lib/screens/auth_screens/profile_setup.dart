import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:vchat/main.dart';
import 'package:vchat/providers/auth_provider.dart';
import 'package:vchat/styles/styles.dart';
import 'package:vchat/widgets/custom_button.dart';

class ProfileSetup extends ConsumerWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authPro = ref.read(authProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile",
            style: Platform.isAndroid
                ? Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700)
                : null),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            const _ProfileAvatarPicker(image: ""),
            SizedBox(height: 3.h),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).canvasColor),
              child: Row(
                children: [
                  Expanded(
                    child: _UserNameField(
                        controller: authPro.userNameController,
                        authPro: authPro),
                  ),
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      final state = ref.watch(authProvider).usernameState;
                      if (state == UsernameState.idle) {
                        return const Icon(CupertinoIcons.checkmark_alt_circle,
                            color: Colors.white12);
                      } else if (state == UsernameState.validating) {
                        return const CupertinoActivityIndicator();
                      } else if (state == UsernameState.validated) {
                        return const Icon(CupertinoIcons.checkmark_alt_circle,
                            color: Colors.green);
                      }
                      return const Icon(CupertinoIcons.clear_circled,
                          color: Colors.red);
                    },
                  )
                ],
              ),
            ),
            // const Spacer(),
            SizedBox(height: 3.h),
            CustomButton(
                callback: () async {
                  if (authPro.usernameState == UsernameState.validated){
                    authPro.sign
                  }
                },
                width: 80.w,
                name: "Done"),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }
}

class _ProfileAvatarPicker extends StatelessWidget {
  const _ProfileAvatarPicker({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      // backgroundImage: FileImage(File(image)),
      backgroundColor: VStyle.darkgrey,
      radius: 65,
    );
  }
}

class _UserNameField extends StatelessWidget {
  const _UserNameField(
      {Key? key, required this.controller, required this.authPro})
      : super(key: key);

  final TextEditingController controller;
  final AuthProvider authPro;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) async {
        await Future.delayed(const Duration(seconds: 2));
        authPro.setUsernameState(UsernameState.validating);
        await authPro.validateUserName();
      },
      keyboardType: TextInputType.name,
      autofocus: true,
      controller: controller,
      textAlign: TextAlign.left,
      style:
          Theme.of(context).textTheme.headline1!.copyWith(color: Colors.grey),
      decoration: InputDecoration(
        hintStyle:
            Theme.of(context).textTheme.headline1!.copyWith(color: Colors.grey),
        hintText: "Username",
        // fillColor: Theme.of(context).canvasColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
