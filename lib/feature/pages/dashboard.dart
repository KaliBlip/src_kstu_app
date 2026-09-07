import 'package:src_kstu_app/components/side_menu.dart';
import 'package:src_kstu_app/services/connectivity_provider.dart';
import 'package:src_kstu_app/feature/pages/news_details.dart';
import 'package:src_kstu_app/feature/pages/notice_board_shimmer.dart';
import 'package:src_kstu_app/feature/pages/notice_board.dart';
import 'package:src_kstu_app/feature/pages/trending_shimmer.dart';
import 'package:src_kstu_app/feature/pages/user_profile.dart';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/notice_board.dart';
import 'package:src_kstu_app/components/trending_component.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src_kstu_app/services/trending_news.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:src_kstu_app/feature/pages/error_pages/no_internet.dart';

import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

// Make some changes /  Push to github on Date: 04/06/2023 Time:03:55am

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

// test
class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  var name;
  var index;
  var image;
  var id;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;
  bool isLoading = false;

  // final trendingScrollController = ScrollController();
  @override
  initState() {
    _checkConnectivity();
    // requestNotificationPermission_();
    ConnectivityProvider();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    getUser();
    // listenForPushNotifications(context);

    // pagination logic
    super.initState();
    // trendingScrollController.addListener(() {
    //   if (trendingScrollController.position.maxScrollExtent ==
    //       trendingScrollController.offset) {
    //     // checking if end of list is
    //   }
    // });
  }

  Future<void> _checkConnectivity() async {
    // final ConnectivityResult result = await Connectivity().checkConnectivity();
    // _connectivityProvider.updateConnectionStatus(result);
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool isSideBarClosed = true;
  bool isSideMenuClosed = true;

  void getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      name = localStorage.getString('name');
      index = localStorage.getInt('index');
      image = localStorage.getString('user_img');
      id = localStorage.getInt('id');
    });
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
  //         registerUserForPushNotification();
  //         return;
  //       }
  //     });
  //   } else {
  //     registerUserForPushNotification();
  //   }
  // }

  // void registerUserForPushNotification() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();

  //   var user_id = localStorage.getInt('userId');
  //   print("in dashboard!: ${user_id}");

  //   var myCustomUniqueUserId = "${user_id}";
  //   //await OneSignal.shared.removeExternalUserId();
  //   final setExtPushIdResponse =
  //       await OneSignal.shared.setExternalUserId(myCustomUniqueUserId);
  //   debugPrint(
  //       "setExtPushIdResponse: $setExtPushIdResponse :: newDeviceId: $myCustomUniqueUserId");

  //   if (setExtPushIdResponse['push']['success'] != null) {
  //     if (setExtPushIdResponse['push']['success'] is bool) {
  //       final status = setExtPushIdResponse['push']['success'] as bool;
  //       // if (status) {
  //       //   ShowwcaseStorage.setPushRegistrationStatus = "registered";
  //       // }
  //     } else if (setExtPushIdResponse['push']['success'] is int) {
  //       final status = setExtPushIdResponse['push']['success'] as int;
  //       // if (status == 1) {
  //       //   ShowwcaseStorage.setPushRegistrationStatus = "registered";
  //       // }
  //     }
  //     debugPrint(
  //         "registered for push: ${setExtPushIdResponse['push']['success']}");
  //   }
  // }

