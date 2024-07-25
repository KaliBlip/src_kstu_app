import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.isLast = false})
      : super(key: key);
  final String title;
  final String subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const Spacer(),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        isLast
            ? Center()
            : const Divider(
                thickness: 1,
                color: Colors.grey,
              )
      ],
    );
  }
}
