import 'package:flutter/material.dart';
import 'package:src_kstu_app/models/announcement.dart';
import 'dart:convert';
import 'package:src_kstu_app/feature/pages/news_details.dart';
import 'package:src_kstu_app/feature/pages/trending_shimmer.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/notice_board.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src_kstu_app/services/trending_news.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:async/async.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

enum AnnouncementLoadMoreStatus { LOADING, STABLE }

// ignore: must_be_immutable
class TrendingComponent extends StatefulWidget {
  final List<Announcement>? gottenData;
  int page;
  final bool isTrending;
  final bool hasLimit;
  final bool showRefresh;

  TrendingComponent(
      {super.key,
      required this.showRefresh,
      required this.gottenData,
      required this.page,
      required this.isTrending,
      required this.hasLimit});

  @override
  State<TrendingComponent> createState() => _TrendingComponentState();
}

class _TrendingComponentState extends State<TrendingComponent> {
  final int maxPaginatedAnnouncementsValue = 5;
  // this value (maxPaginatedAnnouncementsValue) must correspond with the number of
  // announcements gotten for each request
  //
  AnnouncementLoadMoreStatus loadMoreStatus = AnnouncementLoadMoreStatus.STABLE;
  final ScrollController scrollController = new ScrollController();
  // static const String IMAGE_BASE_URL = "http://image.tmdb.org/t/";
  List<Announcement>? announcements = [];

  int currentPageNumber = 0;
  late CancelableOperation announcementOperation;
  bool dataLoading = false;
  // keep track of getting fresh data

