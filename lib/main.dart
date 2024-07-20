import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_scroll_app/components/infinite_scroll_grid_view.dart';
import 'package:image_scroll_app/components/network_child.dart';
import 'package:image_scroll_app/service/connectivity_service.dart';
import 'package:image_scroll_app/state/common_provider.dart';
import 'package:image_scroll_app/state/connectivity_provider.dart';
import 'package:image_scroll_app/state/pic_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_scroll_app/state/theme_provider.dart';
import 'package:image_scroll_app/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  //Restrict orientation of app to be portrait up
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _connectivityService = ConnectivityService();

  //Main material app that is wrapped with providers and theme configuration
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      create: (_) => _connectivityService.status,
      initialData: ConnectivityStatus.offline,
      child: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommonProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PicImageProvider(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        title: 'Picasa',
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightThemeData(),
        darkTheme: CustomTheme.darkThemeData(),
        themeMode: context.watch<ThemeProvider>().themeModeType,
        home: const MyHomePage(title: 'PICASA'),
      ),
    ),
  );
  }
}

//Widget to show content of first screen/page
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    //Method to manage app theme
    void changeTheme(int item) {
      switch (item) {
        case 0:
          themeProvider.updateThemeData(ThemeMode.light);
          break;
        case 1:
          themeProvider.updateThemeData(ThemeMode.dark);
          break;
        case 2:
          themeProvider.updateThemeData(ThemeMode.system);
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, letterSpacing: 8.0,),),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            tooltip: 'Theme',
            icon: const Icon(Icons.contrast_rounded),
            onSelected: (item) => changeTheme(item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Light'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Dark'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('System'),
              ),
            ],
          ),
        ],
      ),
      body: const NetworkChild(
        displayChildWidget: InfiniteScrollGridView(),
      ),
    );
  }
}
