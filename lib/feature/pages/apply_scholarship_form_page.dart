import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:src_kstu_app/models/scholarship_type_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/services.dart'; 

class ApplyScholarshipFormPage extends StatefulWidget {
  final ScholarshipType scholarship;

  const ApplyScholarshipFormPage({
    super.key,
    required this.scholarship,
  });

  @override
  State<ApplyScholarshipFormPage> createState() =>
      _ApplyScholarshipFormPageState();
}

class _ApplyScholarshipFormPageState extends State<ApplyScholarshipFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _programmeController = TextEditingController();
  final TextEditingController _studentNumberController =
      TextEditingController();
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianOccupationController =
      TextEditingController();
  final TextEditingController _siblingsController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  bool _isParentAlive = true;
  bool _hasBenefitedBefore = false;

  Map<String, PlatformFile?> requiredDocuments = {};
  Map<String, PlatformFile?> optionalDocuments = {};

  @override
  void initState() {
    super.initState();
    getUser();
    for (var docType in widget.scholarship.requiredDocuments) {
      requiredDocuments[docType] = null;
    }
    for (var docType in widget.scholarship.optionalDocuments) {
      optionalDocuments[docType] = null;
    }
  }

  void getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = localStorage.getString('name') ?? '';
      _departmentController.text = localStorage.getString('department') ?? '';
      _phoneController.text = localStorage.getString('phone') ?? '';
      _programmeController.text = localStorage.getString('program') ?? '';
      _studentNumberController.text =
          localStorage.getInt('index')?.toString() ?? '';
    });
  }

  Future<void> _pickFile(String documentType, bool isRequired) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData:
            Platform.isIOS,
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFile = result.files.first;

        // Validate file on iOS
        if (Platform.isIOS) {
          // Check if file data is available
          if (pickedFile.bytes == null && pickedFile.path == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Unable to access the selected file')),
              );
            }
            return;
          }

          // Validate file size (optional, e.g., 10MB limit)
          if (pickedFile.size > 10 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File size exceeds 10MB limit')),
              );
            }
            return;
          }
        }

        // Validate file extension
        final extension = pickedFile.extension?.toLowerCase();
        if (extension == null ||
            !['pdf', 'jpg', 'jpeg', 'png'].contains(extension)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Invalid file type. Please select PDF, JPG, or PNG')),
            );
          }
          return;
        }

        if (mounted) {
          setState(() {
            if (isRequired) {
              requiredDocuments[documentType] = pickedFile;
            } else {
              optionalDocuments[documentType] = pickedFile;
            }
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${pickedFile.name} selected successfully'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        // User cancelled the picker
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No file selected'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Platform error: ${e.message ?? 'Unknown error'}'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: ${e.toString()}'),
          ),
        );
      }
    }
  }
  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('Personal Info', style: GoogleFonts.poppins()),
        content: _buildPersonalInfoStep(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Guardian Info', style: GoogleFonts.poppins()),
        content: _buildGuardianInfoStep(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Additional Info', style: GoogleFonts.poppins()),
        content: _buildAdditionalInfoStep(),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Documents', style: GoogleFonts.poppins()),
        content: _buildDocumentUploadStep(),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  Widget _buildPersonalInfoStep() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReadOnlyField(
              label: 'Full Name',
              value: _nameController.text,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Department',
              value: _departmentController.text,
              icon: Icons.local_fire_department,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Programme',
              value: _programmeController.text,
              icon: Icons.school_outlined,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Student Number',
              value: _studentNumberController.text,
              icon: Icons.numbers_outlined,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Phone Number',
              value: _phoneController.text,
              icon: Icons.phone_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
      {required String label, required String value, required IconData icon}) {
    return TextFormField(
        controller: TextEditingController(text: value),
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ));
  }

  Widget _buildGuardianInfoStep() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _guardianNameController,
              decoration: const InputDecoration(
                labelText: 'Guardian\'s Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter guardian name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Is Guardian Alive?',
                    style: GoogleFonts.poppins(fontSize: 13)),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isParentAlive,
                      onChanged: (value) =>
                          setState(() => _isParentAlive = value ?? true),
                    ),
                    const Text('Yes'),
                    Radio<bool>(
                      value: false,
                      groupValue: _isParentAlive,
                      onChanged: (value) =>
                          setState(() => _isParentAlive = !(value ?? false)),
                    ),
                    const Text('No'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _guardianOccupationController,
              decoration: const InputDecoration(
                labelText: 'Guardian\'s Occupation',
                prefixIcon: Icon(Icons.work_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter occupation';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _siblingsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of Siblings',
                prefixIcon: Icon(Icons.people_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of siblings';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoStep() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _reasonController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please explain why you need this scholarship';
                }
                return null;
              },
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Reason for Applying',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Are you a beneficiary?',
                    style: GoogleFonts.poppins(fontSize: 12)),
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _hasBenefitedBefore,
                      onChanged: (value) =>
                          setState(() => _hasBenefitedBefore = value ?? true),
                    ),
                    const Text('Yes', style: TextStyle(fontSize: 11),),
                    Radio<bool>(
                      value: false,
                      groupValue: _hasBenefitedBefore,
                      onChanged: (value) => setState(
                          () => _hasBenefitedBefore = !(value ?? false)),
                    ),
                    const Text('No', style: TextStyle(fontSize: 11),),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUploadStep() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Required Documents',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._buildDocumentUploadFields(requiredDocuments, true),
            if (widget.scholarship.optionalDocuments.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Optional Documents',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildDocumentUploadFields(optionalDocuments, false),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDocumentUploadFields(
      Map<String, PlatformFile?> documents, bool isRequired) {
    return documents.entries.map((entry) {
      final docType = entry.key;
      final file = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_formatDocumentType(docType),
              style: GoogleFonts.poppins(fontSize: 14)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    file?.name ?? 'No file selected',
                    style: TextStyle(
                      color: file == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _pickFile(docType, isRequired),
                child: const Text('Browse'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  String _formatDocumentType(String type) {
    return type.toLowerCase().split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Future<void> _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      for (var entry in requiredDocuments.entries) {
        if (entry.value == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Please upload ${_formatDocumentType(entry.key)}')),
          );
          return;
        }
      }

      setState(() => _isSubmitting = true);

      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? token = pref.getString("token");

        if (token == null) {
          throw Exception("User not authenticated");
        }

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$buildUrl/scholarships/apply'),
        );

        request.headers['Accept'] = 'application/json';
        request.headers['Authorization'] = 'Bearer $token';

        request.fields['scholarship_type_id'] =
            widget.scholarship.id.toString();
        request.fields['student_full_name'] = _nameController.text;
        request.fields['contact_number'] = _phoneController.text;
        request.fields['parent_guardian_name'] = _guardianNameController.text;
        request.fields['occupation'] = _guardianOccupationController.text;
        request.fields['needy_reason'] = _reasonController.text;
        request.fields['is_parent_alive'] = _isParentAlive ? '1' : '0';
        request.fields['number_of_siblings'] = _siblingsController.text;
        request.fields['benefited_previously'] =
            _hasBenefitedBefore ? '1' : '0';
        request.fields['student_department'] = _departmentController.text;
        request.fields['student_programme'] = _programmeController.text;
        request.fields['student_number'] = _studentNumberController.text;

        int docIndex = 0;
        for (var entry in requiredDocuments.entries) {
          if (entry.value != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'documents[$docIndex][file]',
              entry.value!.path!,
            ));
            request.fields['documents[$docIndex][document_type]'] = entry.key;
            docIndex++;
          }
        }
        for (var entry in optionalDocuments.entries) {
          if (entry.value != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'documents[$docIndex][file]',
              entry.value!.path!,
            ));
            request.fields['documents[$docIndex][document_type]'] = entry.key;
            docIndex++;
          }
        }
        final response = await request.send();
        final responseString = await response.stream.bytesToString();

        if (response.statusCode == 201) {
          final responseData = jsonDecode(responseString);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ??
                  'Application submitted successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          Navigator.of(context).pop();
        } else {
          final responseData = jsonDecode(responseString);
          throw Exception('${responseData['message'] ?? 'Unknown error'}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              textColor: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: topColor,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 40),
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
                    child: Container(
                      height: 20,
                      decoration: const BoxDecoration(
                        color: topColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: bottomColor,
                                    size: 25,
                                  ),
                                ),
                                Text(
                                  "${widget.scholarship.name}",
                                  style: GoogleFonts.poppins(
                                    color: bottomColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: bottomColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Stepper(
                          currentStep: _currentStep,
                          onStepContinue: () {
                            if (_currentStep < _buildSteps().length - 1) {
                              setState(() => _currentStep++);
                            } else {
                              _submitApplication();
                            }
                          },
                          onStepCancel: () {
                            if (_currentStep > 0) {
                              setState(() => _currentStep--);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          onStepTapped: (step) {
                            if (step <= _currentStep) {
                              setState(() => _currentStep = step);
                            }
                          },
                          steps: _buildSteps(),
                          controlsBuilder: (context, details) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  if (_currentStep != 0)
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: details.onStepCancel,
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: topColor),
                                        child: const Text('Back',
                                            style: TextStyle(
                                                color: Colors.white)),
                                      ),
                                    ),
                                  if (_currentStep != 0)
                                    const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: details.onStepContinue,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: headColor,
                                      ),
                                      child: _isSubmitting
                                          ? const Text(
                                              'Submitting...',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : Text(
                                              _currentStep ==
                                                      _buildSteps().length - 1
                                                  ? 'Submit'
                                                  : 'Next',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    _programmeController.dispose();
    _studentNumberController.dispose();
    _guardianNameController.dispose();
    _guardianOccupationController.dispose();
    _siblingsController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}
