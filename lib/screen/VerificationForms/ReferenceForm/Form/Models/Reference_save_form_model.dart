class ReferenceModel {
  final String request_id;
  final String service_request_id;
  final String person_name_one;
  final String person_mobile_number_one;
  final String person_relation_one;
  final String person_name_two;
  final String person_mobile_number_two;
  final String person_relation_two;

  ReferenceModel(
      {
      required this.request_id,
      required this.service_request_id,
      required this.person_name_one,
      required this.person_mobile_number_one,
      required this.person_relation_one,
      required this.person_name_two,
      required this.person_mobile_number_two,
      required this.person_relation_two

      });



  Map<String ,dynamic> toJson(){
    return {
      "request_id":request_id,
      "service_request_id":service_request_id,
      "person_name_one":person_name_one,
      "person_mobile_number_one":person_mobile_number_one,
      'person_relation_one':person_relation_one,
      "person_name_two":person_name_two,
      "person_mobile_number_two":person_mobile_number_two,
      "person_relation_two":person_relation_two
    };
  }
}
