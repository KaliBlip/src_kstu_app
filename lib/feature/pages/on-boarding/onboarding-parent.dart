import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:src_kstu_app/feature/pages/welcome_screen.dart';

///Class to hold data for itembuilder in onBoardingParent app.
class ItemData {
  final Color color;
  final String image;
  final String text1;
  final String text2;
  final String text3;

  ItemData(this.color, this.image, this.text1, this.text2, this.text3);
}

/// Example of LiquidSwipe with itemBuilder
class onBoardingParent extends StatefulWidget {
  @override
  _onBoardingParent createState() => _onBoardingParent();
}

class _onBoardingParent extends State<onBoardingParent> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;

  List<ItemData> data = [
    ItemData(Color.fromARGB(255, 16, 104, 131), "assets/images/app4.png", "Hi!",
        "Welcome To", "The Official KsTU SRC App"),
    ItemData(Colors.blue, "assets/images/app5.png", "The App Built",
        "For Awesome KsTU", "Students"),
    ItemData(Colors.green, "assets/images/app7.png", "All You Will Need",
        " To Have A Seamless ", "Experience On Campus!"),
    ItemData(Color.fromARGB(255, 235, 91, 25), "assets/images/app6.png",
        "Get Notified", "And Be On Top Of The Game ", "By Preping In Advance!"),
    ItemData(const Color.fromARGB(255, 255, 0, 149), "assets/images/app8.png",
        "Dude", "What Are You Waiting For?", "Hop On And Have A Blast🎉"),
    // ItemData(
    //     Colors.pink, "assets/1.png", "Example", "of a page", "with Gesture"),
    // ItemData(Colors.red, "assets/1.png", "Do", "ttry it", "Thank you"),
  ];

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.white,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  TextStyle Stylefunction() {
    return TextStyle(
        fontSize: 24,
        fontFamily: "Billy",
        fontWeight: FontWeight.w600,
        color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                color: data[index].color,
                child: Stack(
                  children: [
                    Image.asset(
                      data[index].image,
                      // height: 400,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(index != 4 ? 24.0 : 0),
                        ),
                        Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 200),
                              index == 4
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70.0),
                                      child: ActionSlider(),
                                    )
                                  : SizedBox.shrink(),
                              Text(data[index].text1, style: Stylefunction()),
                              Text(data[index].text2, style: Stylefunction()),
                              Text(data[index].text3, style: Stylefunction()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            positionSlideIcon: 0.8,
            slideIconWidget: liquidController.currentPage == 4
                ? InkWell(onTap:(){
                        toWelcome();

                },child:Icon(Icons.arrow_forward_ios, color: Colors.white))
                : Icon(Icons.arrow_back_ios, color: Colors.white),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            fullTransitionValue: 880,
            enableSideReveal: true,
            preferDragFromRevealedArea: true,
            enableLoop: false,
            ignoreUserGestureWhileAnimating: true,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(data.length, _buildDot),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: liquidController.currentPage == 4
                  ? TextButton(
                      onPressed: () {
                        toWelcome();
                      },
                      child: Text(
                        "Get Started!",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.01),
                          foregroundColor: Colors.black),
                    )
                  : TextButton(
                      onPressed: () {
                        liquidController.animateToPage(
                            page: data.length - 1, duration: 700);
                      },
                      child: Text(
                        "Skip to End",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.01),
                          foregroundColor: Colors.black),
                    ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: TextButton(
                onPressed: () {
                  liquidController.jumpToPage(
                      page: liquidController.currentPage + 1 > data.length - 1
                          ? 0
                          : liquidController.currentPage + 1);
                },
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.01),
                    foregroundColor: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  toWelcome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomeScreenPage()),
        (route) => false);
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}

///Example of App with LiquidSwipe by providing list of widgets
class ActionSlider extends StatefulWidget {
  const ActionSlider({Key? key}) : super(key: key);

  @override
  State<ActionSlider> createState() => _ActionSliderState();
}

class _ActionSliderState extends State<ActionSlider> {
  // double sliderVal = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 80,
        // ),
        // Container(
        //   width: 50,
        //   height: 50,
        //   child: DecoratedBox(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         color: Colors.white,
        //         width: 2.0,
        //       ),
        //     ),
        //     child: InkWell(
        //       onTap: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(builder: (context) => WelcomeScreenPage()),
        //         );
        //       },
        //       child: Center(
        //         child: const Icon(
        //           Icons.arrow_forward_ios,
        //           color: Colors.white,
        //           size: 25,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}