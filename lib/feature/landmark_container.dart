import 'package:src_kstu_app/models/land-marks-model.dart';
import 'package:src_kstu_app/providers/landmark_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandmarkContainer extends ConsumerWidget {
  final int title;
  const LandmarkContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<LandmarkModel>>(
      future: ref.read(landmarkNotifierProvider.notifier).fetchLandmarkPlaces(title),
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
