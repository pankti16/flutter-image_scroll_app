import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:image_scroll_app/state/connectivity_provider.dart';

class ConnectivityService {
  final StreamController<ConnectivityStatus> _connectivityController =
  StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _connectivityController.add(ConnectivityStatus.offline);
      } else {
        _connectivityController.add(ConnectivityStatus.online);
      }
    });
  }

  Stream<ConnectivityStatus> get status async* {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      yield ConnectivityStatus.offline;
    } else {
      yield ConnectivityStatus.online;
    }
    yield* _connectivityController.stream;
  }

  Stream<ConnectivityStatus> get connectivityStream =>
      _connectivityController.stream;

  void dispose() {
    _connectivityController.close();
  }
}