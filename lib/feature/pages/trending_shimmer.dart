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
      child: Container(
        width: double.infinity,
        height: 320,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(''), fit: BoxFit.cover)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey.shade400,
                      ),
                      Spacer(),
                      Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 100,
                        height: 20,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
