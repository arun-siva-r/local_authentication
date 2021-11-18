import 'package:flutter_app_local_auth/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class LoginController extends SuperController {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isDeviceSupported = false;
  bool isLoggedIn = false;

  @override
  Future<void> onInit() async{
    super.onInit();
    if (!GetPlatform.isWeb) {
      auth
          .isDeviceSupported()
          .then((bool isSupported) => _isDeviceSupported = isSupported);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loginBioMetrics() async {
    if (GetPlatform.isWeb) {
      return;
    }
    final bool canCheckBioMetric = await auth.canCheckBiometrics;
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    if (_isDeviceSupported &&
        canCheckBioMetric &&
        availableBiometrics.isNotEmpty) {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Login to the app',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      if (authenticated && Get.currentRoute == Routes.LOGIN) {
        Get.toNamed(Routes.HOME);
        isLoggedIn = true;
      }
      return;
    }
    isLoggedIn = false;
    Get.snackbar('Login required', 'Not supported');
    return;
  }

  @override
  void onDetached() {
    if (Get.currentRoute == Routes.HOME) {
      Get.back();
    }
  }

  @override
  void onInactive() {
    if (Get.currentRoute == Routes.HOME) {
      Get.back();
    
    }
  }

  @override
  void onPaused() {
    if (Get.currentRoute == Routes.HOME) {
      Get.back();
    }
  }

  @override
  void onResumed() {
    if (isLoggedIn) {
      loginBioMetrics();
    }
  }
}
