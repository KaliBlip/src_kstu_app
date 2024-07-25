import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/services/connectivity_provider.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/forgot_password.dart';
import 'package:src_kstu_app/models/api_response.dart';
import 'package:src_kstu_app/models/user.dart';
import 'package:src_kstu_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// 052141350070  SHANI IDDI
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool ispassword = true;
  double isOnTap = 50;
  int reduceConatiner = 4;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, Function() runthis) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK,cool am all in!"),
      onPressed: runthis,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Receive notification alerts"),
      content: Text(
          'This app would like to send you push notifications when there is any activity on campus'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void requestNotificationPermission_() async {
    // open prompt for user to enable notification
    PermissionStatus permissionStatus =
        await NotificationPermissions.getNotificationPermissionStatus();
    // if(permissionStatus == PermissionStatus.denied) {
    //   // if user explicitly denied notifications, we don't want to show them again
    //   return;
    // }

    if (permissionStatus != PermissionStatus.granted) {
      if (!mounted) return;

      // showConfirmDialog(context, title: 'Receive notification alerts',
      //   subtitle: 'This app would like to send you push notifications when there is any activity on your account',
      //   onConfirmTapped: () async {
      //     }
      //   },
      // );
      showAlertDialog(context, () async {
        final requestResponse =
            await NotificationPermissions.requestNotificationPermissions();
        if (requestResponse == PermissionStatus.granted) {
          // user granted permission
          registerUserForPushNotification();
          return;
        }
      });
    } else {
      registerUserForPushNotification();
    }
  }

  void registerUserForPushNotification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var user_id = localStorage.getInt('id');
    print("in dashboard!: ${user_id}");

    var myCustomUniqueUserId = "${user_id}";
    //await OneSignal.shared.removeExternalUserId();
    final setExtPushIdResponse =
        await OneSignal.shared.setExternalUserId(myCustomUniqueUserId);
    debugPrint(
        "setExtPushIdResponse: $setExtPushIdResponse :: newDeviceId: $myCustomUniqueUserId");

    if (setExtPushIdResponse['push']['success'] != null) {
      if (setExtPushIdResponse['push']['success'] is bool) {
        // ignore: unused_local_variable
        final status = setExtPushIdResponse['push']['success'] as bool;
        // if (status) {
        //   ShowwcaseStorage.setPushRegistrationStatus = "registered";
        // }
      } else if (setExtPushIdResponse['push']['success'] is int) {
        // ignore: unused_local_variable
        final status = setExtPushIdResponse['push']['success'] as int;
        // if (status == 1) {
        //   ShowwcaseStorage.setPushRegistrationStatus = "registered";
        // }
      }
      debugPrint(
          "registered for push: ${setExtPushIdResponse['push']['success']}");
    }
  }

  void _loginUser() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    ApiResponse response =
        await login(emailController.text, passwordController.text);
    if (response.error == null) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        _saveAndRedirectToDashboard(response.data as User);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please connect to the internet'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          elevation: 2.0,
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: Colors.white,
            textColor: Colors.yellow,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ));
      }
    } else {
      // print(jsonEncode(response.data));
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
        backgroundColor: Colors.red.shade700,
        elevation: 2.0,
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
    }
  }

  void _saveAndRedirectToDashboard(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", user.token ?? '');
    await prefs.setInt("id", user.id ?? 0);

    await prefs.setString("name", user.name ?? '');
    await prefs.setInt("index", user.indexNo ?? 0);
    await prefs.setString("gender", user.gender ?? '');
    await prefs.setString("level", user.currentLevel ?? '');
    await prefs.setString("user_img", user.userImg ?? '');
    await prefs.setBool('hasOpended', true);
    //determine  if app has been opened before

    // await prefs.setString("semester", user.currentSemester ?? '');
    // semester has been changed from styring to id,so we may need to create a new field to handle the semester relastion,leave it as 0 for now
    await prefs.setInt("semester", user.currentSem ?? 0);
    await prefs.setString("program", user.programName ?? "");
    await prefs.setString("department", user.deptName ?? "");
    await prefs.setString("faculty", user.facultyName ?? "");
    await prefs.setString("phone", user.phone ?? "");
    await prefs.setString("email", user.email ?? '');
    await prefs.setString("image", user.userImg ?? '');
    await prefs.setString("yrOfAdmission", user.yrOfAdmission ?? '');
    await prefs.setString("yrOfCompletion", user.yrOfCompletion ?? '');
    // await prefs.setInt("userId", user.id ?? 0);
    requestNotificationPermission_();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()), (route) => false);
    var name = await prefs.getString('name');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Welcome, ${name}'),
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
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        setState(() {
          isOnTap = 50;
          reduceConatiner = 4;
        });
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            isOnTap = 50;
            reduceConatiner = 4;
          });
        },
        child: Scaffold(
            backgroundColor: topColor,
            resizeToAvoidBottomInset: false,
            body: Semantics(
              label: "Login Page",
              child: SafeArea(
                child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                            height:double.infinity,
                            child: Stack(children: [
                              Row(children: [
                                Container(
                                  color: bottomColor,
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                                Container(
                                  color: topColor,
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                              ]),
                              Consumer<ConnectivityProvider>(
                                  builder: (context, provider, _) {
                                if (provider.status ==
                                    ConnectivityStatus.Offline) {
                                  SnackBar(
                                      content: Text("No internet connection"),
                                      backgroundColor: topColor,
                                      behavior: SnackBarBehavior.floating,
                                      action: SnackBarAction(
                                        label: 'Dismiss',
                                        disabledTextColor: Colors.white,
                                        textColor: Colors.yellow,
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                        },
                                      ));
                                  return Column(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: const BoxDecoration(
                                                color: topColor,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(30))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 200,
                                                  child: Image.asset(
                                                    "assets/images/f.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 25,
                                                ),
                                                const Text(
                                                  "No internet connection",
                                                  style: TextStyle(
                                                      color: bottomColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 30),
                                                )
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: bottomColor,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(30))),
                                            child: Column(children: [
                                              Spacer(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 18.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      color: topColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Center(
                                                    child: Text(
                                                      "No internet connection",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                            ]),
                                          ))
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            decoration: const BoxDecoration(
                                                color: topColor,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(30))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 150,
                                                  child: Image.asset(
                                                    "assets/images/f.png",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                                const Text(
                                                  "SIGN IN",
                                                  style: TextStyle(
                                                      color: bottomColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 30),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Expanded(
                                          flex: reduceConatiner,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: bottomColor,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(30))),
                                            child: Form(
                                              key: formkey,
                                              child: Column(children: [
                                                SizedBox(
                                                  height: isOnTap,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 18.0,
                                                          vertical: 10),
                                                  child: TextFormField(
                                                    onTap: () {
                                                      setState(() {
                                                        isOnTap = 20;
                                                        reduceConatiner = 6;
                                                      });
                                                    },
                                                    validator: ((value) {
                                                      if (value!.isEmpty) {
                                                        return "Email field is required";
                                                      }
                                                      return null;
                                                    }),
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    controller: emailController,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      label: Text("Email"),
                                                      hintText: '',
                                                      prefixIcon:
                                                          Icon(Icons.email),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 18.0,
                                                          vertical: 10),
                                                  child: TextFormField(
                                                    onTap: () {
                                                      isOnTap = 20;
                                                      reduceConatiner = 6;
                                                    },
                                                    validator: ((value) {
                                                      if (value!.isEmpty) {
                                                        return "Password field is required";
                                                      }
                                                      return null;
                                                    }),
                                                    keyboardType: TextInputType
                                                        .visiblePassword,
                                                    controller:
                                                        passwordController,
                                                    obscureText: ispassword,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      label: Text("Password"),
                                                      hintText: '',
                                                      prefixIcon:
                                                          Icon(Icons.lock),
                                                      suffixIcon: IconButton(
                                                        icon: Icon(ispassword
                                                            ? Icons.visibility_off
                                                            : Icons.visibility),
                                                        onPressed: () {
                                                          setState(() {
                                                            ispassword =
                                                                !ispassword;
                                                          });
                                                        },
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 18.0),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      _dialog.show(
                                                          message: 'Waiting...',
                                                          type:
                                                              SimpleFontelicoProgressDialogType
                                                                  .hurricane);
                                                      await Future.delayed(
                                                          Duration(seconds: 1));
                                                      _dialog.hide();
                                                      if (formkey.currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          loading = true;
                                                          _loginUser();
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                          color: topColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10)),
                                                      child: Center(
                                                        child: loading
                                                            ? SpinKitFadingCircle(
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return DecoratedBox(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: index
                                                                              .isEven
                                                                          ? bottomColor
                                                                          : bottomColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                  );
                                                                },
                                                                size: 40,
                                                              )
                                                            : Text(
                                                                "SIGN IN",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5,),
                                                Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Align widgets to the right
                        children: [
              GestureDetector(
                onTap: () async {
                  // Show loading dialog
                  _dialog.show(
                    message: 'Waiting...',
                    type: SimpleFontelicoProgressDialogType.hurricane,
                  );
                  await Future.delayed(Duration(seconds: 1));
                  _dialog.hide();
              
                  // Navigate to ForgotPasswordPage and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    (route) => false,
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: topColor,
                  ),
                ),
              ),
              SizedBox(width: 16), // Optional spacing between elements
                        ],
                      ),
                    ),
                                              ]),
                                            ),
                                          ))
                                    ],
                                  );
                                }
                              })
                            ])))),
              ),
            )),
      ),
    );
  }
}
