import 'dart:io';

class UploadDocumentsNonMumbaiModel {
  final String request_id;
  final String service_request_id;
  final File tenant_photo;
  final File tenant_signature;
  final File tenant_identity_proof_doc;
  final File tenant_letter_from_employer;
  final File data_document;

  UploadDocumentsNonMumbaiModel(
      {required this.request_id,
      required this.service_request_id,
      required this.tenant_photo,
      required this.tenant_signature,
      required this.tenant_identity_proof_doc,
      required this.tenant_letter_from_employer,
      required this.data_document});

  Map<String, dynamic> toJson() {
    return {
      "request_id": request_id,
      "service_request_id": service_request_id,
      "tenant_photo": tenant_photo,
      "tenant_signature": tenant_signature,
      "tenant_identity_proof_doc": tenant_identity_proof_doc,
      "tenant_letter_from_employer": tenant_letter_from_employer,
      "data_document": data_document
    };
  }
}
