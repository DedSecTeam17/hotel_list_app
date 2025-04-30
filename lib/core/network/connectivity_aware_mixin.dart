import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

mixin ConnectivityAwareMixin on ChangeNotifier {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  void initConnectivity({bool enable = true}) {
    if (!enable || kIsWeb || _isRunningInTest()) return;
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      final isOnline = result != ConnectivityResult.none;
      if (isOnline) {
        onConnectionRestored();
      }
    });
  }

  bool _isRunningInTest() {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  void onConnectionRestored() {}

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
