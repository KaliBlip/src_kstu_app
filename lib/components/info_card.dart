import 'package:src_kstu_app/models/constant.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InfoCard extends StatelessWidget {
  InfoCard(
      {Key? key,
      required this.name,
      required this.indexNo,
      required this.image}
    ): super(key: key);

  String name;
  String indexNo;
  String image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white24,
        backgroundImage: image != "1"
            ? NetworkImage("${user_img_uri}${image}")
            : NetworkImage(
                "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        indexNo,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
