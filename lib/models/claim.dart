class ClaimsResponse {
  final bool success;
  final ClaimsData data;

  ClaimsResponse({
    required this.success,
    required this.data,
  });

  factory ClaimsResponse.fromJson(Map<String, dynamic> json) {
    return ClaimsResponse(
      success: json['success'],
      data: ClaimsData.fromJson(json['data']),
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
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final dynamic nextPageUrl;
  final String path;
  final int perPage;
  final dynamic prevPageUrl;
  final int to;
  final int total;

  ClaimsData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ClaimsData.fromJson(Map<String, dynamic> json) {
    return ClaimsData(
      currentPage: json['current_page'],
      data: List<Claim>.from(json['data'].map((x) => Claim.fromJson(x))),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      links: List<PageLink>.from(json['links'].map((x) => PageLink.fromJson(x))),
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
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
      id: json['id'],
      studentId: json['student_id'],
      claimName: json['claim_name'],
      studentFullName: json['student_full_name'],
      studentNumber: json['student_number'],
      contactNumber: json['contact_number'],
      dateOfBirth: json['date_of_birth'],
      nameOfDeceased: json['name_of_deceased'],
      relationToDeceased: json['relation_to_deceased'],
      dateOfDeath: json['date_of_death'],
      placeOfDeath: json['place_of_death'],
      hospitalName: json['hospital_name'],
      doctorName: json['doctor_name'],
      mortuaryName: json['mortuary_name'],
      religiousBodyName: json['religious_body_name'],
      hasBodyBeenBuried: json['has_body_been_buried'],
      burialLocation: json['burial_location'],
      burialDate: json['burial_date'],
      level: json['level'],
      applicationStatus: json['application_status'],
      approvedByName: json['approved_by_name'],
      approvedAt: json['approved_at'],
      rejectionReason: json['rejection_reason'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      departmentName: json['department_name'],
      programName: json['program_name'],
      documents: List<ClaimDocument>.from(json['documents'].map((x) => ClaimDocument.fromJson(x))),
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
      id: json['id'],
      claimId: json['claim_id'],
      documentType: json['document_type'],
      filePath: json['file_path'],
      originalFilename: json['original_filename'],
      fileSize: json['file_size'],
      mimeType: json['mime_type'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      fileUrl: json['file_url'],
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
      url: json['url'],
      label: json['label'],
      active: json['active'],
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
