import 'dart:async';
import 'dart:convert';
import 'dart:math';
// import 'dart:developer';
import 'package:crypto/crypto.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/services/network_caller.dart';
import '../../../core/services/notifications/fcm_token_sync.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';

enum OtpFlow { signup, forgotPassword }

class AuthController extends GetxController with WidgetsBindingObserver {
  final NetworkCaller _networkCaller = NetworkCaller();

  // Loading
  final RxBool isLoading = false.obs;
  bool _appleSignInInProgress = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _appleSignInInProgress) {
      _appleSignInInProgress = false;
      isLoading.value = false;
    }
  }

  // Login
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final loginObscure = true.obs;

  // Sign Up
  final signUpNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();
  final signUpObscure = true.obs;
  final signUpConfirmObscure = true.obs;
  final selectedLicenseType = 0.obs; // 0 = LPN, 1 = RN
  final agreeToTerms = false.obs;

  // OTP
  final otpController = TextEditingController();
  final RxString otpEmail = ''.obs;
  final RxInt timerSeconds = 120.obs;
  final RxBool canResend = false.obs;
  Timer? _otpTimer;
  OtpFlow _currentOtpFlow = OtpFlow.signup;

  // Reset Password
  final resetEmailController = TextEditingController();

  // Set New Password
  final setNewPasswordController = TextEditingController();
  final setNewPasswordObscure = true.obs;
  final setConfirmPasswordController = TextEditingController();
  final setConfirmPasswordObscure = true.obs;

  // Change Password
  final currentPasswordController = TextEditingController();
  final currentPasswordObscure = true.obs;
  final newPasswordController = TextEditingController();
  final newPasswordObscure = true.obs;
  final confirmPasswordController = TextEditingController();
  final confirmPasswordObscure = true.obs;

  // ─── Login ────────────────────────────────────────────────────

  Future<void> onLogin() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      AppHelperFunctions.showWarningSnackBar('Please fill in all fields.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _networkCaller.postRequest(
        ApiConstants.login,
        body: {'email': email, 'password': password},
      );

      if (response.isSuccess) {
        final data = response.responseData['data'];
        await StorageService.saveUserSession(
          id: data['id'],
          fullName: data['fullName'],
          email: data['email'],
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        await FcmTokenSync.sync();
        await Purchases.logIn(data['id']);
        Get.offAllNamed(AppRoute.getHomeScreen());
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Google Sign-In ───────────────────────────────────────────

  static bool _googleInitialized = false;

  Future<void> onGoogleLogin({bool requireTerms = false}) async {
    if (requireTerms && !agreeToTerms.value) {
      AppHelperFunctions.showWarningSnackBar(
          'Please agree to the Terms & Conditions and Privacy Policy.');
      return;
    }
    isLoading.value = true;
    try {
      if (!_googleInitialized) {
        await GoogleSignIn.instance.initialize(
          serverClientId: ApiConstants.googleServerClientId,
        );
        _googleInitialized = true;
      }

      final googleAccount = await GoogleSignIn.instance.authenticate();
      final googleIdToken = googleAccount.authentication.idToken;
      if (googleIdToken == null) {
        AppHelperFunctions.showErrorSnackBar('Google sign-in failed.');
        return;
      }

      final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseIdToken = await userCred.user?.getIdToken();
      if (firebaseIdToken == null) {
        AppHelperFunctions.showErrorSnackBar('Could not get Firebase token.');
        return;
      }

      final response = await _networkCaller.postRequest(
        ApiConstants.googleLogin,
        body: {'idToken': firebaseIdToken},
      );

      if (response.isSuccess) {
        final data = response.responseData['data'];
        await StorageService.saveUserSession(
          id: data['id'],
          fullName: data['fullName'],
          email: data['email'],
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        await FcmTokenSync.sync();
        await Purchases.logIn(data['id']);
        Get.offAllNamed(AppRoute.getHomeScreen());
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } on GoogleSignInException catch (e) {
      // log('GoogleSignIn error: code=${e.code} details=${e.description}');
      if (e.code != GoogleSignInExceptionCode.canceled) {
        AppHelperFunctions.showErrorSnackBar(
            'Google sign-in failed: ${e.code.name}');
      }
    } on FirebaseAuthException catch (e) {
      // log('FirebaseAuth error: code=${e.code} message=${e.message}');
      AppHelperFunctions.showErrorSnackBar(
          'Auth failed: ${e.message ?? e.code}');
    } catch (e) {
      // log('Google sign-in unexpected error: $e');
      AppHelperFunctions.showErrorSnackBar('Google sign-in failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Apple Sign-In ────────────────────────────────────────────

  String _generateNonce([int length = 32]) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> onAppleLogin({bool requireTerms = false}) async {
    if (requireTerms && !agreeToTerms.value) {
      AppHelperFunctions.showWarningSnackBar(
          'Please agree to the Terms & Conditions and Privacy Policy.');
      return;
    }
    isLoading.value = true;
    _appleSignInInProgress = true;
    try {
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      final firebaseIdToken = await userCred.user?.getIdToken();
      if (firebaseIdToken == null) {
        AppHelperFunctions.showErrorSnackBar('Could not get Firebase token.');
        return;
      }

      final response = await _networkCaller.postRequest(
        ApiConstants.appleLogin,
        body: {'idToken': firebaseIdToken},
      );

      if (response.isSuccess) {
        final data = response.responseData['data'];
        await StorageService.saveUserSession(
          id: data['id'],
          fullName: data['fullName'],
          email: data['email'],
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );
        await FcmTokenSync.sync();
        await Purchases.logIn(data['id']);
        Get.offAllNamed(AppRoute.getHomeScreen());
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        // User cancelled — no message needed
      } else if (e.code == AuthorizationErrorCode.unknown) {
        AppHelperFunctions.showErrorSnackBar(
          'No Apple ID found on this device. Please go to Settings → Sign in to your iPhone to set up your Apple ID.',
        );
      } else {
        AppHelperFunctions.showErrorSnackBar('Apple sign-in failed: ${e.message}');
      }
    } on FirebaseAuthException catch (e) {
      AppHelperFunctions.showErrorSnackBar('Auth failed: ${e.message ?? e.code}');
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Apple sign-in failed.');
    } finally {
      _appleSignInInProgress = false;
      isLoading.value = false;
    }
  }

  // ─── Sign Up ──────────────────────────────────────────────────

  Future<void> onSignUp() async {
    final name = signUpNameController.text.trim();
    final email = signUpEmailController.text.trim();
    final password = signUpPasswordController.text;
    final confirmPassword = signUpConfirmPasswordController.text;
    final licenseType = selectedLicenseType.value == 0 ? 'LPN' : 'RN';

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      AppHelperFunctions.showWarningSnackBar('Please fill in all fields.');
      return;
    }

    if (!agreeToTerms.value) {
      AppHelperFunctions.showWarningSnackBar(
          'Please agree to the Terms & Conditions and Privacy Policy.');
      return;
    }

    if (password != confirmPassword) {
      AppHelperFunctions.showWarningSnackBar('Passwords do not match.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _networkCaller.postRequest(
        ApiConstants.signup,
        body: {
          'fullName': name,
          'email': email,
          'password': password,
          'reTypePassword': confirmPassword,
          'license_type': licenseType,
          'platform': GetPlatform.isAndroid
              ? 'android'
              : GetPlatform.isIOS
                  ? 'ios'
                  : 'web',
        },
      );

      if (response.isSuccess) {
        otpEmail.value = email;
        _currentOtpFlow = OtpFlow.signup;
        AppHelperFunctions.showSuccessSnackBar(
          response.responseData['message'] ?? 'OTP sent to your email.',
        );
        Get.toNamed(AppRoute.getOtpScreen());
        _startOtpTimer();
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to create account. Please try again.',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to create account. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Forgot Password ─────────────────────────────────────────

  Future<void> onSendResetLink() async {
    final email = resetEmailController.text.trim();
    if (email.isEmpty) {
      AppHelperFunctions.showWarningSnackBar('Please enter your email.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _networkCaller.postRequest(
        ApiConstants.forgotPassword,
        body: {'email': email},
      );

      if (response.isSuccess) {
        otpEmail.value = email;
        _currentOtpFlow = OtpFlow.forgotPassword;
        AppHelperFunctions.showSuccessSnackBar(
          response.responseData['message'] ??
              'OTP has been sent to your email.',
        );
        Get.toNamed(AppRoute.getOtpScreen());
        _startOtpTimer();
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Verify OTP ───────────────────────────────────────────────

  Future<void> onVerifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length < 6) {
      AppHelperFunctions.showWarningSnackBar('Please enter the 6-digit code.');
      return;
    }

    isLoading.value = true;
    try {
      final endpoint = _currentOtpFlow == OtpFlow.signup
          ? ApiConstants.verifyOtp
          : ApiConstants.verifyForgotOtp;

      final response = await _networkCaller.postRequest(
        endpoint,
        body: {'email': otpEmail.value, 'otp': otp},
      );

      if (response.isSuccess) {
        _stopOtpTimer();

        if (_currentOtpFlow == OtpFlow.signup) {
          // Signup verify returns tokens — save and go home
          final data = response.responseData['data'];
          await StorageService.saveUserSession(
            id: data['id'],
            fullName: data['fullName'],
            email: data['email'],
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
          );
          await FcmTokenSync.sync();
          await Purchases.logIn(data['id']);
          Get.offAllNamed(AppRoute.getHomeScreen());
        } else {
          // Forgot password verify — go to set new password
          Get.toNamed(AppRoute.getSetNewPasswordScreen());
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Resend OTP ───────────────────────────────────────────────

  Future<void> onResendOtp() async {
    if (!canResend.value) return;

    isLoading.value = true;
    try {
      final endpoint = _currentOtpFlow == OtpFlow.signup
          ? ApiConstants.resendOtp
          : ApiConstants.forgotPassword;

      final response = await _networkCaller.postRequest(
        endpoint,
        body: {'email': otpEmail.value},
      );

      if (response.isSuccess) {
        AppHelperFunctions.showSuccessSnackBar('A new OTP has been sent.');
        _startOtpTimer();
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Set New Password (after forgot password flow) ────────────

  Future<void> onSetNewPassword() async {
    final newPassword = setNewPasswordController.text;
    final confirmPassword = setConfirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      AppHelperFunctions.showWarningSnackBar('Please fill in all fields.');
      return;
    }

    if (newPassword != confirmPassword) {
      AppHelperFunctions.showWarningSnackBar('Passwords do not match.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _networkCaller.postRequest(
        ApiConstants.resetPassword,
        body: {
          'email': otpEmail.value,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.isSuccess) {
        AppHelperFunctions.showSuccessSnackBar(
          response.responseData['message'] ??
              'Password reset successfully. Please log in.',
        );
        Get.offAllNamed(AppRoute.getLoginScreen());
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── OTP Timer ────────────────────────────────────────────────

  void _startOtpTimer() {
    _stopOtpTimer();
    timerSeconds.value = 120;
    canResend.value = false;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds.value > 0) {
        timerSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void _stopOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
  }

  String get formattedTimer {
    final minutes = (timerSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (timerSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ─── Navigation ───────────────────────────────────────────────

  void onForgotPassword() {
    Get.toNamed(AppRoute.getResetPasswordScreen());
  }

  Future<void> onChangePassword() async {
    final oldPassword = currentPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (oldPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      AppHelperFunctions.showWarningSnackBar('Please fill in all fields.');
      return;
    }

    if (newPassword != confirmPassword) {
      AppHelperFunctions.showWarningSnackBar('Passwords do not match.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _networkCaller.postRequest(
        ApiConstants.changePassword,
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );

      if (response.isSuccess) {
        AppHelperFunctions.showSuccessSnackBar(
          response.responseData['message'] ?? 'Password changed successfully.',
        );
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.back();
      } else {
        AppHelperFunctions.showErrorSnackBar(response.errorMessage);
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to change password');
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() {
    Get.toNamed(AppRoute.getSignUpScreen());
  }

  void goToLogin() {
    Get.toNamed(AppRoute.loginScreen);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopOtpTimer();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    resetEmailController.dispose();
    otpController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    setNewPasswordController.dispose();
    setConfirmPasswordController.dispose();
    super.onClose();
  }
}
