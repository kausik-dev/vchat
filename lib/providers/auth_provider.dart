import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vchat/screens/auth_screens/otp_verification.dart';
import 'package:vchat/screens/auth_screens/profile_setup.dart';
import 'package:vchat/screens/home/home.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String pictureUrl = "";
  AuthCredential? _authCredential;
  String _errorMsg = "";
  String _verificationId = "";
  bool _isEnterPhoneLoading = false;
  String _smsOTP = "";
  int? _forceResend;

  // getters
  AuthCredential? get authCredential => _authCredential;
  String get errorMsg => _errorMsg;
  String get verficationId => _verificationId;
  bool get isEnterPhoneLoading => _isEnterPhoneLoading;
  String get smsOTP => _smsOTP;
  int? get forceRend => _forceResend;

  //  set EnterPhoneLoading
  void setEnterPhoneLoading(bool val) {
    _isEnterPhoneLoading = val;
    notifyListeners();
  }

  // checking if the phoneNumber is already a verified one or not
  Future getStartedWithPhone(
      {required BuildContext context, required String phoneNo}) async {
    try {
      // trying to signIn with the phoneNumber
      await _auth.signInWithPhoneNumber(phoneNo);
      setEnterPhoneLoading(false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      );
    } catch (err) {
      await verifyPhoneNumber(context: context, number: phoneNo);
    }
  }

  // signIn method
  Future<void> signIn(String phoneNo) async {
    await _auth.signInWithPhoneNumber(phoneNo);
  }

  void createPhoneAuthCredential(BuildContext context, String smsCode) {
    final credential = PhoneAuthProvider.credential(
        verificationId: verficationId, smsCode: smsCode);
    _authCredential = credential;
    if (_authCredential != null) {
      notifyListeners();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ProfileSetup(),
        ),
      );
    } else {
      _showSnack(context, "Try Again");
    }
  }

  // method to verify the phoneNumber
  Future<void> verifyPhoneNumber(
      {required BuildContext context, required String number}) async {
    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOTPSent = (String verId, int? forceCodeResend) {
      print("OTP IS SENT =>");
      _verificationId = verId;
      _forceResend = forceCodeResend;
      _isEnterPhoneLoading = false;
      notifyListeners();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpVerification(
              phoneNo: number,
            ),
        ),
      );
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + number.trim(), // PHONE NUMBER TO SEND OTP
        codeAutoRetrievalTimeout: (String verId) {
          print("TIMED OUT !!!" + verId);
        },
        codeSent: smsOTPSent,
        timeout: const Duration(seconds: 40),
        verificationCompleted: (AuthCredential phoneAuthCredential) {
          _authCredential = phoneAuthCredential;
          _isEnterPhoneLoading = false;
          notifyListeners();
          print("MOVING TO THE PROFILE SETUP PAGE==>");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProfileSetup(),
            ),
          );
        },
        verificationFailed: (FirebaseAuthException exception) {
          _showSnack(context, "Verification Failed");
          print('VERIFICATION FAILED ==> ${exception.message}');
          setEnterPhoneLoading(false);
        },
      );
    } catch (e) {
      _errorMsg = e.toString();
      _isEnterPhoneLoading = false;
      notifyListeners();
    }
  }

  // private method to show snack bar
  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  //  method to signOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
