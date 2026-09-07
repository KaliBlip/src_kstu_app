import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:http/http.dart' as http;

class DownloadScholarshipFormsPage extends StatefulWidget {
  const DownloadScholarshipFormsPage({super.key});

  @override
  State<DownloadScholarshipFormsPage> createState() =>
      _DownloadScholarshipFormsPageState();
}

const _kAppName = 'KSTU SRC App';

class _DownloadScholarshipFormsPageState
    extends State<DownloadScholarshipFormsPage> {
  List<Map<String, dynamic>> forms = [];
  bool _isLoading = false;
  double? _downloadProgress;
  bool isFetching = false;

  Future<void> getAllScholarshipForms() async {
    setState(() {
      isFetching = true;
    });
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await http.get(
        Uri.parse("$buildUrl/scholarships/types"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${pref.getString("token")}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['data'] is Map &&
            responseData['data']['data'] is List) {
          setState(() {
            forms =
                List<Map<String, dynamic>>.from(responseData['data']['data']);
          });
        } else {
          throw Exception('Unexpected data format: ${responseData['data']}');
        }
      } else {
        setState(() {
          isFetching = false;
        });
        throw Exception('Failed to load forms: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      setState(() {
        isFetching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllScholarshipForms();
  }

  Future<void> _downloadPdf(String url, String fileName) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _downloadProgress = 0;
    });

    try {
      Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getApplicationDocumentsDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }
      final appDir = Directory('${dir.path}/$_kAppName');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      final cleanFileName = fileName.replaceAll(RegExp(r'[^\w.-]'), '_');
      final savePath = '${appDir.path}/$cleanFileName.pdf';
      final file = File(savePath);

      await Dio().download(
        url.startsWith('http') ? url : '$asset_base_url/storage/$url',
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (await file.exists() && await file.length() > 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Download complete! '),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () => _openDownloadedFile(file.path),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        throw Exception('File was not saved correctly');
      }
    } catch (e, stackTrace) {
      debugPrint('Download error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _downloadPdf(url, fileName),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _downloadProgress = null;
        });
      }
    }
  }

  Future<void> _openDownloadedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File not found')),
          );
        }
        return;
      }
      if (Platform.isIOS) {
        final result = await Share.shareXFiles(
          [XFile(filePath)],
          subject: 'Open file',
        );

        if (result.status == ShareResultStatus.unavailable && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No app available to open this file')),
          );
        }
      } else {
        await Share.shareXFiles([XFile(filePath)]);
      }
    } catch (e) {
      if (mounted) {
        print("Error opening file: ${e}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening file: ${e.toString()}')),
        );
      }
    }
  }


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
                                "Download Scholarship Forms",
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
                                  'Download the required scholarship forms',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: CustomScrollView(
                                  slivers: [
                                    if (_isLoading && _downloadProgress != null)
                                      SliverToBoxAdapter(
                                        child: LinearProgressIndicator(
                                          value: _downloadProgress,
                                          backgroundColor: Colors.grey[200],
                                          minHeight: 6,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  topColor),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    if (isFetching)
                                      SliverFillRemaining(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: topColor,
                                          ),
                                        ),
                                      )
                                    else if (forms.isEmpty)
                                      SliverFillRemaining(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.folder_off,
                                                  size: 60,
                                                  color: Colors.grey[300]),
                                              SizedBox(height: 16),
                                              Text(
                                                'No forms available',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final form = forms[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 8),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                onTap: _isLoading
                                                    ? null
                                                    : () => _downloadPdf(
                                                        form['pdf_file_url']!,
                                                        form['name']!),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: topColor
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .picture_as_pdf,
                                                              color: topColor,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 16),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                form['name']!,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                'PDF Document',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .grey[
                                                                      500],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .download_rounded,
                                                          color: topColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: forms.length,
                                        ),
                                      )
                                  ],
                                ),
                              ),
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
