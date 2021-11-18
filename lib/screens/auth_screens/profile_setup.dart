import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sizer/sizer.dart';

class ProfileSetup extends StatelessWidget {
  const ProfileSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            
          ],
        ),
      ),
    );
  }
}
