import 'dart:convert';

import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/trending_shimmer.dart';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/connectivity_provider.dart';
import 'package:src_kstu_app/services/trending_news.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:src_kstu_app/components/trending_component.dart';
import 'package:src_kstu_app/feature/pages/error_pages/no_internet.dart';


class TrendingNewsPage extends StatefulWidget {
  const TrendingNewsPage({super.key});

  @override
  State<TrendingNewsPage> createState() => _TrendingNewsPageState();
}

class _TrendingNewsPageState extends State<TrendingNewsPage> {
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

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
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
                        child: Container(
                      decoration: const BoxDecoration(
                          color: topColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 8),
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
                                "Trending News",
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
                        flex: 9,
                        child: Consumer<ConnectivityProvider>(
                            builder: (context, provider, _) {
                          if (provider.status == ConnectivityStatus.Offline) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: bottomColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 18.0),
                                child: TrendingShimmer(),
                              ),
                            );
                          } else {
                            return Container(
                                // height: 100,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: bottomColor,
                                // color: Colors.red,

                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30))),
                                child: ListView(
                                            physics: BouncingScrollPhysics(),
                                            

                                  children: [Container(
                                    height: MediaQuery.of(context).size.height,
                                    child: FutureBuilder<List<Announcement>>(
                                        future: trendProvider.fetchTrend(1),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return TrendingShimmer();
                                          } else if (snapshot.hasError) {
                                            // logout().then((value) => {
                                            //       Navigator.of(context)
                                            //           .pushAndRemoveUntil(
                                            //               MaterialPageRoute(
                                            //                   builder: (context) =>
                                            //                       LoginPage()),
                                            //               (route) => false)
                                            //     });
                                            // return Text("${snapshot.error}");
                                            return noInternet();
                                          } else {
                                            // return ListView.builder(
                                            //     controller: _scrollController,
                                            //     physics: BouncingScrollPhysics(),
                                            //     itemCount:
                                            //         trendProvider.trend.length,
                                            //     scrollDirection: Axis.vertical,
                                            //     itemBuilder: (context, index) {
                                                   final trend =
                                                      trendProvider.trend;
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: TrendingComponent(
                                                        showRefresh: true,
                                                      
                                                      gottenData: trend,page: 2,hasLimit: false,isTrending:true),
                                                  );
                                                
                                          }
                                        }),
                                  ),]
                                ));
                          }
                        }))
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