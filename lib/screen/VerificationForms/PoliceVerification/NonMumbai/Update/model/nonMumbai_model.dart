import 'dart:io';

class NonMumbaiUpdateModel {
  final String request_id;
  final String service_request_id;
  final String tenant_name;
  final String tenant_address;
  final String tenant_city;
  final String tenant_state;
  final String tenant_postal_code;
  final String tenant_identity_proof_doc_type;
  final String tenant_identity_proof_no;
  final String tenant_identification_mark;
  final String tenant_dob;
  final String tenant_birth_place;
  final String tenant_age;
  final String tenant_is_employed;
  final String? tenant_employed_year;
  final String? tenant_employed_month;
  final String? tenant_employer_or_company;
  final String tenant_fathers_name;
  final String tenant_fathers_address;
  final String tenant_fathers_occupation;
  final String tenant_contact_one_full_name;
  final String tenant_contact_one_address;
  final String tenant_contact_two_full_name;
  final String tenant_contact_two_address;
  final String tenant_has_criminal_offenses;
  final String tenant_crno_section;
  final String tenant_whether_arrested;
  final String tenant_present_case_status;
  final String tenant_earlier_residential_place;
  final String tenant_earlier_residential_months;
  final String tenant_earlier_residential_years;
  final String tenant_earlier_residential_jurisdiction_of_police_station;
  final String tenant_present_address_duration_years;
  final String tenant_present_address_duration_months;
  final String tenant_jurisdiction_of_police_station;
  final String tenant_present_resendential_place;
  final String tenant_signature_place;
  final String tenant_signature_date;
  final File tenant_photo;
  final File tenant_signature;
  final File tenant_identity_proof_doc;
  final File? tenant_letter_from_employer;

  NonMumbaiUpdateModel(
      {required this.request_id,
      required this.service_request_id,
      required this.tenant_name,
      required this.tenant_address,
      required this.tenant_city,
      required this.tenant_state,
      required this.tenant_postal_code,
      required this.tenant_identity_proof_doc_type,
      required this.tenant_identity_proof_no,
      required this.tenant_identification_mark,
      required this.tenant_dob,
      required this.tenant_birth_place,
      required this.tenant_age,
      required this.tenant_is_employed,
       this.tenant_employed_year,
       this.tenant_employed_month,
       this.tenant_employer_or_company,
      required this.tenant_fathers_name,
      required this.tenant_fathers_address,
      required this.tenant_fathers_occupation,
      required this.tenant_contact_one_full_name,
      required this.tenant_contact_one_address,
      required this.tenant_contact_two_full_name,
      required this.tenant_contact_two_address,
      required this.tenant_has_criminal_offenses,
      required this.tenant_crno_section,
      required this.tenant_whether_arrested,
      required this.tenant_present_case_status,
      required this.tenant_earlier_residential_place,
      required this.tenant_earlier_residential_months,
      required this.tenant_earlier_residential_years,
      required this.tenant_earlier_residential_jurisdiction_of_police_station,
      required this.tenant_present_address_duration_years,
      required this.tenant_present_address_duration_months,
      required this.tenant_jurisdiction_of_police_station,
      required this.tenant_present_resendential_place,
      required this.tenant_signature_place,
      required this.tenant_signature_date,
      required this.tenant_photo,
      required this.tenant_signature,
      required this.tenant_identity_proof_doc,
       this.tenant_letter_from_employer});

  // Convert a User object to a JSON object
  Map<String, dynamic> toJson()  {
    return {
      "request_id":request_id,
      "service_request_id": service_request_id,
      "tenant_name": tenant_name,
      "tenant_address": tenant_address,
      "tenant_city": tenant_city,
      "tenant_state": tenant_state,
      "tenant_postal_code": tenant_postal_code,
      "tenant_identity_proof_doc_type": tenant_identity_proof_no,
      "tenant_identity_proof_no": tenant_identity_proof_no,
      "tenant_identification_mark": tenant_identification_mark,
      "tenant_dob": tenant_dob,
      "tenant_birth_place": tenant_birth_place,
      "tenant_age": tenant_age,
      "tenant_is_employed": tenant_is_employed,
      "tenant_employed_year": tenant_employed_year,
      "tenant_employed_month": tenant_employed_month,
      "tenant_employer_or_company": tenant_employer_or_company,
      "tenant_fathers_name": tenant_fathers_name,
      "tenant_fathers_address": tenant_fathers_address,
      "tenant_fathers_occupation": tenant_fathers_occupation,
      "tenant_contact_one_full_name": tenant_contact_one_full_name,
      "tenant_contact_one_address": tenant_contact_one_address,
      "tenant_contact_two_full_name": tenant_contact_two_full_name,
      "tenant_contact_two_address": tenant_contact_two_address,
      "tenant_has_criminal_offenses": tenant_has_criminal_offenses,
      "tenant_crno_section": tenant_crno_section,
      "tenant_whether_arrested": tenant_whether_arrested,
      "tenant_present_case_status": tenant_present_case_status,
      "tenant_earlier_residential_place": tenant_earlier_residential_place,
      "tenant_earlier_residential_months": tenant_earlier_residential_months,
      "tenant_earlier_residential_years": tenant_earlier_residential_years,
      "tenant_earlier_residential_jurisdiction_of_police_station":
          tenant_earlier_residential_jurisdiction_of_police_station,
      "tenant_present_address_duration_years":
          tenant_present_address_duration_years,
      "tenant_present_address_duration_months":
          tenant_present_address_duration_months,
      "tenant_jurisdiction_of_police_station":
          tenant_jurisdiction_of_police_station,
      "tenant_present_resendential_place": tenant_present_resendential_place,
      "tenant_signature_place": tenant_signature_place,
      "tenant_signature_date": tenant_signature_date,
      "tenant_photo":tenant_photo,
      "tenant_signature":tenant_signature,
      "tenant_identity_proof_doc":tenant_identity_proof_doc,
      "tenant_letter_from_employer":tenant_letter_from_employer,
    };
  }
}
