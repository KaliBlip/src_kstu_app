import 'dart:async';

import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/services/connectivity_provider.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/login_page.dart';
import 'package:src_kstu_app/feature/pages/on-boarding/onboarding-parent.dart';
import 'package:src_kstu_app/feature/pages/welcome_screen.dart';
import 'package:src_kstu_app/models/api_response.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'news_details.dart';
import 'package:notification_permissions/notification_permissions.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
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
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Welcome back, ${name}'),
            backgroundColor: topColor,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ));
        } else if (response.error == unauthorized) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You have been logged out"),
            backgroundColor: topColor,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("${response.error}")));
          // print(response.error);
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
    Timer(Duration(seconds: 4), _loadUserInfo);
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
          child: SafeArea(
            child:
                Consumer<ConnectivityProvider>(builder: (context, provider, _) {
              if (provider.status == ConnectivityStatus.Offline) {
                SnackBar(
                    content: Text("No internet connection"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'Dismiss',
                      disabledTextColor: Colors.white,
                      textColor: Colors.yellow,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ));
                return Container(
  height: MediaQuery.of(context).size.height,
  width: MediaQuery.of(context).size.width,
  color: topColor,
  child: Padding(
    padding: const EdgeInsets.all(18.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/f.png"),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Center(
          child: Text(
          textAlign: TextAlign.center,

            "Students Representative Council KsTU",
            style: TextStyle(
              color: bottomColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Spacer(),
        const Center(
          child: Text(
            "No internet connection",
            style: TextStyle(
              color: bottomColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
  ),
);

              } else {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: topColor,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/f.png"),
                                  fit: BoxFit.contain)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          textAlign: TextAlign.center,
                          "Students Representative Council KsTU",
                          style: TextStyle(
                              color: bottomColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Spacer(),
                        SpinKitFadingCircle(
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: index.isEven ? bottomColor : bottomColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          },
                          size: 60,
                        ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
        ));
  }
}