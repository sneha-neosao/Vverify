import 'dart:io';
import 'package:dio/dio.dart';

class EmploymentSaveFormModel {
  final String request_id;
  final String service_request_id;
  final String customer_id;
  final String employer_name;
  final String employed_from;
  final String employed_to;
  final String designation;
  final String remunaration;
  final String reporting_manager;
  final String reason_for_leaving;
  final String employment_supporting_doc;

  EmploymentSaveFormModel({
    required this.request_id,
    required this.service_request_id,
    required this.customer_id,
    required this.employer_name,
    required this.employed_from,
    required this.employed_to,
    required this.designation,
    required this.remunaration,
    required this.reporting_manager,
    required this.reason_for_leaving,
    required this.employment_supporting_doc
  });
}