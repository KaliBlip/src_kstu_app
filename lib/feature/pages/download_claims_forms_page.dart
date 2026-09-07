import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/components/scholarship_forms.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';

class DownloadClaimsFormsPage extends StatefulWidget {
  const DownloadClaimsFormsPage({super.key});

  @override
  State<DownloadClaimsFormsPage> createState() => _DownloadClaimsFormsPageState();
}

class _DownloadClaimsFormsPageState extends State<DownloadClaimsFormsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: topColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Row(children: [
                  Container(
                    color: bottomColor,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                  Container(
                    color: topColor,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ]),
                Column(
                  children: [
                    Expanded(
                        // flex: 1,
                        child: Container(
                      height: 20,
                      decoration: const BoxDecoration(
                          color: topColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10),
                        child: Column(children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()),
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: bottomColor,
                                  size: 25,
                                ),
                              ),
                              Text(
                                "Download Insurance Forms",
                                style: GoogleFonts.poppins(
                                    color: bottomColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ]),
                      ),
                    )),
                    Expanded(
                      flex: 9,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: bottomColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20.0, left: 20),
                                child: Text(
                                  'Available Forms',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 8.0),
                                child: Text(
                                  'Download the required insurance claims forms',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              ScholarshipForms(
                                  apiPath: "api/v1/claims/types",
                                  emptyMessage:
                                      "No insurance claims/cover forms available",
                                  isExpanded: true)
                            ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}