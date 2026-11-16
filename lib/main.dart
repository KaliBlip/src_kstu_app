import 'package:src_kstu_app/feature/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:src_kstu_app/feature/pages/news_details.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.none);
  OneSignal.initialize("a8a3a92a-86cd-41b5-8efe-2e5badaf01d0");
  OneSignal.Notifications.requestPermission(true);
  _listenForNotificationClicks();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}


void _listenForNotificationClicks() {
  OneSignal.Notifications.addClickListener((event) {
    final data = event.notification.additionalData;
    final rawId = data?['announcemet_id'] ?? data?['announcement_id'];
    if (rawId == null) return;
    final announcementId =
        rawId is int ? rawId : int.tryParse(rawId.toString());
    if (announcementId == null) return;
    _navigateToAnnouncement(announcementId);
  });
}

Future<void> _navigateToAnnouncement(int announcementId) async {
  var navigator = navigatorKey.currentState;
  var attempts = 0;
  while (navigator == null && attempts < 50) {
    await Future.delayed(const Duration(milliseconds: 100));
    navigator = navigatorKey.currentState;
    attempts++;
  }
  navigator?.push(
    MaterialPageRoute(builder: (_) => DetailNews(title: announcementId)),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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

