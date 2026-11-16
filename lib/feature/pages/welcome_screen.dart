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
        vsync: this, duration: const Duration(milliseconds: 2500));
    final CurvedAnimation curvedAnimation1 =
        CurvedAnimation(parent: controller1, curve: Curves.easeInOut);
    animation1 = Tween(begin: 100.0, end: 240.0).animate(curvedAnimation1);

    controller1.forward();
  }

  Widget containerLogo(BuildContext context) {
    return SizedBox(
      width: animation1.value,
      height: animation1.value,
      child: Image.asset("assets/images/f.png", fit: BoxFit.contain),
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    return Scaffold(
        backgroundColor: topColor,
        body: SizedBox(
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
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background image
                          Image.asset(
                            "assets/images/hero_image.jpeg",
                            fit: BoxFit.cover,
                          ),
                          // topColor overlay with opacity
                          Container(
                            color: topColor.withOpacity(0.9),
                          ),
                          Center(
                            child: AnimatedBuilder(
                              animation: animation1,
                              builder: (context, child) =>
                                  containerLogo(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                                  const Spacer(),
                                  Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: topColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                      child: Text(
                                        "No internet connection",
                                        style: TextStyle(
                                            color: bottomColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
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
                                          const Duration(seconds: 1));
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
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Tap To Login",
                                          style: GoogleFonts.poppins(
                                              color: bottomColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
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
                                          const Duration(seconds: 1));
                                      _dialog.hide();
                                      launchToRegister();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: topColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "Tap To Register",
                                          style: GoogleFonts.poppins(
                                              color: bottomColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
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
