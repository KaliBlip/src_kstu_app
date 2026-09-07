class ScholarshipApplication {
  final int? id;
  final int? studentId;
  final String? scholarshipName;
  final String? studentFullName;
  final String? studentNumber;
  final String? contactNumber;
  final String? parentGuardianName;
  final String? occupation;
  final String? needyReason;
  final String? applicationStatus;
  final String? approvedByName;
  final String? approvedAt;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;
  final int? status;
  final bool? isParentAlive;
  final int? numberOfSiblings;
  final bool? benefitedPreviously;
  final String? departmentName;
  final String? programName;
  final List<ApplicationDocument> documents;

  ScholarshipApplication({
    this.id,
    this.studentId,
    this.scholarshipName,
    this.studentFullName,
    this.studentNumber,
    this.contactNumber,
    this.parentGuardianName,
    this.occupation,
    this.needyReason,
    this.applicationStatus,
    this.approvedByName,
    this.approvedAt,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.isParentAlive,
    this.numberOfSiblings,
    this.benefitedPreviously,
    this.departmentName,
    this.programName,
    required this.documents,
  });

  factory ScholarshipApplication.fromJson(Map<String, dynamic> json) {
    return ScholarshipApplication(
      id: json['id'],
      studentId: json['student_id'],
      scholarshipName: json['scholarship_name'],
      studentFullName: json['student_full_name'],
      studentNumber: json['student_number'],
      contactNumber: json['contact_number'],
      parentGuardianName: json['parent_guardian_name'],
      occupation: json['occupation'],
      needyReason: json['needy_reason'],
      applicationStatus: json['application_status'],
      approvedByName: json['approved_by_name'],
      approvedAt: json['approved_at'],
      rejectionReason: json['rejection_reason'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      isParentAlive: json['is_parent_alive'],
      numberOfSiblings: json['number_of_siblings'],
      benefitedPreviously: json['benefited_previously'],
      departmentName: json['department_name'],
      programName: json['program_name'],
      documents: (json['documents'] as List? ?? [])
          .map((doc) => ApplicationDocument.fromJson(doc))
          .toList(),
    );
  }
}

class ApplicationDocument {
  final int? id;
  final int? applicationId;
  final String documentType;
  final String? fileUrl;

  ApplicationDocument({
    this.id,
    this.applicationId,
    required this.documentType,
    this.fileUrl,
  });

  factory ApplicationDocument.fromJson(Map<String, dynamic> json) {
    return ApplicationDocument(
      id: json['id'],
      applicationId: json['application_id'],
      documentType: json['document_type'],
      fileUrl: json['file_url'],
    );
  }
}