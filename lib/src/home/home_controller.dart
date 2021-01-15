import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HomeController {
  final localAuth = LocalAuthentication();
  final check = RxNotifier<bool>(false);
  final biometrics = RxNotifier<List<BiometricType>>([]);

  void checkBiometrics() async {
    try {
      final response = await localAuth.canCheckBiometrics;
      check.value = response;
    } catch (e) {
      print(e);
    }
  }

  void getBiometrics() async {
    try {
      final response = await localAuth.getAvailableBiometrics();
      biometrics.value = response;
    } catch (e) {
      print(e);
    }
  }
}
