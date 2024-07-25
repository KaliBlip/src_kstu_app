import 'package:src_kstu_app/services/landmark_places.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:src_kstu_app/feature/pages/error_pages/no_internet.dart';

class LandmarkContainer extends StatefulWidget {
  final int title;
  const LandmarkContainer({super.key, required this.title});

  @override
  State<LandmarkContainer> createState() => _LandmarkContainerState();
}

class _LandmarkContainerState extends State<LandmarkContainer> {
  @override
  Widget build(BuildContext context) {
    final places = Provider.of<LandmarkProvider>(context, listen: false);
    return FutureBuilder(
      future: places.fetchLandmarkPlace(widget.title),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to pull data :('),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child:Text('loading...'));
        } else {
          final place = snapshot.data!;
          return Container(
            height: 198,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: place.length,
              itemBuilder: (context, index) {
                return CupertinoListTile(
                  leading: Radio(
                    value: "",
                    groupValue: "",
                    onChanged: (value) {},
                  ),
                  title: Text(
                    place[index].name,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
