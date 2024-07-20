import 'package:flutter/material.dart';

class CommonProvider with ChangeNotifier {
  bool _isDownloading = false;
  bool _isSharing = false;

  bool get isDownloading => _isDownloading;
  bool get isSharing => _isSharing;

  CommonProvider();

  void updateIsDownloading(bool isDown) {
    _isDownloading = isDown;
    notifyListeners();
  }

  void updateIsSharing(bool isShare) {
    _isSharing = isShare;
    notifyListeners();
  }
}