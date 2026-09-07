import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/feature/pages/apply_scholarship_form_page.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:src_kstu_app/models/scholarship_type_model.dart';

class ApplyScholarshipPage extends StatefulWidget {
  const ApplyScholarshipPage({super.key});

  @override
  State<ApplyScholarshipPage> createState() => _ApplyScholarshipPageState();
}

const _kAppName = 'KSTU SRC App';

class _ApplyScholarshipPageState extends State<ApplyScholarshipPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedScholarship;
  final bool _isSubmitting = false;
  List<ScholarshipType> forms = [];

  bool _isLoading = false;
  double? _downloadProgress;

  bool isFteching = false;

  Future<void> getAllScholarshipForms() async {
    setState(() => isFteching = true);

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
        final scholarshipResponse = ScholarshipResponse.fromJson(responseData);

        setState(() {
          forms = scholarshipResponse.scholarships;
        });
      } else {
        throw Exception('Failed to load forms: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load scholarship types')),
      );
    } finally {
      setState(() => isFteching = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllScholarshipForms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: topColor,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bottomColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: 40),
                        _buildScholarshipTypeSelectField(),
                        const SizedBox(height: 40),
                        _buildScholarshipInfoCard(),
                        const SizedBox(height: 40),
                        _buildApplyButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: topColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 40,),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: bottomColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Apply for Scholarship",
                style: GoogleFonts.poppins(
                  color: bottomColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          'KsTU Scholarship Application',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Select the scholarship type you qualify for and submit your application. '
          'Our team will review your application and get back to you.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: headColor,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScholarshipTypeSelectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scholarship Type *',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedScholarship,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: forms.map((form) {
              return DropdownMenuItem<String>(
                value: form.name,
                child: Text(
                  form.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedScholarship = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a scholarship type';
              }
              return null;
            },
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[800],
            ),
            icon: const Icon(Icons.keyboard_arrow_down),
            isExpanded: true,
            borderRadius: BorderRadius.circular(10),
            hint: Text(
              'Select scholarship type',
              style: GoogleFonts.poppins(
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScholarshipInfoCard() {
    if (_selectedScholarship == null) return const SizedBox.shrink();

    final selected = forms.firstWhere(
      (form) => form.name == _selectedScholarship,
      orElse: () => ScholarshipType(
        id: -1,
        name: '',
        pdfFileUrl: '',
        requiredDocuments: [],
        optionalDocuments: [],
      ),
    );

    if (selected.id == -1) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                selected.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: headColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Required Documents:',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: headColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildDocumentList(selected.requiredDocuments),
          if (selected.optionalDocuments.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Optional Documents:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: headColor,
              ),
            ),
            const SizedBox(height: 8),
            _buildDocumentList(selected.optionalDocuments),
          ],
          const SizedBox(height: 12),
          if (selected.pdfFileUrl.isNotEmpty)
            ElevatedButton(
              onPressed: () => _downloadPdf(selected.pdfFileUrl, selected.name),
              style: ElevatedButton.styleFrom(backgroundColor: headColor),
              child: _isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Downloading... ${(_downloadProgress! * 100).toStringAsFixed(0)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                      ],
                    )
                  : Text('Download Application Form',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      )),
            ),
        ],
      ),
    );
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

  Widget _buildDocumentList(List<String> documents) {
    return Column(
      children: documents
          .map((doc) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 16, color: headColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatDocumentType(doc),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  String _formatDocumentType(String type) {
    return type.toLowerCase().split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ApplyScholarshipFormPage(
                        scholarship: forms.firstWhere(
                          (form) => form.name == _selectedScholarship,
                          orElse: () => ScholarshipType(
                            id: -1,
                            name: '',
                            pdfFileUrl: '',
                            requiredDocuments: [],
                            optionalDocuments: [],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: topColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          shadowColor: topColor.withOpacity(0.3),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.send, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Apply Now',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
