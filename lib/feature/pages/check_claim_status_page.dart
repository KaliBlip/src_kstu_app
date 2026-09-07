import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/models/constant.dart';
import 'package:src_kstu_app/feature/pages/dashboard.dart';
import 'package:src_kstu_app/models/claim.dart';
import 'package:http/http.dart' as http;

class CheckClaimStatusPage extends StatefulWidget {
  const CheckClaimStatusPage({super.key});

  @override
  State<CheckClaimStatusPage> createState() => _CheckClaimStatusPageState();
}

class _CheckClaimStatusPageState extends State<CheckClaimStatusPage> {
  bool _isFetching = false;
  List<Claim> _applications = [];
  String _errorMessage = '';

  Future<void> _getAllUserScholarshipApplications() async {
    setState(() {
      _isFetching = true;
      _errorMessage = '';
    });

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final response = await http.get(
        Uri.parse("$buildUrl/claims/applications"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${pref.getString("token")}'
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          setState(() {
            _applications = (responseData['data']['data'] as List)
                .map((app) => Claim.fromJson(app))
                .toList();
          });
        } else {
          throw Exception('No application data found');
        }
      } else {
        throw Exception('Failed to load applications: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = 'Failed to load applications. Please try again.';
      });
    } finally {
      setState(() => _isFetching = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllUserScholarshipApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: topColor,
      body: Padding(
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
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(30))),
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
                              "Check Insurance Status",
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
                    flex: 8,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: bottomColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 26),
                            Text(
                              "Your Applications",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "View and manage your insurance applications",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 40),
                            _buildContent(),
                          ],
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

  Widget _buildContent() {
    if (_isFetching) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                "Loading applications...",
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: GoogleFonts.poppins(color: Colors.red.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: topColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _getAllUserScholarshipApplications,
                child: Text(
                  'Try Again',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_applications.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined,
                  color: Colors.grey.shade400, size: 64),
              const SizedBox(height: 16),
              Text(
                'No insurance applications found',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Apply for an insurance to see them here',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildStatusCard("Pending", Icons.hourglass_top,
                  _countByStatus("PENDING"), Colors.orange),
              const SizedBox(width: 12),
              _buildStatusCard("Under Review", Icons.sync,
                  _countByStatus("UNDER_REVIEW"), Colors.blue.shade400),
              const SizedBox(width: 12),
              _buildStatusCard("Approved", Icons.check_circle,
                  _countByStatus("APPROVED"), Colors.green),
              const SizedBox(width: 12),
              _buildStatusCard("Rejected", Icons.cancel,
                  _countByStatus("REJECTED"), Colors.red),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _applications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _buildApplicationCard(_applications[index]),
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, IconData icon, int count, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: headColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                count.toString(),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  int _countByStatus(String status) {
    return _applications
        .where((app) => app.applicationStatus.toUpperCase() == status)
        .length;
  }

  Widget _buildApplicationCard(Claim application) {
    final hasRejection = application.rejectionReason != null &&
        application.rejectionReason!.isNotEmpty;
    final hasApproval =
        application.applicationStatus.toUpperCase() == 'APPROVED';
    final isPending = application.applicationStatus.toUpperCase() == 'PENDING';
    final isInReview =
        application.applicationStatus.toUpperCase() == 'UNDER_REVIEW';
    final statusColor = _getStatusColor(application.applicationStatus);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: hasRejection ? () => _showRejectionDialog(application) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: headColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    application.claimName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasRejection)
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                if (hasApproval)
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade400,
                    size: 20,
                  ),
                if (isPending)
                  Icon(
                    Icons.hourglass_top,
                    color: Colors.orange.shade400,
                    size: 20,
                  ),
                if (isInReview)
                  Icon(
                    Icons.sync,
                    color: Colors.blue.shade400,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    application.applicationStatus,
                    style: GoogleFonts.poppins(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  application.createdAt.split(',').take(2).join(','),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'PENDING':
      default:
        return Colors.orange;
    }
  }

  void _showRejectionDialog(Claim application) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.1),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade400,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Application Rejected',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Insurance:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                application.claimName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Reason for Rejection:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  application.rejectionReason!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: topColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
