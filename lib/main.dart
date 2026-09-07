import 'package:src_kstu_app/services/campus_maps_service.dart';
import 'package:src_kstu_app/services/connectivity_provider.dart';
import 'package:src_kstu_app/feature/pages/loading.dart';
import 'package:src_kstu_app/services/key_moments_service.dart';
import 'package:src_kstu_app/services/landmark_places.dart';
import 'package:src_kstu_app/services/notice_board.dart';
import 'package:src_kstu_app/services/trending_news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  //Remove this method to stop OneSignal Debugging
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignal.shared.setAppId("a8a3a92a-86cd-41b5-8efe-2e5badaf01d0");



  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => NoticeBoardProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => TrendingNewsProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => KeyMomentProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CampusMapProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LandmarkProvider(),
      ),
      ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      // ChangeNotifierProvider(create: (_) => AnnouncementPaginationProvider()
      // ),
    ],
    child: MyApp(),
  ));
}

// zamaani
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRC-KsTU',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16),
            bodyMedium: TextStyle(fontSize: 14),
          )),
      home: LoadingPage(),
    );
  }
}
