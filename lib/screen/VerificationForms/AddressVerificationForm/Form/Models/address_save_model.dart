import 'dart:io';

class NameAddressVerificationModel {
  final String request_id;
  final String service_request_id;
  final String current_address_line_1;
  final String current_address_line_2;
  final String current_city_id;
  final String current_state;
  final String current_pinCode;
  // final String permanent_address_line_1;
  // final String permanent_address_line_2;
  // final String permanent_city_id;
  // final String permanent_state;
  // final String permanent_pinCode;
  // final String residing_from_date;
  // final String residing_to_date;
  final String data_preference;
  final String case_uuid;
  // final dynamic till_date;

  NameAddressVerificationModel({
    required this.request_id,
    required this.service_request_id,
    required this.current_address_line_1,
    required this.current_address_line_2,
    required this.current_city_id,
    required this.current_state,
    required this.current_pinCode,
    // required this.permanent_address_line_1,
    // required this.permanent_address_line_2,
    // required this.permanent_city_id,
    // required this.permanent_state,
    // required this.permanent_pinCode,
    // required this.residing_from_date,
    // required this.residing_to_date,
    required this.data_preference,
    required this.case_uuid,
    // required this.till_date
  });
}