  @override
  void initState() {
    setState(() {
      announcements = widget.gottenData;
      currentPageNumber = widget.page;
      // print(currentPageNumber.toString()+"currentt");
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    // ignore: unnecessary_null_comparison
    if (announcementOperation != null) announcementOperation.cancel();
    super.dispose();
  }

  bool onNotification(ScrollNotification notification) {
    final trendProvider =
        Provider.of<TrendingNewsProvider>(context, listen: false);
    final noticeboardProvider =
        Provider.of<NoticeBoardProvider>(context, listen: false);
    if (!widget.hasLimit) {
      // if limit is specified,then no need to continue bringing additional data on scroll

      if (notification is ScrollUpdateNotification) {
        if (scrollController.position.maxScrollExtent >
                scrollController.offset &&
            scrollController.position.maxScrollExtent -
                    scrollController.offset <=
                50) {
          setState(() {
            dataLoading = true;
            // about to request fresh data
          });
          // ignore: unnecessary_null_comparison
          if (loadMoreStatus != null &&
              loadMoreStatus == AnnouncementLoadMoreStatus.STABLE) {
            loadMoreStatus = AnnouncementLoadMoreStatus.LOADING;

// ................
            if (widget.isTrending) {
              announcementOperation = CancelableOperation.fromFuture(
                      trendProvider.fetchTrend(currentPageNumber))
                  .then((announcementObject) {
                setState(() {
                  dataLoading = false;
                  // data is returned
                });
                loadMoreStatus = AnnouncementLoadMoreStatus.STABLE;

                if (announcementObject.length <
                    maxPaginatedAnnouncementsValue) {
                  // if the announcements returned is less than maxPaginatedAnnouncementsValue
                  // then we are at the end of all the annnouncements from the api,so we start afresh
                  setState(() {
                    currentPageNumber = 1;
                    // print("widget" + widget.page.toString());
                    print("currentPage when item is less" +
                        currentPageNumber.toString());
                  });
                } else {
                  setState(() {
                    currentPageNumber += 1;
                    // print("widget" + widget.page.toString());
                    print("currentPage when item is greater" +
                        currentPageNumber.toString());
                  });
                }
                setState(() => announcements!.addAll(announcementObject));
              });
            } else {
              announcementOperation = CancelableOperation.fromFuture(
                      noticeboardProvider.fetchNotice(currentPageNumber))
                  .then((announcementObject) {
                setState(() {
                  dataLoading = false;
                  // data is returned
                });
                loadMoreStatus = AnnouncementLoadMoreStatus.STABLE;

                if (announcementObject.length <
                    maxPaginatedAnnouncementsValue) {
                  // if the announcements returned is less than maxPaginatedAnnouncementsValue
                  // then we are at the end of all the annnouncements from the api,so we start afresh
                  setState(() {
                    currentPageNumber = 1;
                    // print("widget" + widget.page.toString());
                    print("currentPage when item is less" +
                        currentPageNumber.toString());
                  });
                } else {
                  setState(() {
                    currentPageNumber += 1;
                    // print("widget" + widget.page.toString());
                    print("currentPage when item is greater" +
                        currentPageNumber.toString());
                  });
                }
                setState(() {
                  announcements!.addAll(announcementObject);
                });
              });
            }
          }
        }
      }
    }
    return true;
  }

//
  Future<void> likeAnnouncement(int announcmentId, int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final response = await http.post(
        Uri.parse(likesUrl + '/' + '${announcmentId}' + '/' + '${status}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });
    if (response.statusCode == 200) {
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
    } else {
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

  Future refreshAnnouncements() async {
    setState(() {
      final trendProvider =
          Provider.of<TrendingNewsProvider>(context, listen: false);
      final noticeboardProvider =
          Provider.of<NoticeBoardProvider>(context, listen: false);
      announcements!.clear();
      announcements != widget.isTrending
          ? trendProvider.fetchTrend(1)
          : noticeboardProvider.fetchNotice(1);
    });

    // SQq7t8AF
  }

  @override
  Widget build(BuildContext context) {
    // final noticeProvider =
    //     Provider.of<NoticeBoardProvider>(context, listen: false);
    // final trendProvider =
    //     Provider.of<TrendingNewsProvider>(context, listen: false);
    return NotificationListener(
      onNotification: onNotification,
      child: widget.showRefresh
          ? RefreshIndicator(
              onRefresh: refreshAnnouncements, child: announcementBuilder())
          : announcementBuilder(),
    );
    // );
  }

  Widget announcementBuilder() {
    final trend = widget.gottenData!;
    SimpleFontelicoProgressDialog _dialog =
        SimpleFontelicoProgressDialog(context: context);
    return ListView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: trend.length,
        shrinkWrap: true,
        // itemCount: trend.length!=0?trend.length:maxPaginatedAnnouncementsValue,

        itemBuilder: ((context, index) {
          // if (index < trend.length) {
          return dataLoading
              ? TrendingShimmer()
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _dialog.show(
                            message: 'Waiting...',
                            type: SimpleFontelicoProgressDialogType
                                .hurricane);
                        await Future.delayed(Duration(seconds: 1));
                        _dialog.hide();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    DetailNews(title: trend[index].id))));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // ignore: unnecessary_null_comparison
                                image: trend[index].featuredImage != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            "${announcement_imgUri}${trend[index].featuredImage}"),
                                        fit: BoxFit.cover)
                                    : null),
                          ),
                          // ignore: unnecessary_null_comparison
                          trend[index].featuredImage != null
                              ? Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.3)),
                                )
                              : Center(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _dialog.show(
                            message: 'Waiting...',
                            type: SimpleFontelicoProgressDialogType
                                .hurricane);
                        await Future.delayed(Duration(seconds: 1));
                        _dialog.hide();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    DetailNews(title: trend[index].id))));
                      },
                      child: Text(
                        trend[index].title.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                // ============= Increasing the width of the Container to display the full date length
                                width: 180,
                                child: Text(
                                  '${trend[index].createdAtFormatted.split(', ')[1]}',
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   width: 58,
                          // ),

                          Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // AudioPlayer().play(AssetSource("audio/my_audio.mp3"));
                                  if (trend[index].likedByAuthUser ==
                                      true) {
                                    likeAnnouncement(trend[index].id, 0);
                                  } else {
                                    likeAnnouncement(trend[index].id, 1);
                                  }
                                },
                                child: Row(
                                  children: [
                                    // trend[index].likedByAuthUser ==
                                    //         true
                                    //     ? Icon(
                                    //         CupertinoIcons
                                    //             .hand_thumbsup_fill,
                                    //         color: topColor,
                                    //       )
                                    //     : Icon(
                                    //         CupertinoIcons
                                    //             .hand_thumbsup,
                                    //         color: Colors.grey,
                                    //       ),
                                    // const SizedBox(
                                    //   width: 2,
                                    // ),
                                    // Text(
                                    //   '${trend[index].likesCountFormatted}',
                                    //   style: TextStyle(
                                    //       color: Colors.grey),
                                    // )
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
                                '${trend[index].viewsCountFormatted}',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    )
                  ],
                ),
              );
        }));
  }
}
