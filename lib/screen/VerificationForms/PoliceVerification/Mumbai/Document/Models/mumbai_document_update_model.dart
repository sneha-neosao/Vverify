import 'dart:io';

class UpdateDocumentsMumbaiModel {
  final String request_id;
  final String service_request_id;
  final String police_station_id;
  final File tenant_photo;
  final File tenant_signature;
  final File tenant_identity_proof_doc;
  final File owner_photo;
  final File data_document;

  UpdateDocumentsMumbaiModel(
      {required this.request_id,
        required this.service_request_id,
        required this.police_station_id,
        required this.tenant_photo,
        required this.tenant_signature,
        required this.tenant_identity_proof_doc,
        required this.owner_photo,
        required this.data_document});

  Map<String, dynamic> toJson() {
    return {
      "request_id": request_id,
      "service_request_id": service_request_id,
      "police_station_id": police_station_id,
      "tenant_photo": tenant_photo,
      "tenant_signature": tenant_signature,
      "tenant_identity_proof_doc": tenant_identity_proof_doc,
      "tenant_letter_from_employer": owner_photo,
      "data_document": data_document
    };
  }
}
