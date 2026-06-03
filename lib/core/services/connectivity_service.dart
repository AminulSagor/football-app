import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final RxBool hasInternet = true.obs;
  final RxBool isChecking = false.obs;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  int _checkToken = 0;

  Future<ConnectivityService> init() async {
    await refresh();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
    );
    return this;
  }

  Future<void> refresh() async {
    final token = ++_checkToken;
    isChecking.value = true;

    try {
      final results = await _connectivity.checkConnectivity();
      await _updateInternetStatus(results, token);
    } catch (_) {
      if (token == _checkToken) {
        hasInternet.value = false;
      }
    } finally {
      if (token == _checkToken) {
        isChecking.value = false;
      }
    }
  }

  Future<void> _handleConnectivityChange(
    List<ConnectivityResult> results,
  ) async {
    final token = ++_checkToken;
    await _updateInternetStatus(results, token);
  }

  Future<void> _updateInternetStatus(
    List<ConnectivityResult> results,
    int token,
  ) async {
    final hasNetwork = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!hasNetwork) {
      if (token == _checkToken) {
        hasInternet.value = false;
      }
      return;
    }

    final hasRealInternet = await _hasRealInternetAccess();
    if (token == _checkToken) {
      hasInternet.value = hasRealInternet;
    }
  }

  Future<bool> _hasRealInternetAccess() async {
    if (kIsWeb) {
      return true;
    }

    try {
      final result = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on Object {
      return false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
