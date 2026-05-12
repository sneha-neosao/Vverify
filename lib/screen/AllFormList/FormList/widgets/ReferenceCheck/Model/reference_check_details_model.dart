class ReferenceCheckDetailsModel {
  int? status;
  String? message;
  ReferenceCheckDetailsData? data;

  ReferenceCheckDetailsModel({this.status, this.message, this.data});

  ReferenceCheckDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ReferenceCheckDetailsData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ReferenceCheckDetailsData {
  int? id;
  String? uid;
  int? requestId;
  int? serviceRequestId;
  String? personName1;
  String? personMobileNumber1;
  String? personEmail1;
  String? personAlternateMobile1;
  String? personRelation1;
  String? personName2;
  String? personMobileNumber2;
  String? personEmail2;
  String? personAlternateMobile2;
  String? personRelation2;
  String? status;
  String? reason;
  String? dataDocument;
  String? dataDocument2;
  String? dataPreference;

  ReferenceCheckDetailsData({
    this.id,
    this.uid,
    this.requestId,
    this.serviceRequestId,
    this.personName1,
    this.personMobileNumber1,
    this.personEmail1,
    this.personAlternateMobile1,
    this.personRelation1,
    this.personName2,
    this.personMobileNumber2,
    this.personEmail2,
    this.personAlternateMobile2,
    this.personRelation2,
    this.status,
    this.reason,
    this.dataDocument,
    this.dataDocument2,
    this.dataPreference,
  });

  ReferenceCheckDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'];
    requestId = json['request_id'];
    serviceRequestId = json['service_request_id'];
    personName1 = json['person_name_1'];
    personMobileNumber1 = json['person_mobile_number_1'];
    personEmail1 = json['person_email_1'];
    personAlternateMobile1 = json['person_alternate_mobile_1'];
    personRelation1 = json['person_relation_1'];
    personName2 = json['person_name_2'];
    personMobileNumber2 = json['person_mobile_number_2'];
    personEmail2 = json['person_email_2'];
    personAlternateMobile2 = json['person_alternate_mobile_2'];
    personRelation2 = json['person_relation_2'];
    status = json['status'];
    reason = json['reason'];
    dataDocument = json['data_document'];
    dataDocument2 = json['data_document_2'];
    dataPreference = json['data_preference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['request_id'] = requestId;
    data['service_request_id'] = serviceRequestId;
    data['person_name_1'] = personName1;
    data['person_mobile_number_1'] = personMobileNumber1;
    data['person_email_1'] = personEmail1;
    data['person_alternate_mobile_1'] = personAlternateMobile1;
    data['person_relation_1'] = personRelation1;
    data['person_name_2'] = personName2;
    data['person_mobile_number_2'] = personMobileNumber2;
    data['person_email_2'] = personEmail2;
    data['person_alternate_mobile_2'] = personAlternateMobile2;
    data['person_relation_2'] = personRelation2;
    data['status'] = status;
    data['reason'] = reason;
    data['data_document'] = dataDocument;
    data['data_document_2'] = dataDocument2;
    data['data_preference'] = dataPreference;
    return data;
  }
}
