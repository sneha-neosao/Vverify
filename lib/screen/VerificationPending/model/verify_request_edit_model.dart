import 'dart:io';
class VerifyRequestEditModel {
  final String uid;
  final String request_id;
  final String service_request_id;
  final String university_name;
  final String instituition_name;
  final String year_of_passing;
  final String degree_qualification_name;
  final String grades_type;
  final String grades_obtained;
  final String case_uuid;
  final String education_uuid;

  VerifyRequestEditModel(
      {
        required this.uid,
        required this.request_id,
        required this.service_request_id,
        required this.university_name,
        required this.instituition_name,
        required this.year_of_passing,
        required this.degree_qualification_name,
        required this.grades_type,
        required this.grades_obtained,
        required this.case_uuid,
        required this.education_uuid
      });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "college_school_id": university_name,
      "course_degree_name": instituition_name,
      "course_degree_type": year_of_passing,
      "institution_address": degree_qualification_name,
      "institution_city": grades_type,
      "institution_state": grades_obtained,
      "case_uuid": case_uuid,
      "education_uuid": education_uuid
    };
  }
}



