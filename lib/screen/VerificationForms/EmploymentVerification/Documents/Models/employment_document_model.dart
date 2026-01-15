class EmploymentDocumentsModel {
  final int status;
  final String message;
  final DocumentsData data;

  EmploymentDocumentsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory EmploymentDocumentsModel.fromJson(Map<String, dynamic> json) {
    return EmploymentDocumentsModel(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: DocumentsData.fromJson(json['data']),
    );
  }
}

class DocumentsData {
  final List<Document> documents;
  final int count;

  DocumentsData({
    required this.documents,
    required this.count,
  });

  factory DocumentsData.fromJson(Map<String, dynamic> json) {
    return DocumentsData(
      documents: (json['documents'] as List<dynamic>)
          .map((doc) => Document.fromJson(doc))
          .toList(),
      count: json['count'] ?? 0,
    );
  }
}

class Document {
  final int id;
  final String caseUuid;
  final String type;
  final String documentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Document({
    required this.id,
    required this.caseUuid,
    required this.type,
    required this.documentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? 0,
      caseUuid: json['case_uuid'] ?? '',
      type: json['type'] ?? '',
      documentUrl: json['document_url'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
