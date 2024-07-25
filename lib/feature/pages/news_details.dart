import 'dart:convert';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/key_moments_container.dart';
import 'package:src_kstu_app/feature/pages/trending_shimmer.dart';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/connectivity_provider.dart';
import 'package:src_kstu_app/services/trending_news.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailNews extends StatefulWidget {
  const DetailNews({super.key, required this.title});
  final int title;

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  double marignTop = 180;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  Future<void> likeAnnouncement(int category_id, int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(
        Uri.parse(likesUrl + '/' + '${category_id}' + '/' + '${status}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
      });
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${data['message']}"),
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
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${jsonDecode(response.body)['message']}"),
        backgroundColor: Colors.red,
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

  void _handleScroll() {
    if (_scrollController.position.pixels > 0) {
      setState(() {
        if (marignTop == 50) {
          marignTop = 50;
        } else {
          marignTop -= 10;
        }
      });
    } else if (_scrollController.position.pixels == 0) {
      setState(() {
        marignTop = 180;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _scrollController.addListener(_handleScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trending = Provider.of<TrendingNewsProvider>(context, listen: false);
    // ignore: deprecated_member_use
    return WillPopScope(
      // this will aid users in going backto dashboardpage after coming here by clicking on a notification
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
        );
        return false; // Prevents the default back button behavior
      },
      child: Scaffold(
          backgroundColor: topColor,
          body: Semantics(
            label: "News Detail Page",
            child: SafeArea(
              child:
                  Consumer<ConnectivityProvider>(builder: (context, provider, _) {
                if (provider.status == ConnectivityStatus.Offline) {
                  SnackBar(
                      content: Text("No internet connection"),
                      backgroundColor: topColor,
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
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: bottomColor,
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(30))),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 18.0),
                          child: TrendingShimmer()));
                } else {
                  return FutureBuilder<Announcement>(
                      future: trending.fetchTrendDetails(widget.title),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final trend = snapshot.data!;
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            child: Stack(children: [
                              Container(
                                height: 250,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${announcement_imgUri}${trend.featuredImage}"),
                                        fit: BoxFit.cover)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: 10,
                                        left: 10,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                              size: 30,
                                            ))),
                                    Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                            onTap: () {},
                                            child: Icon(
                                              CupertinoIcons.bookmark,
                                              color: Colors.white,
                                              size: 30,
                                            ))),
                                  ],
                                ),
                              ),
                              Positioned(
                                  // bottom: 20,
                                  child: Container(
                                margin: EdgeInsets.only(top: marignTop),
                                height: MediaQuery.of(context).size.height,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: bottomColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        topLeft: Radius.circular(25))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 20),
                                  child: NestedScrollView(
                                    scrollDirection: Axis.vertical,
                                    controller: _scrollController,
                                    headerSliverBuilder:
                                        (context, innerBoxIsScrolled) {
                                      return [];
                                    },
                                    body: ListView(
                                      // controller: _scrollController,
                                      children: [
                                        Text(
                                          trend.title,
                                          style: TextStyle(
                                            
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Divider(
                                          color:
                                              Color.fromARGB(255, 91, 89, 89),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.clock,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Text(
                                                    '${trend.createdAtFormatted.split(', ')[1]}',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (trend.likedByAuthUser ==
                                                        true) {
                                                      likeAnnouncement(
                                                          trend.id, 0);
                                                    } else {
                                                      likeAnnouncement(
                                                          trend.id, 1);
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      trend.likedByAuthUser ==
                                                              true
                                                          ? Icon(
                                                              CupertinoIcons
                                                                  .hand_thumbsup_fill,
                                                              color: topColor,
                                                            )
                                                          : Icon(
                                                              CupertinoIcons
                                                                  .hand_thumbsup,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      Text(
                                                        '${trend.likesCountFormatted}',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                FaIcon(FontAwesomeIcons.eye,
                                                    color: Colors.grey),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  '${trend.viewsCountFormatted}',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Divider(
                                          color:
                                              Color.fromARGB(255, 91, 89, 89),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        KeyMomentContainer(title: widget.title)
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                            ]),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: bottomColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30))),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 18.0),
                                  child: TrendingShimmer()));
                        } else {
                          return Center();
                        }
                      });
                }
              }),
            ),
          )),
    );
  }
}
