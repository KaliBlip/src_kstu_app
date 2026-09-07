import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TrendingShimmer extends StatelessWidget {
  const TrendingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      period: Duration(seconds: 3),
      child: SizedBox(
        height: 320,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2, // Reduced count to fit in fixed height
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 15,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 15,
                        color: Colors.grey.shade400,
                      ),
                      Spacer(),
                      Container(
                        width: 60,
                        height: 15,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 15,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (index < 1) // Only show divider between items
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
