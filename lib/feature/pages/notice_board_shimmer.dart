
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NoticeBoardShimmer extends StatelessWidget {
  const NoticeBoardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: SizedBox(
        height: 200, // Fixed height to prevent unbounded axis error
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: 160,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.grey.shade100,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.grey.shade100,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.grey.shade100,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      enabled: true,
    );
  }
}
