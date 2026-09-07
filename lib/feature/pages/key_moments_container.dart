import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/models/annoucement_key_moment.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/services/key_moments_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class KeyMomentContainer extends StatefulWidget {
  const KeyMomentContainer({super.key, required this.title});
  final int title;

  @override
  State<KeyMomentContainer> createState() => _KeyMomentContainerState();
}

class _KeyMomentContainerState extends State<KeyMomentContainer> {
  ScrollController _scrollController = ScrollController();
  final KeyMomentProvider _keymomentProvider = KeyMomentProvider();
  late final Future<List<AnnouncementKeyMoments>> _keymomentFuture =
      _keymomentProvider.fetchKeymoment(widget.title);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnnouncementKeyMoments>>(
        future: _keymomentFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? topColor : topColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
                size: 80,
              ),
            );
          } else {
            final keymoments = snapshot.data!;
            return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: keymoments.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Linkify(
                        text: keymoments[index].imageDescription,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.justify,
                        onOpen: (link) async {
                          final uri = Uri.parse(link.url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Could not open the link')),
                            );
                          }
                        },
                      ),
                      keymoments[index].image != ""
                          ? SizedBox(
                              height: 20,
                            )
                          : Center(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          keymoments[index].image != ""
                              ? Container(
                                  width: double.infinity,
                                  height: 230,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${key_moment_uri}${keymoments[index].image}"),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.circular(10)),
                                )
                              : Center(),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Text(
                              "${keymoments[index].imageSubTitle}",
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.black.withOpacity(0.7)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          keymoments[index].image != ""
                              ? SizedBox(
                                  height: 25.0,
                                )
                              : SizedBox(
                                  height: 2,
                                ),
                        ],
                      )
                    ],
                  );
                });
          }
        });
  }
}
