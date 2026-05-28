import 'dart:io';

class EducationUpdateFormModel {
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

  EducationUpdateFormModel(
      {required this.uid,
      required this.request_id,
      required this.service_request_id,
      required this.university_name,
      required this.instituition_name,
      required this.year_of_passing,
      required this.degree_qualification_name,
      required this.grades_type,
      required this.grades_obtained,
      required this.case_uuid,
      required this.education_uuid});

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "university_name": university_name,
      "institution_name": instituition_name,
      "year_of_passing": year_of_passing,
      "degree_qualification_name": degree_qualification_name,
      "grades_type": grades_type,
      "grades_obtained": grades_obtained,
      "case_uuid": case_uuid,
      "education_uuid": education_uuid
    };
  }
}
