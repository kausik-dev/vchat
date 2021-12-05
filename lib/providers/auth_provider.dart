import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vchat/screens/auth_screens/profile_setup.dart';
import 'package:vchat/services/vchat_api.dart';

enum UsernameState { idle, validating, validated, failed }
enum AuthenticationState { init, success, unAuthenticated, failed }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VChatApi _vChatApi = const VChatApi();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthCredential? _phoneAuthCredential;
  // GoogleSignInAccount? _googleSignInAccount;
  String _verificationId = "";
  bool _isEnterPhoneLoading = false;
  bool _isProfileSetupLoading = false;
  int _curPage = 0;
  String _chosenImg = "";
  UsernameState _usernameState = UsernameState.idle;
  AuthenticationState _authenticationState = AuthenticationState.init;
  static String? _curUserId;

  // Getters:
  AuthCredential? get authCredential => _phoneAuthCredential;
  // GoogleSignInAccount? get googleAccount => _googleSignInAccount;
  String get verficationId => _verificationId;
  bool get isEnterPhoneLoading => _isEnterPhoneLoading;
  bool get isProfileSetupLoading => _isProfileSetupLoading;
  int get curPage => _curPage;
  String get chosenImg => _chosenImg;
  UsernameState get usernameState => _usernameState;
  AuthenticationState get authenticationState => _authenticationState;
  String? get curUserId => _curUserId;

  // Empty constructor
  AuthProvider();

  // Setters:
  // set profile image
  void setProfileImage(String image) {
    _chosenImg = image;
    notifyListeners();
  }

  // set curPage
  void moveToPage(int index) {
    _curPage = index;
    notifyListeners();
  }

  //  set EnterPhoneLoading
  void setEnterPhoneLoading(bool val) {
    _isEnterPhoneLoading = val;
    notifyListeners();
  }

  // set UsernameState
  void setUsernameState(UsernameState state) {
    _usernameState = state;
    notifyListeners();
  }

  // set AuthenticationState
  void setAuthState(AuthenticationState state) {
    _authenticationState = state;
    notifyListeners();
  }

  // set ProfileSetupLoading
  set profileSetupLoading(bool status) {
    _isProfileSetupLoading = status;
    notifyListeners();
  }

  // Methods:
  // init method
  static void init(String? userId) {
    _curUserId = _curUserId;
  }

  // method to validateUserName
  Future<void> validateUserName() async {
    final username = userNameController.text.trim().toLowerCase();
    final fetchedState = await _vChatApi.validateUserName(username);
    _usernameState = fetchedState;
    notifyListeners();
  }

  // checking if the phoneNumber is already a verified
  Future getStartedWithPhone({required BuildContext context}) async {
    final phoneNo = phoneController.text.trim();
    try {
      // trying to signIn with the phoneNumber
      await _auth.signInWithPhoneNumber(phoneNo);
      setEnterPhoneLoading(false);
    } catch (err) {
      await verifyPhoneNumber(context: context, number: phoneNo);
    }
  }

  // signIn method
  Future<void> signIn({required BuildContext context}) async {
    final phoneNo = phoneController.text.trim();
    await _auth.signInWithPhoneNumber(phoneNo);
  }

  Future<void> signUp(BuildContext context) async {
    // TODO : TO BE IMPLEMENTED
  }

  // method to createPhoneAuthCredential
  Future<void> createPhoneAuthCredential(BuildContext context) async {
    final smsCode = otpController.text.trim();
    final credential = PhoneAuthProvider.credential(
        verificationId: verficationId, smsCode: smsCode);
    try {
      final phoneAuth = await _auth.signInWithCredential(credential);
      _curPage = 3;
      notifyListeners();
    } catch (err) {
      notifyListeners();
    }
  }

  // method to verify the phoneNumber
  Future<void> verifyPhoneNumber({required BuildContext context, required String number}) async {
    
    final phoneNo = phoneController.text.trim();
    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent smsOTPSent = (String verId, int? forceCodeResend) {
      print("OTP IS SENT");
      _verificationId = verId;
      _isEnterPhoneLoading = false;
      _curPage = 2;
      notifyListeners();
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91"+phoneNo,
        codeAutoRetrievalTimeout: (String verId) {
          print("TIMED OUT !" + verId);65
        },
        codeSent: smsOTPSent,
        timeout: const Duration(seconds: 40),
        verificationCompleted: (AuthCredential phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
          _isEnterPhoneLoading = false;
          _curPage = 3;
          notifyListeners();
          print("MOVING TO THE PROFILE SETUP PAGE");
        },
        verificationFailed: (FirebaseAuthException exception) {
          _showSnack(context, "Verification Failed");
          print('VERIFICATION FAILED ==> ${exception.message}');
          setEnterPhoneLoading(false);
        },
      );
    } catch (e) {
      _isEnterPhoneLoading = false;
      notifyListeners();
      _showSnack(context, "Verification Failed");
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
