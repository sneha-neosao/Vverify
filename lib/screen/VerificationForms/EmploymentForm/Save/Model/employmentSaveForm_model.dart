import 'dart:io';
import 'package:dio/dio.dart';

class EmploymentSaveFormModel {
  final String request_id;
  final String service_request_id;
  final String full_name;
  final String company_name;
  final String company_address;
  final String company_city;
  final String company_state;
  final String company_country;
  final String company_postal_code;
  final String industry;
  final String job_title;
  final String department;
  final String employee_code_id;
  final String joining_date;
  final String joining_date_format;
  final String exit_date;
  final String leaving_date_format;
  final String experience_years;
  final String experience_months;
  final String reason_for_leaving;
  final String salary;
  final String currency;
  final String salaryDrawn;
  final String hr_contact_name;
  final String hr_contact_email;
  final String hr_contact_phone;
  final String employment_certificate_number;
  //final File employment_letter_doc;
  final File employment_supporting_doc;
  final String show_on_report;
  final String other_reason_for_leaving;

  EmploymentSaveFormModel(

      {required this.request_id,
      required this.service_request_id,
      required this.full_name,
      required this.company_name,
      required this.company_address,
      required this.company_city,
      required this.company_state,
      required this.company_country,
      required this.company_postal_code,
      required this.industry,
      required this.job_title,
      required this.department,
      required this.employee_code_id,
      required this.joining_date,
      required this.joining_date_format,
      required this.exit_date,
      required this.leaving_date_format,
      required this.experience_years,
      required this.experience_months,
      required this.reason_for_leaving,
      required this.salary,
      required this.currency,
      required this.salaryDrawn,
      required this.hr_contact_name,
      required  this.hr_contact_email,
      required this.hr_contact_phone,
      required this.employment_certificate_number,
     // required this.employment_letter_doc,
      required this.employment_supporting_doc,
      required this.show_on_report,
      required this.other_reason_for_leaving
      });




  // Map<String, dynamic> toJson() {
  //   return {
  //     "request_id":request_id,
  //     "service_request_id":service_request_id,
  //     "full_name":full_name,
  //     "company_name":company_name,
  //     "company_address":company_address,
  //     "company_city":company_city,
  //     "company_state":company_state,
  //     "company_country":company_country,
  //     "company_postal_code":company_postal_code,
  //     "industry":industry,
  //     "employment_type":employment_type,
  //     "job_title":job_title,
  //     "department":department,
  //     "employee_code_id":employee_code_id,
  //     "joining_date":joining_date,
  //     "exit_date":exit_date,
  //     "experience_years":experience_years,
  //     "experience_months":experience_months,
  //     "employment_status":employment_status,
  //     "salary":salary,
  //     "currency":currency,
  //     "pay_frequency":pay_frequency,
  //     "hr_contact_name":hr_contact_name,
  //     "employment_certificate_number":employment_certificate_number,
  //     "employment_letter_doc":employment_letter_doc,
  //     "employment_supporting_doc":employment_supporting_doc
  //   };
  // }
}
