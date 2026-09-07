class ScholarshipType {
  final int id;
  final String name;
  final String? description;
  final String pdfFileUrl;
  final List<String> requiredDocuments;
  final List<String> optionalDocuments;

  ScholarshipType({
    required this.id,
    required this.name,
    this.description,
    required this.pdfFileUrl,
    required this.requiredDocuments,
    required this.optionalDocuments,
  });

  factory ScholarshipType.fromJson(Map<String, dynamic> json) {
    return ScholarshipType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pdfFileUrl: json['pdf_file_url'],
      requiredDocuments: List<String>.from(json['required_document_types']),
      optionalDocuments: List<String>.from(json['optional_document_types']),
    );
  }
}

class ScholarshipResponse {
  final List<ScholarshipType> scholarships;
  final PaginationData pagination;

  ScholarshipResponse({
    required this.scholarships,
    required this.pagination,
  });

  factory ScholarshipResponse.fromJson(Map<String, dynamic> json) {
    return ScholarshipResponse(
      scholarships: (json['data']['data'] as List)
          .map((item) => ScholarshipType.fromJson(item))
          .toList(),
      pagination: PaginationData.fromJson(json['data']),
    );
  }
}

class PaginationData {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;
  
  PaginationData({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });
  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      total: json['total'],
      perPage: json['per_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'total': total,
      'per_page': perPage,
    };
  }
  @override
  String toString() {
    return 'PaginationData(currentPage: $currentPage, lastPage: $lastPage, total: $total, perPage: $perPage)';
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationData &&
        other.currentPage == currentPage &&
        other.lastPage == lastPage &&
        other.total == total &&
        other.perPage == perPage;
  }
}