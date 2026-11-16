import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/components/app_snackbar.dart';
import 'package:src_kstu_app/feature/pages/apply_claims_page.dart';
import 'package:src_kstu_app/feature/pages/check_claim_status_page.dart';
import 'package:src_kstu_app/feature/pages/download_claims_forms_page.dart';
import 'package:src_kstu_app/feature/pages/download_scholarship_forms_page.dart';
import 'package:src_kstu_app/feature/pages/about_page.dart';
import 'package:src_kstu_app/feature/pages/apply_scholarship_page.dart';
import 'package:src_kstu_app/feature/pages/campus_map.dart';
import 'package:src_kstu_app/feature/pages/check_scholarship_status.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:src_kstu_app/components/app_animations.dart';

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
    getUser();
    super.initState();
  }

  Future<void> launchToVclass() async {
    await launchUrl(
      Uri.parse("https://vclass.kstu.edu.gh"),
    );
  }

  Future<void> launchToPortal() async {
    await launchUrl(
      Uri.parse('https://student.kstu.edu.gh/login'),
    );
  }

  Future<void> launchToSite() async {
    await launchUrl(
      Uri.parse('https://kstu.edu.gh/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog dialog =
        SimpleFontelicoProgressDialog(context: context);
    return Container(
      width: 288,
      height: double.infinity,
      decoration: BoxDecoration(
        color: topColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            InfoCard(
              name: "$name",
              indexNo: "$indexNo",
              image: image,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SideMenuTitle(
                      iconData: CupertinoIcons.home,
                      title: Text(
                        "Dashboard",
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 20),
                      ),
                      myfunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                      ),
                    ),
                    SizedBox(
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
                              header: Text('Campus Map',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 20)),
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
                                        style: GoogleFonts.roboto(
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
                                                    title:
                                                        'Adako Jachie Campus',
                                                  )));
                                    },
                                    leading: Icon(
                                      CupertinoIcons.building_2_fill,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text("Adako Campus",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 18)),
                                  ),
                                ],
                              ),
                              contentBorderColor: topColor,
                              contentBackgroundColor: topColor,
                              contentBorderWidth: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SideMenuTitle(
                      iconData: CupertinoIcons.shield_lefthalf_fill,
                      title: Text(
                        "Notice Board",
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 20),
                      ),
                      myfunction: () async {
                        dialog.show(
                            message: 'Waiting...',
                            type: SimpleFontelicoProgressDialogType.hurricane);
                        await Future.delayed(Duration(seconds: 1));
                        dialog.hide();
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
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 20),
                      ),
                      myfunction: () async {
                        dialog.show(
                            message: 'Waiting...',
                            type: SimpleFontelicoProgressDialogType.hurricane);
                        await Future.delayed(Duration(seconds: 1));
                        dialog.hide();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrendingNewsPage()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                      ),
                    ),
                    SizedBox(
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
                                Icons.school,
                                color: Colors.white,
                                size: 25,
                              ),
                              header: Text('Scholarships',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 20)),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DownloadScholarshipFormsPage(),
                                        ),
                                      );
                                    },
                                    leading: Icon(
                                      CupertinoIcons.download_circle,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text("Download",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 16)),
                                    subtitle: Text(
                                      "Download the scholarship forms and apply",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white70, fontSize: 11),
                                    ),
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
                                          builder: (context) =>
                                              ApplyScholarshipPage(),
                                        ),
                                      );
                                    },
                                    leading: Icon(
                                      CupertinoIcons.plus_app_fill,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text("Apply Scholarship",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 16)),
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
                                          builder: (context) =>
                                              CheckScholarshipStatus(),
                                        ),
                                      );
                                    },
                                    leading: Icon(
                                      CupertinoIcons.check_mark_circled,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text("Check Scholarship",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 16)),
                                    subtitle: Text(
                                      "Status",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              contentBorderColor: topColor,
                              contentBackgroundColor: topColor,
                              contentBorderWidth: 0,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                      ),
                    ),
                    SizedBox(
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
                                Icons.science,
                                color: Colors.white,
                                size: 25,
                              ),
                              header: Text('Insurance Claims',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 20)),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DownloadClaimsFormsPage(),
                                        ),
                                      );
                                    },
                                    leading: Icon(
                                      CupertinoIcons.download_circle,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text("Download",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 16)),
                                    subtitle: Text(
                                      "Download the insurance claim forms and apply",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white70, fontSize: 11),
                                    ),
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
                                          builder: (context) =>
                                              ApplyClaimsPage(),
                                        ),
                                      );
                                    },
                                    leading: Icon(
                                      CupertinoIcons.plus_app_fill,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text("Apply for Insurance",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 16)),
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
                                          builder: (context) =>
                                              CheckClaimStatusPage(),
                                        ),
                                      );
                                    },
                                    leading: Icon(
                                      CupertinoIcons.check_mark_circled,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    title: Text("Check Insurance",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white, fontSize: 16)),
                                    subtitle: Text(
                                      "Status",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              contentBorderColor: topColor,
                              contentBackgroundColor: topColor,
                              contentBorderWidth: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SideMenuTitle(
                        iconData: CupertinoIcons.cube_box_fill,
                        title: Text(
                          "Kstu Portal",
                          style: GoogleFonts.roboto(
                              color: Colors.white, fontSize: 20),
                        ),
                        myfunction: launchToPortal),
                    SideMenuTitle(
                        iconData: CupertinoIcons.cube_box,
                        title: Text(
                          "Kstu Site",
                          style: GoogleFonts.roboto(
                              color: Colors.white, fontSize: 20),
                        ),
                        myfunction: launchToSite),
                    SideMenuTitle(
                        iconData: CupertinoIcons.suit_club,
                        title: Text(
                          "Kstu V-Class",
                          style: GoogleFonts.roboto(
                              color: Colors.white, fontSize: 20),
                        ),
                        myfunction: launchToVclass),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Divider(
                        color: Colors.white24,
                        height: 1,
                      ),
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 14),
                    //     child: Accordion(
                    //       paddingListTop: 10,
                    //       paddingListBottom: 10,
                    //       maxOpenSections: 1,
                    //       contentBackgroundColor: topColor,
                    //       headerBackgroundColor: topColor,
                    //       scaleWhenAnimating: true,
                    //       openAndCloseAnimation: true,
                    //       headerBorderColor: topColor,
                    //       contentBorderColor: topColor,
                    //       contentBorderWidth: 0,
                    //       children: [
                    //         AccordionSection(
                    //           isOpen: false,
                    //           leftIcon: const Icon(
                    //             CupertinoIcons.archivebox,
                    //             color: Colors.white,
                    //             size: 25,
                    //           ),
                    //           header: Text('Academic Archives',
                    //               style: GoogleFonts.roboto(
                    //                   color: Colors.white, fontSize: 20)),
                    //           content: Column(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               ListTile(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) =>
                    //                           AcademicCalendarPage(),
                    //                     ),
                    //                   );
                    //                 },
                    //                 leading: Icon(
                    //                   CupertinoIcons.calendar_badge_plus,
                    //                   color: Colors.white,
                    //                   size: 18,
                    //                 ),
                    //                 title: Text("Academic Calendar",
                    //                     style: GoogleFonts.roboto(
                    //                         color: Colors.white, fontSize: 16)),
                    //               ),
                    //               Divider(
                    //                 color: Colors.white24,
                    //                 height: 1,
                    //               ),
                    //               ListTile(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) => ExamTimetablePage(),
                    //                     ),
                    //                   );
                    //                 },
                    //                 leading: Icon(
                    //                   CupertinoIcons.timer,
                    //                   color: Colors.white,
                    //                   size: 18,
                    //                 ),
                    //                 title: Text("Exam Timetable",
                    //                     style: GoogleFonts.roboto(
                    //                         color: Colors.white, fontSize: 16)),
                    //               ),
                    //               Divider(
                    //                 color: Colors.white24,
                    //                 height: 1,
                    //               ),
                    //               ListTile(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) => ConstitutionPage(),
                    //                     ),
                    //                   );
                    //                 },
                    //                 leading: Icon(
                    //                   CupertinoIcons.conversation_bubble,
                    //                   color: Colors.white,
                    //                   size: 18,
                    //                 ),
                    //                 title: Text("KsTU/SRC",
                    //                     style: GoogleFonts.roboto(
                    //                         color: Colors.white, fontSize: 16)),
                    //                 subtitle: Text(
                    //                   "Constitution",
                    //                   style: GoogleFonts.roboto(
                    //                       color: Colors.white70, fontSize: 14),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           contentBorderColor: topColor,
                    //           contentBackgroundColor: topColor,
                    //           contentBorderWidth: 0,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SideMenuTitle(
                      iconData: CupertinoIcons.piano,
                      title: Text(
                        "Change Password",
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 20),
                      ),
                      myfunction: () async {
                        dialog.show(
                            message: 'waiting...',
                            type: SimpleFontelicoProgressDialogType.hurricane);
                        await Future.delayed(Duration(seconds: 1));
                        dialog.hide();
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
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 20),
                      ),
                      myfunction: () async {
                        dialog.show(
                            message: 'waiting...',
                            type: SimpleFontelicoProgressDialogType.hurricane);
                        await Future.delayed(Duration(seconds: 1));
                        dialog.hide();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _SocialPanel(),
            const SizedBox(height: 8),
            Container(height: 1, color: Colors.white.withOpacity(.22)),
            const SizedBox(height: 4),
            SideMenuTitle(
              iconData: CupertinoIcons.tray_arrow_up_fill,
              title: Text(
                "Logout",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 20),
              ),
              isLast: true,
              myfunction: () async {
                dialog.show(
                    message: 'Logging out...',
                    type: SimpleFontelicoProgressDialogType.hurricane);
                await Future.delayed(Duration(seconds: 1));
                dialog.hide();
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false)
                    });
                showAppSnackBar(
                  message: "You have been logged out",
                  backgroundColor: topColor,
                );
              },
            ),
          ].appStaggered(),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SideMenuTitle extends StatelessWidget {
  SideMenuTitle(
      {super.key,
      required this.iconData,
      required this.title,
      required this.myfunction,
      this.isLast = false});
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

class _SocialPanel extends StatefulWidget {
  const _SocialPanel();

  @override
  State<_SocialPanel> createState() => _SocialPanelState();
}

class _SocialPanelState extends State<_SocialPanel> {
  Future<void> launchToTitok() async {
    await launchUrl(
      Uri.parse("https://www.tiktok.com/@src.kstu?_r=1&_t=ZS-9BN4z3cJuxq"),
    );
  }

  Future<void> launchToInstagram() async {
    await launchUrl(
      Uri.parse(
          "https://www.instagram.com/src_kstu?rpxt=Mjh2eXR3Z2Z2c24z&utm_source=qr"),
    );
  }

  Future<void> launchToFacebook() async {
    await launchUrl(
      Uri.parse(
          "https://www.facebook.com/profile.php?id=61593941234286&mibextid=wwXIfr&mibextid=wwXIfr"),
    );
  }

  Future<void> launchToX() async {
    await launchUrl(
      Uri.parse("https://x.com/src_kstu?s=11"),
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
        // decoration: BoxDecoration(
        //   color: const Color(0xFF382080).withOpacity(.55),
        //   borderRadius: BorderRadius.circular(18),
        //   border: Border.all(color: Colors.white.withOpacity(.06)),
        // ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                        height: 1, color: Colors.white.withOpacity(.35))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'FOLLOW US',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .4),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.white.withOpacity(.35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: launchToTitok,
                  child: _SocialCircle(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        '♪',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: launchToInstagram,
                  child: _SocialCircle(
                    color: Color(0xFFE1306C),
                    child: Icon(Icons.camera_alt_outlined,
                        color: Colors.white, size: 23),
                  ),
                ),
                InkWell(
                  onTap: launchToX,
                  child: _SocialCircle(
                    color: Colors.black,
                    child: Text(
                      '𝕏',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                InkWell(
                  onTap: launchToFacebook,
                  child: _SocialCircle(
                    color: Color(0xFF1877F2),
                    child: Text(
                      'f',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 31,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({required this.color, required this.child});
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        width: 37,
        height: 37,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: child,
      );
}
