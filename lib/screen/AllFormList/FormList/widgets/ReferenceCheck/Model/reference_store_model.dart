class ReferenceStoreModel {
  final String? serviceRequestId;
  final String? requestId;
  final String? customerId;
  final String? personName1;
  final String? personMobileNumber1;
  final String? personRelation1;
  final String? personEmail1;
  final String? personAlternateMobile1;
  final String? personName2;
  final String? personMobileNumber2;
  final String? personRelation2;
  final String? personEmail2;
  final String? personAlternateMobile2;

  ReferenceStoreModel({
    this.serviceRequestId,
    this.requestId,
    this.customerId,
    this.personName1,
    this.personMobileNumber1,
    this.personRelation1,
    this.personEmail1,
    this.personAlternateMobile1,
    this.personName2,
    this.personMobileNumber2,
    this.personRelation2,
    this.personEmail2,
    this.personAlternateMobile2,
  });

  Map<String, dynamic> toJson() {
    return {
      "service_request_id": serviceRequestId,
      "request_id": requestId,
      "customer_id": customerId,
      "person_name_1": personName1,
      "person_mobile_number_1": personMobileNumber1,
      "person_relation_1": personRelation1,
      "person_email_1": personEmail1,
      "person_alternate_mobile_1": personAlternateMobile1,
      "person_name_2": personName2,
      "person_mobile_number_2": personMobileNumber2,
      "person_relation_2": personRelation2,
      "person_email_2": personEmail2,
      "person_alternate_mobile_2": personAlternateMobile2,
    };
  }

  factory ReferenceStoreModel.fromJson(Map<String, dynamic> json) {
    return ReferenceStoreModel(
      serviceRequestId: json['service_request_id']?.toString(),
      requestId: json['request_id']?.toString(),
      customerId: json['customer_id']?.toString(),
      personName1: json['person_name_1'],
      personMobileNumber1: json['person_mobile_number_1'],
      personRelation1: json['person_relation_1'],
      personEmail1: json['person_email_1'],
      personAlternateMobile1: json['person_alternate_mobile_1'],
      personName2: json['person_name_2'],
      personMobileNumber2: json['person_mobile_number_2'],
      personRelation2: json['person_relation_2'],
      personEmail2: json['person_email_2'],
      personAlternateMobile2: json['person_alternate_mobile_2'],
    );
  }
}