// HANDING APP NOTIFICATIONS
  // void listenForPushNotifications(BuildContext context) {
  //   // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //   //   final data = result.notification.additionalData;
  //   //   final announcemet_id = data!['announcemet_id'];
  //   //   debugPrint("background notification announcemet_id $announcemet_id.");
  //   //   Navigator.push(
  //   //     context,
  //   //     MaterialPageRoute(
  //   //       builder: (context) => DetailNews(title: announcemet_id),
  //   //     ),
  //   //   );
  //   // });

  //   OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //     (OSNotificationReceivedEvent notification) async {
  //       // if (notification.notification.clicke) {

  //       final data = notification.notification.additionalData;
  //       final announcemet_id = data!['announcemet_id'];
  //       OneSignal.shared
  //           .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //         // print('"OneSignal: notification opened: ${result}');
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => DetailNews(title: announcemet_id),
  //           ),
  //         );
  //       });

  //       // }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    final noticeProvider =
        Provider.of<NoticeBoardProvider>(context, listen: false);
    final trendProvider =
        Provider.of<TrendingNewsProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: topColor,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: topColor,
          title: Semantics(
            label: "AppBar Content",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${name}",
                  style: TextStyle(
                      color: bottomColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${index}",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
          ),
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                    margin: EdgeInsets.only(left: 16, top: 17),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 3),
                              blurRadius: 8)
                        ]),
                    child: Icon(Icons.menu)),
              );
            }
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                _dialog.show(
                    message: 'Waiting...',
                    type: SimpleFontelicoProgressDialogType.hurricane);
                await Future.delayed(Duration(seconds: 1));
                _dialog.hide();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 18, right: 15),
                child: Stack(
                  children: [
                    CircleAvatar(
                      maxRadius: 24,
                      minRadius: 24,
                      backgroundColor: bottomColor,
                      backgroundImage: image != "1"
                          ? NetworkImage("${user_img_uri}${image}")
                          : NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        minRadius: 7,
                        maxRadius: 7,
                        backgroundColor: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        drawer: SideMenu(),
        body: Semantics(
          label: "Dashboard Page",
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: topColor,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Consumer<ConnectivityProvider>(
                                  builder: (context, provider, _) {
                                if (provider.status ==
                                    ConnectivityStatus.Offline) {
                                  //
                                  return Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height -
                                              250,
                                      decoration: BoxDecoration(
                                          color: bottomColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30))),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 18.0),
                                          child: Container(
                                            width: double.infinity,
                                            // height: 300,
                                            decoration: BoxDecoration(
                                              color: topColor,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              image: DecorationImage(
                                                image: ExactAssetImage(
                                                    'assets/images/wayera.png'),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment: Alignment.center,
                                                  height: 200,
                                                  // color:Colors.red,
                                                  child: Text(
                                                    'Aww snap, no internet connection!',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )));
                                } else {
                                  return Container(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height - 50,
                                    decoration: const BoxDecoration(
                                        color: bottomColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(30))),
                                    child: NestedScrollView(
                                        scrollDirection: Axis.vertical,
                                        physics: BouncingScrollPhysics(),
                                        dragStartBehavior:
                                            DragStartBehavior.start,
                                        headerSliverBuilder:
                                            (context, innerBoxIsScrolled) {
                                          return [];
                                        },
                                        body: ListView(
                                          scrollDirection: Axis.vertical,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 15.0),
                                              child: Text(
                                                "Notice Board",
                                                style: TextStyle(
                                                    color: topColor,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            FutureBuilder<List<Announcement>>(
                                              future:
                                                  noticeProvider.fetchNotice(1),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0),
                                                      child: Container(
                                                          height: 243,
                                                          child:
                                                              NoticeBoardShimmer()));
                                                } else if (snapshot.hasError) {
                                                  return Center();
                                                } else {
                                                  final noticeboard =
                                                      snapshot.data!;
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0),
                                                    child: Container(
                                                      height: 250,
                                                      child: ListView.builder(
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemCount:
                                                            noticeboard.length +
                                                                1,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return index !=
                                                                  noticeboard
                                                                      .length
                                                              ? GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    _dialog.show(
                                                                        message:
                                                                            'Waiting...',
                                                                        type: SimpleFontelicoProgressDialogType
                                                                            .hurricane);
                                                                    await Future.delayed(Duration(
                                                                        seconds:
                                                                            1));
                                                                    _dialog
                                                                        .hide();
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: ((context) =>
                                                                                DetailNews(title: noticeboard[index].id))));
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      right:
                                                                          15.0,
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          160,
                                                                      height:
                                                                          150,
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              topColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Column(
                                                                          // mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: double.infinity,
                                                                              height: 130,
                                                                              //
                                                                              // ignore: unnecessary_null_comparison
                                                                              decoration: BoxDecoration(image: noticeboard[index].featuredImage != null ? DecorationImage(image: NetworkImage("${announcement_imgUri}${noticeboard[index].featuredImage}"), fit: BoxFit.fill) : DecorationImage(image: NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"), fit: BoxFit.fill), color: topColor, borderRadius: BorderRadius.circular(10)),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text(
                                                                              "${noticeboard[index].title.trim()}",
                                                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.5),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Text(
                                                                              "${noticeboard[index].createdAtFormatted.split(', ')[1]}",
                                                                              style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.fade,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : noticeboard
                                                                          .length >=
                                                                      10
                                                                  ? Container(
                                                                      width: 50,
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          DecoratedBox(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                topColor,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.of(context).push(
                                                                              MaterialPageRoute(builder: (context) => AllNoticeBoardPage()),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                const Icon(
                                                                              Icons.arrow_forward_ios,
                                                                              color: topColor,
                                                                              size: 25,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container();
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            const SizedBox(
                                              height: 18,
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.0,
                                                  horizontal: 10.0),
                                              child: Text(
                                                "What's trending?",
                                                style: TextStyle(
                                                    color: topColor,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FutureBuilder<List<Announcement>>(
                                              // initialData: [],
                                              future:
                                                  trendProvider.fetchTrend(1),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return TrendingShimmer();
                                                } else if (snapshot.hasError) {
                                                  // logout()
                                                  //     .then((value) => {
                                                  //           Navigator.of(context).pushAndRemoveUntil(
                                                  //               MaterialPageRoute(
                                                  //                   builder: (context) =>
                                                  //                       LoginPage()),
                                                  //               (route) =>
                                                  //                   false)
                                                  //         });
                                                  return noInternet();
                                                } else {
                                                  final trend = snapshot.data!;

                                                  return TrendingComponent(
                                                      gottenData: trend,
                                                      showRefresh: false,
                                                      page: 2,
                                                      hasLimit: true,
                                                      isTrending: true);
                                                }
                                              },
                                            )
                                          ],
                                        )),
                                  );
                                }
                              }),
                            ),
                          ],
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class HeadPicture extends StatelessWidget {
  const HeadPicture({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => UserProfilePage()));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: const [
            CircleAvatar(
              maxRadius: 24,
              minRadius: 24,
              backgroundColor: bottomColor,
              backgroundImage: AssetImage("assets/images/student_profile.jpeg"),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                minRadius: 7,
                maxRadius: 7,
                backgroundColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
