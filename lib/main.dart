import 'package:src_kstu_app/feature/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:src_kstu_app/services/connectivity_provider.dart';
import 'package:src_kstu_app/services/notice_board.dart';
import 'package:src_kstu_app/services/trending_news.dart';
import 'package:src_kstu_app/services/campus_maps_service.dart';
import 'package:src_kstu_app/services/landmark_places.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize OneSignal
  OneSignal.Debug.setLogLevel(OSLogLevel.none); // Use verbose only during dev
  OneSignal.initialize("a8a3a92a-86cd-41b5-8efe-2e5badaf01d0");

  // Opt-in so the SDK registers the device and requests permission on iOS
  OneSignal.Notifications.requestPermission(true);

  runApp(
    ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
          ChangeNotifierProvider(create: (_) => NoticeBoardProvider()),
          ChangeNotifierProvider(create: (_) => TrendingNewsProvider()),
          ChangeNotifierProvider(create: (_) => CampusMapProvider()),
          ChangeNotifierProvider(create: (_) => LandmarkProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRC-KsTU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      home: const LoadingPage(),
    );
  }
}
