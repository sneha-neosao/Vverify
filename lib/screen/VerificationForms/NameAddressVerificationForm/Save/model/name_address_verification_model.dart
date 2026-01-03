import 'dart:io';

class NameAddressVerificationModel {
  final String request_id;
  final String service_request_id;
  final String person_name;
  final String address_line_1;
  final String address_line_2;
  final String city_id;
  final String pinCode;
  final File aadhaar_front_side;
  final File aadhaar_back_side;

  NameAddressVerificationModel({
      required this.request_id,
      required this.service_request_id,
      required this.person_name,
      required this.address_line_1,
      required this.address_line_2,
      required this.city_id,
      required this.pinCode,
      required this.aadhaar_front_side,
      required this.aadhaar_back_side});


}
