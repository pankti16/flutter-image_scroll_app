import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_scroll_app/constants/common_constants.dart';
import 'package:image_scroll_app/state/connectivity_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

//Method to formulate new url to display in the list, since the original urls have very big size which might impact on app performance
String getDisplayUrl(String url) {
  int newWidth = 250;
  int newHeight = 250;
  var urlList = url.split('/');
  urlList[urlList.length - 1] = newHeight.toString();
  urlList[urlList.length - 2] = newWidth.toString();
  return urlList.join('/');
}

//Method to ping and check whether there is working internet or not
Future<bool> checkInternet(context) async {
  try {
    final url = Uri.https('google.com');
    var response = await http.head(url);
    if (response.statusCode == 200) {
      //Update to state variable
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ConnectivityProvider>(context, listen: false)
            .updateConnectionStatus(true);
      });
      return true;
    } else {
      //Update to state variable
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ConnectivityProvider>(context, listen: false)
            .updateConnectionStatus(false);
      });
      return false;
    }
  } catch (e) {
    //Update to state variable
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConnectivityProvider>(context, listen: false)
          .updateConnectionStatus(false);
    });
    return false;
  }
}

//Method to download image
Future<bool> downloadImageFile(context, String url, String fileName) async {
  try {
    //Check for internet before trying to download
    bool isAvail = await checkInternet(context);
    if (!isAvail) {
      Fluttertoast.showToast(msg: 'Unable to download due to network.',);
      return false;
    }
    //Download procedure
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;

    String extension =
        response.headers['content-type'].toString().split('/')[1];

    final documentDir = Platform.isIOS
        ? (await getApplicationDocumentsDirectory()).path
        : (await getApplicationSupportDirectory())?.path;
    String newPath = '';
    if (Platform.isIOS) {
      newPath = '$documentDir/$kFolderName';
    } else {
      List<String> paths = documentDir!.split('/');
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != 'Android') {
          newPath += '/$folder';
        } else {
          break;
        }
      }
      newPath = '$newPath/$kFolderName';
    }

    final Directory downloadDir = Directory(newPath);

    var isExist = await downloadDir.exists();
    if (!isExist) {
      await downloadDir.create(
        recursive: true,
      );
    }
    var fileName = DateTime.now().millisecondsSinceEpoch.toString().trim();
    final path = '${downloadDir.path}/$fileName.$extension';
    var file = File(path);

    await file.writeAsBytes(bytes);

    await ImageGallerySaver.saveFile(path, isReturnPathOfIOS: true);

    Fluttertoast.showToast(
      msg: 'Image downloaded!',
    );
    OpenFile.open(path);
    return true;
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error downloading image ${e.toString()}', toastLength: Toast.LENGTH_LONG,);
    return false;
  }
}

//Method to share image
Future<bool> shareImageFile(context, String url) async {
  try {
    //Check for internet before trying to share image
    bool isAvail = await checkInternet(context);
    if (!isAvail) {
      Fluttertoast.showToast(msg: 'Unable to download due to network.',);
      return false;
    }

    //Share procedure
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final bytes = response.bodyBytes;

    String extension =
        response.headers['content-type'].toString().split('/')[1];

    final temp = await getTemporaryDirectory();

    final path =
        '${temp.path}/${DateTime.now().millisecondsSinceEpoch.toString().trim()}.$extension';

    File(path).writeAsBytesSync(bytes);

    await Share.shareXFiles(
      [
        XFile(path),
      ],
      text: 'Amazing pictures are available in Picasa, just like this one',
      subject: 'Picasa Share',
    );
    Future.delayed(const Duration(seconds: 60 * 10), () {
      File(path).deleteSync();
    });
    return true;
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error sharing image');
    return false;
  }
}
