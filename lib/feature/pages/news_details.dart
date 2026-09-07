import 'dart:convert';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/feature/pages/error_pages/no_internet.dart';
import 'package:src_kstu_app/feature/pages/key_moments_container.dart';
import 'package:src_kstu_app/feature/pages/trending_shimmer.dart';
import 'package:src_kstu_app/models/announcement.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/connectivity_provider.dart';
import 'package:src_kstu_app/providers/trending_news_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailNews extends ConsumerStatefulWidget {
  const DetailNews({super.key, required this.title});
  final int title;

  @override
  ConsumerState<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends ConsumerState<DetailNews> {
  double marignTop = 260;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  Future<void> saveImageToGallery(
    String imageUrl,
    BuildContext context,
  ) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await Dio().download(imageUrl, filePath);
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Save image',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: $e')),
      );
    }
  }

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
    return WillPopScope(
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
          body: Consumer(builder: (context, ref, _) {
            final connectivityStatus = ref.watch(connectivityStreamProvider);
            
            return connectivityStatus.when(
              data: (status) {
                if (status == ConnectivityStatus.offline) {
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
                          child: noInternet()));
                } else {
                  return FutureBuilder<Announcement>(
                      future: ref.read(trendingNewsDetailsProvider(widget.title).future),
                      builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final trend = snapshot.data!;
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Stack(children: [
                          Container(
                            height: 320,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "${announcement_imgUri}${trend.featuredImage}"),
                                    onError: (_, __) {},
                                    fit: BoxFit.cover)),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 50,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 184, 184, 184),
                                            blurRadius: 20,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        // Ensures the icon is both vertically and horizontally centered
                                        child: Icon(
                                          Icons
                                              .arrow_back_ios_new, // Slightly more centered version of the back arrow
                                          color: Colors.black,
                                          size:
                                              25, // Fits better in small circular buttons
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 50,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      saveImageToGallery(
                                          "${announcement_imgUri}${trend.featuredImage}",
                                          context);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 184, 184, 184),
                                            blurRadius: 20,
                                            offset: Offset(2, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.save,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              // bottom: 20,
                              child: Padding(
                            padding: EdgeInsets.only(top: marignTop),
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
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
                                  body: SingleChildScrollView(
                                    child: Column(
                                      // controller: _scrollController,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          trend.title,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                             ),
                                             textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Divider(
                                          color:
                                              Color.fromARGB(255, 223, 222, 222),
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
                                                  width: 210,
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
                                              Color.fromARGB(255, 223, 222, 222),
                                        ),
                                        KeyMomentContainer(title: widget.title)
                                      ],
                                    ),
                                  ),
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
                      return Container(
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          color: Colors.white,
                          child: Center(
                            child: noInternet(),
                          ));
                    }
                  });
                }
              },
              loading: () => Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bottomColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                ),
                child: Center(
                  child: CircularProgressIndicator(color: topColor),
                ),
              ),
              error: (error, stack) => Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bottomColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                ),
                child: Center(
                  child: Text(
                    'Error loading content',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
