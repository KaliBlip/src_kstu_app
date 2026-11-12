import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/feature/landmark_container.dart';
import 'package:src_kstu_app/feature/pages/campus_map_shimmer.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/models/campus_map_model.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/providers/campus_map_provider.dart';
import 'package:src_kstu_app/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:src_kstu_app/feature/pages/error_pages/no_internet.dart';
import 'package:google_fonts/google_fonts.dart';

class CampusMap extends ConsumerStatefulWidget {
  final String url;
  final String title;
  const CampusMap({super.key, required this.url, required this.title});

  @override
  ConsumerState<CampusMap> createState() => _CampusMapState();
}

class _CampusMapState extends ConsumerState<CampusMap> {
  bool isOpen = false;

  // void mylauntcher(String url) async {
  //   var uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch $uri';
  //   }
  // }
  Future<void> mylauntcher(String url) async {
    await launch(
      url,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: topColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      color: isOpen
                          ? Color.fromARGB(255, 209, 207, 207)
                          : bottomColor,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                    Container(
                      color: topColor,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 0,
                        decoration: const BoxDecoration(
                            color: topColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Dashboard()),
                                              (route) => false);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: bottomColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    widget.title,
                                    style: GoogleFonts.poppins(
                                        color: bottomColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: isOpen
                                ? Color.fromARGB(255, 209, 207, 207)
                                : bottomColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 10),
                          child: Consumer(
                              builder: (context, ref, _) {
                            final status = ref.watch(connectivityNotifierProvider);
                            if (status ==
                                ConnectivityStatus.offline) {
                              //
                              return noInternet();
                            } else {
                              return FutureBuilder<List<CampusMapModel>>(
                                  future: ref.read(campusMapNotifierProvider.notifier).fetchMaps(widget.url),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CampusMapShimmer();
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        // child: Text(snapshot.error.toString()),
                                        child: noInternet(),
                                      );
                                    } else {
                                      final campusmap = snapshot.data!;
                                      return GridView.builder(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 2.0),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 16,
                                                crossAxisSpacing: 10,
                                                mainAxisExtent: 200,
                                                childAspectRatio: 200),
                                        itemCount: campusmap.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              // setState(() {
                                              //   isOpen = true;
                                              // });
                                              // I removed the stateless widget ShowBottomSheet Container into the showBottomsheet return;
                                              showBottomSheet(
                                                  elevation: 10,
                                                  enableDrag: true,
                                                  context: context,
                                                  builder:
                                                      (builder) => Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        40),
                                                                topRight: Radius
                                                                    .circular(
                                                                        40),
                                                              ),
                                                            ),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                50,
                                                            width: double
                                                                .infinity,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Stack(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              235,
                                                                          width:
                                                                              double.infinity,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              topRight: Radius.circular(10),
                                                                            ),
                                                                            color: topColor,
                                                                            image: DecorationImage(
                                                                              image: NetworkImage("${landmark_imgs}${campusmap[index].image}"),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          right:
                                                                              8,
                                                                          top:
                                                                              8,
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundColor: Colors.black.withOpacity(0.5),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(3.0),
                                                                              child: Center(
                                                                                child: IconButton(
                                                                                  padding: EdgeInsets.zero,
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      isOpen = false;
                                                                                    });
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  icon: Icon(
                                                                                    Icons.close_outlined,
                                                                                    color: Colors.white,
                                                                                    size: 25,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 8,
                                                                      left:
                                                                          8),
                                                                  child: Text(
                                                                    campusmap[
                                                                            index]
                                                                        .name,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          13,
                                                                      fontWeight:
                                                                          FontWeight.bold,
                                                                    ),
                                                                    maxLines:
                                                                        1, // Adjust the number of lines you want to allow before wrapping
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                Divider(),
                                                                LandmarkContainer(
                                                                    title: campusmap[
                                                                            index]
                                                                        .id),
                                                                Divider(),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          20,
                                                                      right:
                                                                          20),
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () =>
                                                                        mylauntcher(
                                                                            "https://www.google.com/maps?q=${campusmap[index].latitude},${campusmap[index].longitude}&zoom=18"),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40,
                                                                      width: double
                                                                          .infinity,
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              topColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "Navigate To",
                                                                          style: GoogleFonts.poppins(
                                                                              color: Colors.white,
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                              ],
                                                            ),
                                                          ));
                                            },
                                            child: isOpen
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                      color: Color.fromARGB(
                                                          255, 187, 185, 185),
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: topColor),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          height: 140,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.white,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                      // ignore: unnecessary_null_comparison
                                                                      campusmap[index].image !=
                                                                              null
                                                                          ? "${landmark_imgs}${campusmap[index].image}"
                                                                          : "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                                                              fit: BoxFit
                                                                  .cover,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          campusmap[index]
                                                              .name,
                                                          textAlign: TextAlign
                                                              .center,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color:
                                                                Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                          maxLines:
                                                              1, // Adjust the number of lines you want to allow before wrapping
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                          );
                                        },
                                      );
                                    }
                                  });
                            }
                          }),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
