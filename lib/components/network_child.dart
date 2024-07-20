import 'package:flutter/material.dart';
import 'package:image_scroll_app/service/connectivity_service.dart';
import 'package:image_scroll_app/state/common_provider.dart';
import 'package:image_scroll_app/state/connectivity_provider.dart';
import 'package:provider/provider.dart';

//Show no-internet message when no internet and also show loader when downloading or sharing an image
class NetworkChild extends StatefulWidget {
  final Widget displayChildWidget;

  const NetworkChild({super.key, required this.displayChildWidget});

  @override
  State<NetworkChild> createState() => _NetworkChildState();
}

class _NetworkChildState extends State<NetworkChild> {
  late ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();

    _connectivityService = ConnectivityService();

    _connectivityService.connectivityStream.listen((status) {
      if (status == ConnectivityStatus.online) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<ConnectivityProvider>(context, listen: false)
              .updateConnectionStatus(true);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDownloading = Provider.of<CommonProvider>(context).isDownloading;
    bool isSharing = Provider.of<CommonProvider>(context).isSharing;
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

      return Stack(
        children: [
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: widget.displayChildWidget,
          ),
          if (status == ConnectivityStatus.offline || !Provider.of<ConnectivityProvider>(context).getConnection)
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              height: 40.0,
              color: Theme.of(context).colorScheme.errorContainer,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 10.0,),
                    Text(
                      "Not Connected",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isDownloading || isSharing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
    // });
  }
}
