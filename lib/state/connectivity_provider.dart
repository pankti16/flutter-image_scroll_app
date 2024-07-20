import 'package:flutter/material.dart';

enum ConnectivityStatus {
  online,
  offline
}

class ConnectivityProvider with ChangeNotifier {

  bool _isConnected = true;

  bool get getConnection => _isConnected;

  ConnectivityProvider();

  void updateConnectionStatus(bool connection) {
    _isConnected = connection;
    notifyListeners();
  }
}