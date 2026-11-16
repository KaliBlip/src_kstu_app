import 'dart:async';

import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/components/random_qoute_generator.dart';
import 'package:src_kstu_app/providers/connectivity_provider.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/login_page.dart';
import 'package:src_kstu_app/feature/pages/on-boarding/onboarding-parent.dart';
import 'package:src_kstu_app/feature/pages/welcome_screen.dart';
import 'package:src_kstu_app/models/api_response.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:src_kstu_app/components/app_animations.dart';
import 'package:src_kstu_app/components/app_snackbar.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  void _loadUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var name = localStorage.getString('name');

    String token = await getToken();
    bool isOpened = await hasOpenedApp();
    // print(isOpened);
    if (!isOpened == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => onBoardingParent()),
          (route) => false);
      // has not opened app b4
    } else {
      // has opened app b4

      if (token == '') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeScreenPage()),
            (route) => false);
      } else {
        ApiResponse response = await getUserDetails();
        if (response.error == null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Dashboard()),
              (route) => false);
          showAppSnackBar(
            message: 'Welcome back, ${name ?? ""}',
            backgroundColor: topColor,
          );
        } else if (response.error == unauthorized) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
          showAppSnackBar(
            message: "You have been logged out",
            backgroundColor: topColor,
          );
        } else {
          showAppSnackBar(
            message: "${response.error}",
            backgroundColor: Colors.red.shade700,
          );
        }
      }
    }
  }

  // showAlertDialog(BuildContext context, Function() runthis) {
  //   // set up the button
  //   Widget okButton = TextButton(
  //     child: Text("OK,cool am all in!"),
  //     onPressed: runthis,
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Receive notification alerts"),
  //     content: Text(
  //         'This app would like to send you push notifications when there is any activity on campus'),
  //     actions: [
  //       okButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  // void requestNotificationPermission_() async {
  //   print('permit me!');
  //   // open prompt for user to enable notification
  //   PermissionStatus permissionStatus =
  //       await NotificationPermissions.getNotificationPermissionStatus();
  //   // if(permissionStatus == PermissionStatus.denied) {
  //   //   // if user explicitly denied notifications, we don't want to show them again
  //   //   return;
  //   // }

  //   if (permissionStatus != PermissionStatus.granted) {
  //     if (!mounted) return;

  //     // showConfirmDialog(context, title: 'Receive notification alerts',
  //     //   subtitle: 'This app would like to send you push notifications when there is any activity on your account',
  //     //   onConfirmTapped: () async {
  //     //     }
  //     //   },
  //     // );
  //     showAlertDialog(context, () async {
  //       final requestResponse =
  //           await NotificationPermissions.requestNotificationPermissions();
  //       if (requestResponse == PermissionStatus.granted) {
  //         // user granted permission
  //         // registerUserForPushNotification();
  //         return;
  //       }
  //     });
  //   } else {
  //     // registerUserForPushNotification();
  //   }
  // }

  // void registerUserForPushNotification() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();

  //   var user_id = localStorage.getInt('id');
  //   print("in loading!: ${user_id}");

  //   var myCustomUniqueUserId = "${user_id}";
  //   final setExtPushIdResponse =
  //       await OneSignal.shared.setExternalUserId(myCustomUniqueUserId);
  //   debugPrint(
  //       "setExtPushIdResponse: $setExtPushIdResponse :: newDeviceId: $myCustomUniqueUserId");

  //   if (setExtPushIdResponse['push']['success'] != null) {
  //     if (setExtPushIdResponse['push']['success'] is bool) {
  //       // ignore: unused_local_variable
  //       final status = setExtPushIdResponse['push']['success'] as bool;
  //       // if (status) {
  //       //   ShowwcaseStorage.setPushRegistrationStatus = "registered";
  //       // }
  //     } else if (setExtPushIdResponse['push']['success'] is int) {
  //       // ignore: unused_local_variable
  //       final status = setExtPushIdResponse['push']['success'] as int;
  //       // if (status == 1) {
  //       //   ShowwcaseStorage.setPushRegistrationStatus = "registered";
  //       // }
  //     }
  //     debugPrint(
  //         "registered for push: ${setExtPushIdResponse['push']['success']}");
  //   }
  // }

  @override
  void initState() {
    // requestNotificationPermission_();

    super.initState();

    // listenForPushNotifications(context);
    Timer(Duration(seconds: 8), _loadUserInfo);
  }

  // void listenForPushNotifications(BuildContext context) {
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     final data = result.notification.additionalData;
  //     final announcemet_id = data!['announcemet_id'];
  //     debugPrint("background notification announcemet_id $announcemet_id.");

  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(
  //             builder: (context) => DetailNews(title: announcemet_id)),
  //         (route) => false);
  //   });

  //   // OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //   //   (OSNotificationReceivedEvent notification) async {
  //   //     final data = notification.notification.additionalData;
  //   //     final announcemet_id = data!['announcemet_id'];
  //   //     Navigator.push(
  //   //       context,
  //   //       MaterialPageRoute(
  //   //         builder: (context) => DetailNews(title: announcemet_id),
  //   //       ),
  //   //     );
  //   //   },
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: topColor,
      body: Semantics(
        label: "Loading page",
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Full-screen background image
            Image.asset(
              "assets/images/hero_image.jpeg",
              fit: BoxFit.cover,
            ),

            // 2. topColor overlay with opacity
            Container(
              color: topColor.withOpacity(0.9), // adjust 0.0 - 1.0
            ),
            SafeArea(
              child: Consumer(builder: (context, ref, _) {
                final connectivityStatus =
                    ref.watch(connectivityStreamProvider);

                return connectivityStatus.when(
                  data: (status) {
                    if (status == ConnectivityStatus.offline) {
                      return _buildOfflineContent();
                    }
                    return _buildLoadingContent();
                  },
                  loading: () => _buildLoadingContent(),
                  error: (error, stack) => _buildLoadingContent(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineContent() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 240,
              height: 240,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/kstu_src_logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ).appPopIn(duration: AppMotion.slow),
            const SizedBox(height: 20),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                "Students Representative Council KsTU",
                style: GoogleFonts.poppins(
                  color: bottomColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ).appEntrance(delay: const Duration(milliseconds: 300)),
            const Spacer(),
            Center(
              child: Text(
                "No internet connection",
                style: GoogleFonts.poppins(
                  color: bottomColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ).appEntrance(delay: const Duration(milliseconds: 420)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/kstu_src_logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ).appPopIn(duration: AppMotion.slow),
            const SizedBox(height: 20),
            const Spacer(),
            Column(
              spacing: 12,
              children: [
                CircularProgressIndicator(
                  color: bottomColor,
                  strokeWidth: 5,
                ),
                RandomQouteGenerator(),
                Text(
                  textAlign: TextAlign.center,
                  "KsTU Students Representative Council",
                  style: GoogleFonts.poppins(
                    color: bottomColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ).appEntrance(delay: const Duration(milliseconds: 350)),
          ],
        ),
      ),
    );
  }
}
