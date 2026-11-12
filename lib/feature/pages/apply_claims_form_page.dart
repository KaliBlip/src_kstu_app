import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:src_kstu_app/models/scholarship_type_model.dart';
import 'package:http/http.dart' as http;

class ApplyClaimsFormPage extends StatefulWidget {
  final ScholarshipType scholarship;
  const ApplyClaimsFormPage({super.key, required this.scholarship});

  @override
  State<ApplyClaimsFormPage> createState() => _ApplyClaimsFormPageState();
}

class _ApplyClaimsFormPageState extends State<ApplyClaimsFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _programmeController = TextEditingController();
  final TextEditingController _studentNumberController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nameofDeceasedController =
      TextEditingController();
  final TextEditingController _relationtoDeceasedController =
      TextEditingController();
  final TextEditingController _levelofEducationController =
      TextEditingController();
  final TextEditingController _dateofDeathController = TextEditingController();
  final TextEditingController _placeofDeathController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _nameofDoctorController = TextEditingController();
  final TextEditingController _nameofMutuaryController =
      TextEditingController();
  final TextEditingController _nameofReligiousBodyController =
      TextEditingController();
  final TextEditingController _burialLocationController =
      TextEditingController();
  final TextEditingController _dateofBurialController = TextEditingController();
  bool _hasthebodyBeenBuried = true;

  Map<String, PlatformFile?> requiredDocuments = {};
  Map<String, PlatformFile?> optionalDocuments = {};

  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger ??= ScaffoldMessenger.of(context);
  }

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

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
    _programmeController.dispose();
    _studentNumberController.dispose();
    _dobController.dispose();
    _nameofDeceasedController.dispose();
    _relationtoDeceasedController.dispose();
    _levelofEducationController.dispose();
    _dateofDeathController.dispose();
    _placeofDeathController.dispose();
    _hospitalNameController.dispose();
    _nameofDoctorController.dispose();
    _nameofMutuaryController.dispose();
    _nameofReligiousBodyController.dispose();
    _burialLocationController.dispose();
    _dateofBurialController.dispose();
    super.dispose();
  }

  void getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = localStorage.getString('name') ?? '';
      _departmentController.text = localStorage.getString('department') ?? '';
      _phoneController.text = localStorage.getString('phone') ?? '';
      _levelofEducationController.text = localStorage.getString('level') ?? '';
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
      );

      if (result != null) {
        setState(() {
          if (isRequired) {
            requiredDocuments[documentType] = result.files.first;
          } else {
            optionalDocuments[documentType] = result.files.first;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
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
        title: Text('Deceased Info', style: GoogleFonts.poppins()),
        content: _buildGuardianInfoStep(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
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
            const SizedBox(height: 16),
            _buildReadOnlyField(
              label: 'Level of Education',
              value: _levelofEducationController.text,
              icon: Icons.leak_remove_outlined,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dobController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameofDeceasedController,
                decoration: const InputDecoration(
                  labelText: 'Name of Deceased',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name of deceased';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _relationtoDeceasedController,
                decoration: const InputDecoration(
                    labelText: 'Relation to Deceased',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "E.g Mother, Father, Sibling"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name of deceased';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateofDeathController,
                decoration: InputDecoration(
                  labelText: 'Date of Death',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dateofDeathController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _placeofDeathController,
                decoration: const InputDecoration(
                    labelText: 'Place of Death',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "E.g Kumasi, Tema, Ashaiman"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter place of death';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hospitalNameController,
                decoration: const InputDecoration(
                    labelText: 'Name of Hospital',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "E.g West Hospital, Accra General Hospital"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter place of death';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameofDoctorController,
                decoration: const InputDecoration(
                    labelText: 'Name of Doctor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "E.g Dr. Kofi, Dr. Kwame"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameofMutuaryController,
                decoration: const InputDecoration(
                  labelText: 'Name of Mortuary',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameofReligiousBodyController,
                decoration: const InputDecoration(
                    labelText: 'Name of Religious Body',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "Instition handling funeral/burrial"),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Body been buried?',
                      style: GoogleFonts.poppins(fontSize: 13)),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _hasthebodyBeenBuried,
                        onChanged: (value) => setState(
                            () => _hasthebodyBeenBuried = value ?? true),
                      ),
                      const Text('Yes'),
                      Radio<bool>(
                        value: false,
                        groupValue: _hasthebodyBeenBuried,
                        onChanged: (value) => setState(
                            () => _hasthebodyBeenBuried = value ?? false),
                      ),
                      const Text('No'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _burialLocationController,
                decoration: const InputDecoration(
                    labelText: 'Burial Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    hintText: "E.g Kumasi, Tema, Ashaiman"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateofBurialController,
                decoration: InputDecoration(
                  labelText: 'Date of Burial',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dateofBurialController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
            ],
          ),
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
          _showSnackBar(
            SnackBar(
                content: Text('${_formatDocumentType(entry.key)} is required'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          );
          return;
        }
      }

      setState(() => _isSubmitting = true);

      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? token = pref.getString("token");

        if (token == null) {
          _showSnackBar(
            SnackBar(
                content: const Text('You are not logged in'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          );
          return;
        }

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('$buildUrl/claims/apply'),
        );

        request.headers['Accept'] = 'application/json';
        request.headers['Authorization'] = 'Bearer $token';

        request.fields['claim_type_id'] = widget.scholarship.id.toString();
        request.fields['student_full_name'] = _nameController.text;
        request.fields['level'] = _levelofEducationController.text;
        request.fields['contact_number'] = _phoneController.text;
        request.fields['name_of_deceased'] = _nameofDeceasedController.text;
        request.fields['relation_to_deceased'] =
            _relationtoDeceasedController.text;
        request.fields['date_of_death'] = _dateofDeathController.text;
        request.fields['place_of_death'] = _placeofDeathController.text;
        request.fields['hospital_name'] = _hospitalNameController.text;
        request.fields['doctor_name'] = _nameofDoctorController.text;
        request.fields['mortuary_name'] = _nameofMutuaryController.text;
        request.fields['religious_body_name'] =
            _nameofReligiousBodyController.text;
        request.fields['burial_location'] = _burialLocationController.text;
        request.fields['burial_date'] = _dateofBurialController.text;
        request.fields['has_body_been_buried'] =
            _hasthebodyBeenBuried ? '1' : '0';
        request.fields['date_of_birth'] = _dobController.text;
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
          _showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
          if (mounted) Navigator.of(context).pop();
        } else {
          final responseData = jsonDecode(responseString);
          throw Exception(responseData['message']);
        }
      } catch (e) {
        _showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: topColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.sizeOf(context).width,
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
      ),
    );
  }
}
