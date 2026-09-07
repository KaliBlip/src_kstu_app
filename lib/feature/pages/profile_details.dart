import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 14),
              maxLines:
                  1, // Adjust the number of lines you want to allow before wrapping
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.right, // Align text to the right
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  maxLines: 1, // Allow only 1 line of text before wrapping
                  overflow: TextOverflow
                      .ellipsis, // Allow text to overflow if it doesn't fit
                ),
              ),
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
