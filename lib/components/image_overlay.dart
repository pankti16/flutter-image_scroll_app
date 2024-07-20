import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_scroll_app/model/image_model.dart';
import 'package:image_scroll_app/state/common_provider.dart';
import 'package:image_scroll_app/utils/common_utils.dart';
import 'package:image_scroll_app/utils/permission_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'overlay_container_on_long_press.dart';

class ImageOverlay extends StatelessWidget {
  final Widget childWidget;
  final ImageModel imageItem;
  final bool isError;
  const ImageOverlay({super.key, required this.childWidget, required this.imageItem, required this.isError});

  @override
  Widget build(BuildContext context) {
    bool isDownloading = Provider.of<CommonProvider>(context).isDownloading;
    bool isSharing = Provider.of<CommonProvider>(context).isSharing;

    //When user click on open in browser
    Future<void> onViewItem() async {
      final Uri url = Uri.parse(imageItem.url);
      if (!await launchUrl(url)) {
        Fluttertoast.showToast(msg: 'Error launching image origin url');
      }
    }

    //When user click on download image
    void onDownloadItem() async {
      if (isError) {
        Fluttertoast.showToast(msg: 'Error downloading image');
        return;
      }
      //Check if there is any on-going download/share
      if (isDownloading || isSharing) return;
      //Check if have storage permission
      if (await checkStoragePermissions()) {
        Provider.of<CommonProvider>(context, listen: false).updateIsDownloading(
            true);
        await downloadImageFile(context, imageItem.downloadUrl, 'picasa_${imageItem.id}');
        Provider.of<CommonProvider>(context, listen: false).updateIsDownloading(
            false);
      } else {
        Fluttertoast.showToast(msg: 'This app needs storage permission, Please go to settings and allow storage permission', toastLength: Toast.LENGTH_LONG,);
      }
    }

    //When user click on share image
    void onShareItem() async {
      if (isError) {
        Fluttertoast.showToast(msg: 'Error sharing image');
        return;
      }
      //Check if there is any on-going download/share
      if (isDownloading || isSharing) return;
      Provider.of<CommonProvider>(context, listen: false).updateIsSharing(true);
      await shareImageFile(context, imageItem.downloadUrl);
      Provider.of<CommonProvider>(context, listen: false).updateIsSharing(false);
    }

    return OverlayableContainerOnLongPress(
      key: ValueKey('OverlayableContainerOnLongPress${imageItem.id}'),
      child: childWidget,
      overlayContentBuilder:
          (BuildContext context, VoidCallback onHideOverlay) {
        return Container(
          key: ValueKey('OverlayContainer${imageItem.id}'),
          height: double.infinity,
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.open_in_browser_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  onHideOverlay();
                  onViewItem();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  onHideOverlay();
                  onDownloadItem();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.share_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  onHideOverlay();
                  onShareItem();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
