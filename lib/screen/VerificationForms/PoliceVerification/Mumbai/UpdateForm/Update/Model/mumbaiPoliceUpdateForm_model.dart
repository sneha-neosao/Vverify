import 'dart:io';
class MumbaiUpdateModel {
  final String request_id;
  final String service_request_id;
  final int police_station_id;
  final String rented_address;
  final String rented_city;
  final String rented_state;
  final String rented_postal_code;
  final String agreement_start_date;
  final String agreement_end_date;
  final String owner_full_name;
  final String owner_mob_no;
  final String owner_email;
  final String owner_address;
  final String owner_city_district;
  final String owner_state;
  final String owner_postal_code;
  final String tenant_name;
  final String tenant_address;
  final String tenant_city;
  final String tenant_state;
  final String tenant_postal_code;
  final String tenant_identity_proof_doc_type;
  final String tenant_identity_proof_no;
  final String tenant_co_resident_males_no;
  final String tenant_co_resident_females_no;
  final String tenant_work_postal_code;
  final String tenant_co_resident_children_no;
  final String tenant_work_phone;
  final String tenant_work_email;
  final String tenant_occupation;
  final String tenant_work_place_address;
  final String tenant_work_city;
  final String tenant_work_state;
  final String tenant_contact_one_full_name;
  final String tenant_contact_one_phone;
  final String tenant_contact_two_full_name;
  final String tenant_contact_two_phone;
  final String agent_name;
  final String agent_details;
  final File owner_photo;
  final File tenant_photo;
  final File tenant_identity_proof_doc;
  final File tenant_signature;
  final int city_id;

  MumbaiUpdateModel( {
    required this.request_id,
    required this.service_request_id,
    required this.police_station_id,
    required this.rented_address,
    required this.rented_city,
    required this.rented_state,
    required this.rented_postal_code,
    required this.agreement_start_date,
    required this.agreement_end_date,
    required this.owner_full_name,
    required this.owner_mob_no,
    required this.owner_email,
    required this.owner_address,
    required this.owner_city_district,
    required this.owner_state,
    required this.owner_postal_code,
    required this.tenant_name,
    required this.tenant_address,
    required this.tenant_city,
    required this.tenant_state,
    required this.tenant_postal_code,
    required this.tenant_identity_proof_doc_type,
    required this.tenant_identity_proof_no,
    required this.tenant_co_resident_males_no,
    required this.tenant_co_resident_females_no,
    required this.tenant_co_resident_children_no,
    required this.tenant_work_phone,
    required this.tenant_work_email,
    required this.tenant_occupation,
    required this.tenant_work_place_address,
    required this.tenant_work_city,
    required this.tenant_work_state,
    required this.tenant_work_postal_code,
    required this.tenant_contact_one_full_name,
    required this.tenant_contact_one_phone,
    required this.tenant_contact_two_full_name,
    required this.tenant_contact_two_phone,
    required this.agent_name,
    required this.agent_details,
    required this.owner_photo,
    required this.tenant_photo,
    required this.tenant_identity_proof_doc,
    required this.tenant_signature,
    required this.city_id,
  }
      );

  Map<String, dynamic> toJson() {
    return {
      "request_id": request_id,
      "service_request_id": service_request_id,
      "police_station_id": police_station_id,
      "rented_address": rented_address,
      "rented_city": rented_city,
      "rented_state": rented_state,
      "rented_postal_code": rented_postal_code,
      'agreement_start_date': agreement_start_date,
      "agreement_end_date": agreement_end_date,
      "owner_full_name": owner_full_name,
      "owner_mob_no": owner_mob_no,
      "owner_email": owner_email,
      "owner_address": owner_address,
      "owner_city_district":owner_city_district,
      "owner_state":owner_state,
      "owner_postal_code":owner_postal_code,
      "tenant_name":tenant_name,
      "tenant_address":tenant_address,
      "tenant_city": tenant_city,
      "tenant_state": tenant_state,
      "tenant_postal_code": tenant_postal_code,
      "tenant_identity_proof_doc_type": tenant_identity_proof_doc_type,
      "tenant_identity_proof_no": tenant_identity_proof_no,
      "tenant_co_resident_males_no": tenant_co_resident_males_no,
      "tenant_co_resident_females_no":tenant_co_resident_females_no,
      "tenant_co_resident_children_no": tenant_co_resident_children_no,
      "tenant_work_phone": tenant_work_phone,
      "tenant_work_email": tenant_work_email,
      "tenant_occupation": tenant_occupation,
      "tenant_work_place_address": tenant_work_place_address,
      "tenant_work_city": tenant_work_city,
      "tenant_work_state": tenant_work_state,
      "tenant_work_postal_code":tenant_work_postal_code,
      "tenant_contact_one_full_name": tenant_contact_one_full_name,
      "tenant_contact_one_phone": tenant_contact_one_phone,
      "tenant_contact_two_full_name": tenant_contact_two_full_name,
      "tenant_contact_two_phone": tenant_contact_two_phone,
      "agent_name": agent_name,
      "agent_details": agent_details,
      "owner_photo": owner_photo,
      "tenant_photo": tenant_photo,
      "tenant_identity_proof_doc": tenant_identity_proof_doc,
      "tenant_signature": tenant_signature,
      " final String city_id;": city_id,
    };
  }
}
