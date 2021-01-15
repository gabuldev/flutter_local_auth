import 'package:flutter_local_auth_invisible/auth_strings.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';
import 'package:rx_notifier/rx_notifier.dart';

enum Status { empty, awaiting, error, success }

class HomeController {
  final localAuth = LocalAuthentication();
  final check = RxNotifier<bool>(false);
  final biometrics = RxNotifier<List<BiometricType>>([]);
  final status = RxNotifier<Status>(Status.empty);

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

  void didAuthenticate() async {
    try {
      status.value = Status.awaiting;
      const iosStrings = const IOSAuthMessages(
          cancelButton: 'cancel',
          goToSettingsButton: 'settings',
          goToSettingsDescription: 'Please set up your Touch ID.',
          lockOut: 'Please reenable your Touch ID');
      final response = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Please authenticate to show account balance',
          useErrorDialogs: true,
          iOSAuthStrings: iosStrings);
      status.value = Status.success;

      print(response);
    } catch (e) {
      status.value = Status.error;
      print(e);
    }
  }
}
