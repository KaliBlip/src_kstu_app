class ClaimsResponse {
  final bool success;
  final ClaimsData data;

  ClaimsResponse({
    required this.success,
    required this.data,
  });

  factory ClaimsResponse.fromJson(Map<String, dynamic> json) {
    return ClaimsResponse(
      success: json['success'] == true,
      data: ClaimsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class ClaimsData {
  final int currentPage;
  final List<Claim> data;
  final String firstPageUrl;
  final int? from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;
  final int total;

  ClaimsData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory ClaimsData.fromJson(Map<String, dynamic> json) {
    return ClaimsData(
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page']?.toString() ?? '') ?? 1,
      data: json['data'] is List
          ? List<Claim>.from(
              (json['data'] as List).map((x) => Claim.fromJson(x as Map<String, dynamic>)))
          : [],
      firstPageUrl: json['first_page_url']?.toString() ?? '',
      from: json['from'] is int
          ? json['from']
          : int.tryParse(json['from']?.toString() ?? ''),
      lastPage: json['last_page'] is int
          ? json['last_page']
          : int.tryParse(json['last_page']?.toString() ?? '') ?? 1,
      lastPageUrl: json['last_page_url']?.toString() ?? '',
      links: json['links'] is List
          ? List<PageLink>.from(
              (json['links'] as List).map((x) => PageLink.fromJson(x as Map<String, dynamic>)))
          : [],
      nextPageUrl: json['next_page_url']?.toString(),
      path: json['path']?.toString() ?? '',
      perPage: json['per_page'] is int
          ? json['per_page']
          : int.tryParse(json['per_page']?.toString() ?? '') ?? 10,
      prevPageUrl: json['prev_page_url']?.toString(),
      to: json['to'] is int
          ? json['to']
          : int.tryParse(json['to']?.toString() ?? ''),
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': List<dynamic>.from(links.map((x) => x.toJson())),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class Claim {
  final int id;
  final int studentId;
  final String claimName;
  final String studentFullName;
  final String studentNumber;
  final String contactNumber;
  final String dateOfBirth;
  final String nameOfDeceased;
  final String relationToDeceased;
  final String dateOfDeath;
  final String placeOfDeath;
  final String hospitalName;
  final String doctorName;
  final String mortuaryName;
  final String religiousBodyName;
  final bool hasBodyBeenBuried;
  final String burialLocation;
  final String burialDate;
  final String level;
  final String applicationStatus;
  final String? approvedByName;
  final String? approvedAt;
  final String? rejectionReason;
  final String createdAt;
  final String updatedAt;
  final int status;
  final String departmentName;
  final String programName;
  final List<ClaimDocument> documents;

  Claim({
    required this.id,
    required this.studentId,
    required this.claimName,
    required this.studentFullName,
    required this.studentNumber,
    required this.contactNumber,
    required this.dateOfBirth,
    required this.nameOfDeceased,
    required this.relationToDeceased,
    required this.dateOfDeath,
    required this.placeOfDeath,
    required this.hospitalName,
    required this.doctorName,
    required this.mortuaryName,
    required this.religiousBodyName,
    required this.hasBodyBeenBuried,
    required this.burialLocation,
    required this.burialDate,
    required this.level,
    required this.applicationStatus,
    this.approvedByName,
    this.approvedAt,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.departmentName,
    required this.programName,
    required this.documents,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      studentId: json['student_id'] is int
          ? json['student_id']
          : int.tryParse(json['student_id']?.toString() ?? '') ?? 0,
      claimName: json['claim_name']?.toString() ?? '',
      studentFullName: json['student_full_name']?.toString() ?? '',
      studentNumber: json['student_number']?.toString() ?? '',
      contactNumber: json['contact_number']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString() ?? '',
      nameOfDeceased: json['name_of_deceased']?.toString() ?? '',
      relationToDeceased: json['relation_to_deceased']?.toString() ?? '',
      dateOfDeath: json['date_of_death']?.toString() ?? '',
      placeOfDeath: json['place_of_death']?.toString() ?? '',
      hospitalName: json['hospital_name']?.toString() ?? '',
      doctorName: json['doctor_name']?.toString() ?? '',
      mortuaryName: json['mortuary_name']?.toString() ?? '',
      religiousBodyName: json['religious_body_name']?.toString() ?? '',
      hasBodyBeenBuried: json['has_body_been_buried'] == true ||
          json['has_body_been_buried'] == 1 ||
          json['has_body_been_buried'] == '1',
      burialLocation: json['burial_location']?.toString() ?? '',
      burialDate: json['burial_date']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      applicationStatus: json['application_status']?.toString() ?? 'PENDING',
      approvedByName: json['approved_by_name']?.toString(),
      approvedAt: json['approved_at']?.toString(),
      rejectionReason: json['rejection_reason']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '') ?? 0,
      departmentName: json['department_name']?.toString() ?? '',
      programName: json['program_name']?.toString() ?? '',
      documents: json['documents'] is List
          ? List<ClaimDocument>.from(
              (json['documents'] as List).map((x) => ClaimDocument.fromJson(x as Map<String, dynamic>)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'claim_name': claimName,
      'student_full_name': studentFullName,
      'student_number': studentNumber,
      'contact_number': contactNumber,
      'date_of_birth': dateOfBirth,
      'name_of_deceased': nameOfDeceased,
      'relation_to_deceased': relationToDeceased,
      'date_of_death': dateOfDeath,
      'place_of_death': placeOfDeath,
      'hospital_name': hospitalName,
      'doctor_name': doctorName,
      'mortuary_name': mortuaryName,
      'religious_body_name': religiousBodyName,
      'has_body_been_buried': hasBodyBeenBuried,
      'burial_location': burialLocation,
      'burial_date': burialDate,
      'level': level,
      'application_status': applicationStatus,
      'approved_by_name': approvedByName,
      'approved_at': approvedAt,
      'rejection_reason': rejectionReason,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'status': status,
      'department_name': departmentName,
      'program_name': programName,
      'documents': List<dynamic>.from(documents.map((x) => x.toJson())),
    };
  }
}

class ClaimDocument {
  final int id;
  final int claimId;
  final String documentType;
  final String filePath;
  final String originalFilename;
  final String fileSize;
  final String mimeType;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String fileUrl;

  ClaimDocument({
    required this.id,
    required this.claimId,
    required this.documentType,
    required this.filePath,
    required this.originalFilename,
    required this.fileSize,
    required this.mimeType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.fileUrl,
  });

  factory ClaimDocument.fromJson(Map<String, dynamic> json) {
    return ClaimDocument(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      claimId: json['claim_id'] is int
          ? json['claim_id']
          : int.tryParse(json['claim_id']?.toString() ?? '') ?? 0,
      documentType: json['document_type']?.toString() ?? '',
      filePath: json['file_path']?.toString() ?? '',
      originalFilename: json['original_filename']?.toString() ?? '',
      fileSize: json['file_size']?.toString() ?? '',
      mimeType: json['mime_type']?.toString() ?? '',
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '') ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      fileUrl: json['file_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'claim_id': claimId,
      'document_type': documentType,
      'file_path': filePath,
      'original_filename': originalFilename,
      'file_size': fileSize,
      'mime_type': mimeType,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'file_url': fileUrl,
    };
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url']?.toString(),
      label: json['label']?.toString() ?? '',
      active: json['active'] == true || json['active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
