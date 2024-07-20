import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

//Method to check for storage related permissions, in-order to be able to save image
Future<bool> checkStoragePermissions() async {
  bool isGranted = false;
  //Permission for general android version
  var result = await Permission.storage.request();
  if (result.isGranted) isGranted = true;
  if (Platform.isAndroid) {
    //Permission for android version that only have Google files by default
    var result1 = await Permission.photos.request();
    if (result1.isGranted) isGranted = true;
  }
  if (isGranted) {
    return true;
  } else {
    return false;
  }
}