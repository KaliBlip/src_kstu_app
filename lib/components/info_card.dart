import 'package:src_kstu_app/models/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class InfoCard extends StatelessWidget {
  InfoCard(
      {Key? key,
      required this.name,
      required this.indexNo,
      this.image}
    ): super(key: key);

  String name;
  String indexNo;
  String? image;

  bool get _hasImage {
    final img = image;
    return img != null &&
        img.isNotEmpty &&
        img != "1" &&
        img != "null";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white24,
        backgroundImage: _hasImage
            ? NetworkImage("${user_img_uri}${image}")
            : const NetworkImage(
                "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
      ),
      title: Text(
        name,
        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
      subtitle: Text(
        indexNo,
        style: GoogleFonts.poppins(color: Colors.white),
      ),
    );
  }
}
