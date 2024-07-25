import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/pages/about_page.dart';
import 'package:src_kstu_app/feature/pages/campus_map.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/login_page.dart';
import 'package:src_kstu_app/feature/pages/notice_board.dart';
import 'package:src_kstu_app/feature/pages/trending_news.dart';
import 'package:src_kstu_app/feature/pages/update_password_page.dart';
import 'package:accordion/accordion.dart';
import 'package:src_kstu_app/components/info_card.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  var name;
  var indexNo;
  var image;

  void getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      name = localStorage.getString('name');
      indexNo = localStorage.getInt('index');
      image = localStorage.getString('user_img');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  Future<void> launchToVclass() async {
    await launch("https://vclass.kstu.edu.gh");
  }

  Future<void> launchToPortal() async {
    await launch(
      'https://portal.kstu.edu.gh/students/login',
    );
  }

  Future<void> launchToSite() async {
    await launch(
      'https://kstu.edu.gh/',
    );
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    return Container(
      width: 288,
      height: double.infinity,
      decoration: BoxDecoration(
          color: topColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InfoCard(
                name: "${name}",
                indexNo: "${indexNo}",
                image: image,
              ),
              SizedBox(
                height: 40,
              ),
              SideMenuTitle(
                iconData: CupertinoIcons.home,
                title: Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                myfunction: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Divider(
                  color: Colors.white24,
                  height: 1,
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Accordion(
                      paddingListTop: 10,
                      paddingListBottom: 10,
                      maxOpenSections: 1,
                      contentBackgroundColor: topColor,
                      headerBackgroundColor: topColor,
                      scaleWhenAnimating: true,
                      openAndCloseAnimation: true,
                      headerBorderColor: topColor,
                      contentBorderColor: topColor,
                      contentBorderWidth: 0,
                      children: [
                        AccordionSection(
                          isOpen: false,
                          leftIcon: const Icon(
                            CupertinoIcons.map_pin_ellipse,
                            color: Colors.white,
                            size: 25,
                          ),
                          header: const Text('Campus Map',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CampusMap(
                                                url: mainCampusMapUrl,
                                                title: 'Main Campus',
                                              )));
                                },
                                leading: Icon(
                                  CupertinoIcons.building_2_fill,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                title: Text("Main Campus",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                              Divider(
                                color: Colors.white24,
                                height: 1,
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CampusMap(
                                                url: adakoMapUrl,
                                                title: 'Adako Jachie Campus',
                                              )));
                                },
                                leading: Icon(
                                  CupertinoIcons.building_2_fill,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                title: Text("Adako Campus",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              ),
                            ],
                          ),
                          contentBorderColor: topColor,
                          contentBackgroundColor: topColor,
                          contentBorderWidth: 0,
                        ),
                      ]),
                ),
              ),
              SideMenuTitle(
                iconData: CupertinoIcons.shield_lefthalf_fill,
                title: Text(
                  "Notice Board",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                myfunction: () async {
                  _dialog.show(
                      message: 'Waiting...',
                      type: SimpleFontelicoProgressDialogType.hurricane);
                  await Future.delayed(Duration(seconds: 1));
                  _dialog.hide();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllNoticeBoardPage()));
                },
              ),
              SideMenuTitle(
                iconData: CupertinoIcons.sun_haze_fill,
                title: Text(
                  "Trending News",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                myfunction: () async {
                  _dialog.show(
                      message: 'Waiting...',
                      type: SimpleFontelicoProgressDialogType.hurricane);
                  await Future.delayed(Duration(seconds: 1));
                  _dialog.hide();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TrendingNewsPage()));
                },
              ),
              SideMenuTitle(
                  iconData: CupertinoIcons.globe,
                  title: Text(
                    "Kstu V-class",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  myfunction: launchToVclass),
              SideMenuTitle(
                  iconData: CupertinoIcons.cube_box_fill,
                  title: Text(
                    "Kstu Portal",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  myfunction: launchToPortal),
              SideMenuTitle(
                  iconData: CupertinoIcons.cube_box,
                  title: Text(
                    "Kstu Site",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  myfunction: launchToSite),
              SideMenuTitle(
                iconData: CupertinoIcons.piano,
                title: Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                myfunction: () async {
                  _dialog.show(
                      message: 'waiting...',
                      type: SimpleFontelicoProgressDialogType.hurricane);
                  await Future.delayed(Duration(seconds: 1));
                  _dialog.hide();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdatePasswordPage()));
                },
              ),
              SideMenuTitle(
                iconData: CupertinoIcons.question_circle,
                title: Text(
                  "About",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                myfunction: () async {
                  _dialog.show(
                      message: 'waiting...',
                      type: SimpleFontelicoProgressDialogType.hurricane);
                  await Future.delayed(Duration(seconds: 1));
                  _dialog.hide();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              ),
              SizedBox(
                height: 70,
              ),
              SideMenuTitle(
                iconData: CupertinoIcons.tray_arrow_up_fill,
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                isLast: true,
                myfunction: () async {
                  _dialog.show(
                      message: 'Logging out...',
                      type: SimpleFontelicoProgressDialogType.hurricane);
                  await Future.delayed(Duration(seconds: 1));
                  _dialog.hide();
                  logout().then((value) => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false)
                      });
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SideMenuTitle extends StatelessWidget {
  SideMenuTitle(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.myfunction,
      this.isLast = false})
      : super(key: key);
  Text title;
  IconData iconData;
  VoidCallback myfunction;
  bool isLast;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: isLast
              ? null
              : Divider(
                  color: Colors.white24,
                  height: 1,
                ),
        ),
        Stack(
          children: [
            ListTile(
                onTap: myfunction,
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                title: title),
          ],
        ),
      ],
    );
  }
}
