import 'package:card_swiper/card_swiper.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/trending_news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    final trendProvider =
        Provider.of<TrendingNewsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: topColor,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
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
                        // flex: 1,
                        child: Container(
                      height: 20,
                      decoration: const BoxDecoration(
                          color: topColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: Column(children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Dashboard()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: bottomColor,
                                  size: 25,
                                ),
                              ),
                              const Text(
                                "About Our Application",
                                style: TextStyle(
                                    color: bottomColor,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ]),
                      ),
                    )),
                    Expanded(
                        flex: 8,
                        child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: bottomColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 5),
                              child: ListView(
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  FutureBuilder(
                                    future: trendProvider.fetchTrend(1),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else {
                                        final trend = snapshot.data!;
                                        return Container(
                                          width: double.infinity,
                                          height: 230,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Swiper(
                                            itemCount: trend.length,
                                            curve: Curves.fastOutSlowIn,
                                            autoplay: true,
                                            scrollDirection: Axis.vertical,
                                            pagination: SwiperPagination(),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                width: double.infinity,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${announcement_imgUri}/${trend[index].featuredImage}"),
                                                        fit: BoxFit.fill),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Our KsTu-SRC  Student Online Noticeboard is a dedicated platform designed exclusively for students of Kumasi Technical University (KsTU). Here, we aim to provide a centralized hub for students to stay informed, connected, and engaged within the university community.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "The KSTU-SRC Mobile Application is a Mobile/Web-based software application designed to provide students with a centralized platform to access and view important notices, announcements, and updates from their educational institution.  ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "The application aims to streamline communication, improve information dissemination, and enhance the overall student experience. This report provides a comprehensive overview of the project, including its objectives, methodology, implementation details, testing, and evaluation.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Feedback and Suggestions: We value your inout and strive to continuously improve our platform. If you have any feedback, suggestions or questions, please feel free to reach out to us. We are committed to enhancing that the notcie board meets your needs.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "The software application aims to overcome these limitations by providing an online platform accessible to students anytime, anywhere, with a user-friendly interface. ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "If you require any assistance or have inquiries, our support team is here to help. We are dedicated to providing you with the best possible experience.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "Thank you for choosing the KsTU Student Online Notice Board. Together, let's make your academic journey at KsTU even more enriching and fulfilling.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "ALL RIGHTS RESERVED © 2024" ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
