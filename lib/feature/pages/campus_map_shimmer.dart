import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CampusMapShimmer extends StatefulWidget {
  const CampusMapShimmer({super.key});

  @override
  State<CampusMapShimmer> createState() => _CampusMapShimmerState();
}

class _CampusMapShimmerState extends State<CampusMapShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: GridView.builder(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 200,
                  childAspectRatio: 200),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 187, 185, 185),
                  ),
                );
              })),
    );
  }
}