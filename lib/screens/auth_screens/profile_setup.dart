import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';
import 'package:vchat/main.dart';
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _UserNameField(controller: authPro.userNameController),
            ),
            const Spacer(),
            CustomButton(callback: (){

            }, width: 80.w, name: "Done"),
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
  const _UserNameField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.name,
      autofocus: true,
      controller: controller,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.grey),
      decoration: InputDecoration(
        hintStyle: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.grey),
        hintText: "Username",
        fillColor: Theme.of(context).canvasColor,
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
