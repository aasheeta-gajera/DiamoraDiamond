
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../Library/Utils.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
    checkInitialStatus();
  }

  Future<void> checkInitialStatus() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    bool hasConnection = results.any((result) => result != ConnectivityResult.none);

    if (!hasConnection) {
      isConnected.value = false;
      showNoInternetDialog();
    } else {
      isConnected.value = true;
      closeNoInternetDialog();
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
