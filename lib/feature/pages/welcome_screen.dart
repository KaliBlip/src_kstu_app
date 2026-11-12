import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/connectivity_provider.dart';
import 'package:src_kstu_app/feature/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';


class WelcomeScreenPage extends StatefulWidget {
  const WelcomeScreenPage({super.key});

  @override
  State<WelcomeScreenPage> createState() => _WelcomeScreenPageState();
}

class _WelcomeScreenPageState extends State<WelcomeScreenPage>
    with TickerProviderStateMixin {
  late Animation<double> animation1;
  late AnimationController controller1;

    Future<void> launchToRegister() async {
    await launchUrl(
      Uri.parse('$asset_base_url/user/register'),
    );
  }

  @override
  void initState() {
    super.initState();
    // Animation & Controller 1
    controller1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    final CurvedAnimation curvedAnimation1 =
        CurvedAnimation(parent: controller1, curve: Curves.easeInOut);
    animation1 = Tween(begin: 100.0, end: 240.0).animate(curvedAnimation1);


    controller1.forward();
  }

  Widget containerLogo(BuildContext context) {
    return Container(
      width: animation1.value,
      height: animation1.value,
      child: Image.asset("assets/images/f.png", fit: BoxFit.contain),
    );
  }

  // Widget textAnimated(BuildContext context) {
  //   return Text(
  //           textAlign: TextAlign.center,

  //     "Official Mobile App For KsTU Students",
  //     style: TextStyle(
  //         color: bottomColor,
  //         fontWeight: FontWeight.bold,
  //         fontSize: animation2.value),
  //   );
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    return Scaffold(
        backgroundColor: topColor,
        body: Container(
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
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: topColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30))),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                                animation: animation1,
                                builder: (context, child) =>
                                    containerLogo(context)),
                            // const SizedBox(
                            //   height: 25,
                            // ),
                            // AnimatedBuilder(
                            //     animation: animation1,
                            //     builder: (context, child) =>
                            //         textAnimated(context)),
                          ],
                        ),
                      )),
                  Consumer(
                      builder: (context, ref, _) {
                    final status = ref.watch(connectivityNotifierProvider);
                    if (status == ConnectivityStatus.offline) {
                      return Expanded(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: bottomColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 15.0),
                              child: Column(
                                children: [
                                  Spacer(),
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: topColor,
                                        borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                    child: const Center(
                                      child: Text(
                                        "No internet connection",
                                        style: TextStyle(
                                            color: bottomColor,
                                            fontSize: 20,
                                            fontWeight:
                                                FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ));
                    } else {
                      return Expanded(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: bottomColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 15.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 60,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      _dialog.show(
                                          message: 'Waiting...',
                                          type:
                                              SimpleFontelicoProgressDialogType
                                                  .hurricane);
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      _dialog.hide();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  const LoginPage())));
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: topColor,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10)),
                                      child: Center(
                                        child: Text(
                                          "Tap To Login",
                                          style: GoogleFonts.poppins(
                                              color: bottomColor,
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      _dialog.show(
                                          message: 'Waiting...',
                                          type:
                                              SimpleFontelicoProgressDialogType
                                                  .hurricane);
                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      _dialog.hide();
                                      launchToRegister();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: topColor,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  10)),
                                      child: Center(
                                        child: Text(
                                          "Tap To Register",
                                          style: GoogleFonts.poppins(
                                              color: bottomColor,
                                              fontSize: 20,
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }
                  })
                ],
              )
            ])));
  }
}
