// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pinput/pin_put/pin_put.dart';
// import 'dart:io';
// import 'package:sizer/sizer.dart';
// import 'package:vchat/main.dart';
// import 'package:vchat/styles/styles.dart';
// import 'package:vchat/widgets/custom_button.dart';

// class OtpVerification extends ConsumerWidget {
//   OtpVerification({Key? key}) : super(key: key);

//   final TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final customTStyle = Theme.of(context).textTheme.headline1!.copyWith();
//     final authPro = ref.read(authProvider);
//     final phoneNo = authPro.phoneController.text.trim();

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: Text("OTP Verfication",
//             style: Platform.isAndroid
//                 ? Theme.of(context)
//                     .textTheme
//                     .headline1!
//                     .copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700)
//                 : null),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 8.h,
//             ),
//             Text("An Authentication code has been sent to ",
//                 style: customTStyle.copyWith(
//                     fontSize: 12.sp,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w400)),
//             SizedBox(
//               height: 1.h,
//             ),
//             Text(
//               "(+91) $phoneNo",
//               style: customTStyle.copyWith(
//                   fontSize: 12.sp,
//                   color: VStyle.darkBlack,
//                   fontWeight: FontWeight.w700),
//             ),
//             SizedBox(
//               height: 3.h,
//             ),
//             _CustomOTPInput(
//                 otpController: otpController, textStyle: customTStyle),
//             SizedBox(
//               height: 3.h,
//             ),
//             CustomButton(
//                 callback: () {
//                   final smsCode = otpController.text.trim();
//                   if (smsCode.isNotEmpty && smsCode.length == 6) {
//                     authPro.createPhoneAuthCredential(context);
//                   } else {
//                     _showSnack(context: context, message: "Enter a valid OTP");
//                   }
//                 },
//                 width: 70.w,
//                 name: "Submit"),
//             SizedBox(
//               height: 3.h,
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Code Sent.",
//                   style: customTStyle.copyWith(
//                       fontWeight: FontWeight.w700,
//                       color: Colors.grey,
//                       fontSize: 11.sp),
//                 ),
//                 Text(
//                   " Resend Code in ",
//                   style: customTStyle.copyWith(
//                       color: Colors.grey, fontSize: 11.sp),
//                 ),
//                 const _OtpTimer()
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showSnack({required BuildContext context, required String message}) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }
// }

// class _CustomOTPInput extends StatelessWidget {
//   const _CustomOTPInput(
//       {Key? key, required this.otpController, required this.textStyle})
//       : super(key: key);

//   final TextEditingController otpController;
//   final TextStyle textStyle;

//   @override
//   Widget build(BuildContext context) {
//     final BoxDecoration pinPutDecoration = BoxDecoration(
//       borderRadius: BorderRadius.circular(10.0),
//       border: Border.all(width: 2, color: VStyle.lightGrey),
//     );

//     return PinPut(
//       eachFieldWidth: 4.w,
//       eachFieldHeight: 6.h,
//       withCursor: true,
//       fieldsCount: 6,
//       mainAxisSize: MainAxisSize.min,
//       controller: otpController,
//       onSubmit: (String pin) {},
//       submittedFieldDecoration: pinPutDecoration,
//       selectedFieldDecoration: pinPutDecoration,
//       followingFieldDecoration: pinPutDecoration,
//       pinAnimationType: PinAnimationType.scale,
//       eachFieldMargin: EdgeInsets.symmetric(horizontal: 1.w),
//       textStyle: textStyle.copyWith(fontWeight: FontWeight.w700),
//     );
//   }
// }

// class _OtpTimer extends StatefulWidget {
//   const _OtpTimer({Key? key}) : super(key: key);

//   @override
//   _OtpTimerState createState() => _OtpTimerState();
// }

// class _OtpTimerState extends State<_OtpTimer> {
//   int remainingTime = 40;

//   @override
//   void initState() {
//     super.initState();
//     Timer.periodic(const Duration(seconds: 1), (val) {
//       if (remainingTime == 0) {
//         val.cancel();
//         return;
//       }
//       setState(() {
//         remainingTime--;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       "${remainingTime}s",
//       style: Theme.of(context).textTheme.headline1!.copyWith(
//           color: VStyle.primaryBlue,
//           fontSize: 11.sp,
//           fontWeight: FontWeight.w700),
//     );
//   }
// }
