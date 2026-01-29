import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../screen/Order History/load_more/models/post.dart';
import '../screen/VerificationForms/AddressVerificationForm/Form/Models/address_save_model.dart';
import '../screen/VerificationForms/AddressVerificationForm/Form/Models/address_update_model.dart';
import '../screen/VerificationForms/EducationVerification/Form/Models/education_save_form_model.dart';
import '../screen/VerificationForms/EducationVerification/Form/Models/education_update_form_model.dart';
import '../screen/VerificationForms/EmploymentVerification/Form/Models/employment_save_form_model.dart';
import '../screen/VerificationForms/EmploymentVerification/Form/Models/employment_update_form_model.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Form/Models/mumbai_police_update_form_model.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Document/Models/mumbai_upload_documents_model.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Form/Models/mumbai_police_save_form_model.dart';
import '../screen/VerificationForms/PoliceVerification/Mumbai/Document/Models/mumbai_document_update_model.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Form/Models/non_mumbai_police_save_form_model.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Form/Models/non_mumbai-police_update_form_model.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Document/Models/non_mumbai_documents_update_model.dart';
import '../screen/VerificationForms/PoliceVerification/NonMumbai/Document/Models/non_mumbai_documents_upload_model.dart';
import '../screen/VerificationForms/ReferenceForm/Form/Models/Reference_save_form_model.dart';
import '../screen/VerificationForms/ReferenceForm/Form/Models/Reference_update_form_model.dart';
import '../screen/VerificationPending/model/pendingDoc_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  ApiService() {
    // You can also configure Dio globally, if needed
    _dio.options.baseUrl = _baseUrl;
  }

//login
  Future<Response> loginWithMobileNumber({required String mobileNumber}) async {
    FormData formData = FormData.fromMap({
      'mobileNumber': mobileNumber,
    });
    final response = await _dio.post(
      'account/login',
      data: formData,
    );
    log('login $response');
    return response;
  }

//otpVerify
  Future<Response> otpVerify(
      {required String mobileNumber, required String otp}) async {
    FormData formData = FormData.fromMap({
      'mobileNumber': mobileNumber,
      'otp': otp,
    });
    final response = await _dio.post(
      'account/verify/otp',
      data: formData,
    );
    log('otpVerify $response');
    return response;
  }

  //userRegister
  Future<Response> userRegister({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String email,
    required String companyName,
    required String companyHr,
    required String companyHrNumber,
    required String companyEmail,
    required String companyAddress,
    required String salutation,
    // File? profilePhoto,
    required String userType,
  }) async {
    FormData formData = FormData.fromMap({
      'firstName': firstName,
      "lastName": lastName,
      'mobileNumber': mobileNumber,
      "email": email,
      "companyName": companyName,
      "contactPersonName": companyHr,
      "contactPersonPhone": companyHrNumber,
      "companyEmail": companyEmail,
      "companyAddress": companyAddress,
      "contactPersonSalutation": salutation,
      // if (profilePhoto != null)
      //   "profilePhoto": await MultipartFile.fromFile(
      //     profilePhoto.path,
      //     filename: profilePhoto.path
      //         .split('/')
      //         .last, // Use the file name
      //   ),
      "userType": userType
    });
    final response = await _dio.post(
      'account/register',
      data: formData,
    );
    // log('register response $response');
    return response;
  }

  Future<Response> getProfile(
      {required String token, required String id}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('account/profile/$id');

      // log('getProfile Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in getProfile: $e');
      throw Exception('Failed to fetch getProfile: $e');
    }
  }

  Future<Response> getServicesPricing({required String token,
    required String type_id,
    required String entity_id}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio
          .get('services/pricing?type_id=$type_id&entity_id=$entity_id');
      // log('ServicesPricing Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in ServicesPricing: $e');
      throw Exception('Failed to fetch ServicesPricing: $e');
    }
  }

  Future<Response> getUpdateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String email,
    required String customerId,
    required String companyName,
    required String contactPersonName,
    required String contactPersonPhone,
    required String companyEmail,
    required String companyAddress,
    required String userType,
    required String salutation,
  }) async {
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };

      // 🔎 Build request body conditionally
      Map<String, dynamic> body = {
        "customerId": customerId,
        "userType": userType,
      };

      if (userType == "1") {
        // Individual
        body.addAll({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
        });
      } else if (userType == "2") {
        // Company
        body.addAll({
          "companyName": companyName,
          "contactPersonName": contactPersonName,
          "contactPersonPhone": contactPersonPhone,
          "companyEmail": companyEmail,
          "companyAddress": companyAddress,
          "contactPersonSalutation": salutation,
        });
      }

      FormData formData = FormData.fromMap(body);

      // 🔎 Print everything before sending
      print("---- UpdateProfile Request ----");
      print("Headers: ${_dio.options.headers}");
      formData.fields.forEach((field) {
        print("${field.key}: ${field.value}");
      });
      print("-------------------------------");

      final response = await _dio.post(
        'account/update/profile',
        data: formData,
      );

      print("UpdateProfile Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in UpdateProfile: $e");
      throw Exception('Failed to fetch UpdateProfile: $e');
    }
  }

  Future<Response> getEntity({required String token}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('entities');
      // log('getEntity Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in getEntity: $e');
      throw Exception('Failed to fetch getEntity: $e');
    }
  }

  Future<Response> getTransactionCheckout({
    required String token,
    required int customer_id,
    required int entity_id,
    required String payment_gateway,
    required String payment_mode,
    required int quantity,
    required String coupon_code,
    required List<Map<String, dynamic>> items,
  }) async {
    Map<String, dynamic> data = {
      "customer_id": customer_id,
      "entity_id": entity_id,
      "payment_gateway": payment_gateway,
      "payment_mode": payment_mode,
      "quantity": quantity,
      "items": items,
      "coupon_code": coupon_code
    };

    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('transaction/checkout', queryParameters: data);
      // log('getTransactionCheckout Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in getTransactionCheckout: $e');
      throw Exception('Failed to fetch getTransactionCheckout: $e');
    }
  }

  Future<Response> getTransactionList({
    required String token,
    required int customer_id,
    required int page,
    required int limit,
    String? from_date,
    String? to_date,
    String? status,
  }) async {
    try {
      Map<String, dynamic> data = {
        "customer_id": customer_id,
        "page": page,
        "limit": limit,
        "from_date": from_date,
        "to_date": to_date,
        "status": status
      };

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.get('transaction/list', queryParameters: data);
      // log('getTransactionList Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in getTransactionList: $e');
      throw Exception('Failed to fetch getTransactionList: $e');
    }
  }

  Future<List<History>> tranFetchData({
    required String token,
    required int customer_id,
    required int page,
    required int limit,
    String? from_date,
    String? to_date,
    String? status,
  }) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    final response = await _dio.get('transaction/list', queryParameters: {
      "customer_id": customer_id,
      "page": page,
      "limit": limit,
      "from_date": from_date,
      "to_date": to_date,
      "status": status
    });
    if (response.data["status"] == 200) {
      // debugPrint("tranList ${response.data}", wrapWidth: 1024);
      // Assuming the API returns a list of items as data
      List<History> items = (response.data['data'] as List)
          .map((itemJson) => History.fromJson(itemJson))
          .toList();

      return items;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> getTransactionDetails({
    required String token,
    required String txnId,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('transaction/$txnId/show');
      // log('getTransactionDetails Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in getTransactionDetails: $e');
      throw Exception('Failed to fetch getTransactionDetails: $e');
    }
  }

  Future<Response> getCheckOutStatus({
    required String token,
    required String payment_order_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'transaction/check/order/status?payment_order_id=$payment_order_id',
      );
      log('getCheckOutStatus Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in getCheckOutStatus: $e');
      throw Exception('Failed to fetch getCheckOutStatus: $e');
    }
  }

  /// Verification Request
  Future<Response> verifyRequestList({
    required String token,
    required int customer_id,
    required int page,
    required int limit,
    String? status,
  }) async {
    try {
      Map<String, dynamic> data = {
        "customer_id": customer_id,
        "page": page,
        "limit": limit,
        "status": status
      };

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.get('verify-request/list', queryParameters: data);
      print('getTransactionList Response: ${response.data}');

      // log('getTransactionList Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in getTransactionList: $e');
      throw Exception('Failed to fetch getTransactionList: $e');
    }
  }

  Future<List<verifyRequest>> verifyRequestListPagination({
    required String token,
    required String customer_id,
    required int page,
    required int limit,
    String? status,
  }) async {
    Map<String, dynamic> data = {
      "customer_id": customer_id,
      "page": page,
      "limit": limit,
      "status": status
    };

    _dio.options.headers = {
      'Authorization': 'Bearer $token',
      'X-Action-From': 'mobile'
    };
    final response =
    await _dio.get('verify-request/list', queryParameters: data);

    if (response.statusCode == 200) {
      final rawJson = jsonEncode(response.data);
      for (var i = 0; i < rawJson.length; i += 1000) {
        debugPrint(rawJson.substring(i, i + 1000 > rawJson.length ? rawJson.length : i + 1000));
      }

      List<verifyRequest> items = (response.data['data'] as List)
          .map((itemJson) => verifyRequest.fromJson(itemJson))
          .toList();
      return items;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> verifyRequestUpdate({
    required String token,
    required String uuid,
    required String firstName,
    required String middleName,
    required String lastName,
    required String phone,
    required String dob,
    required String email,
    required String employee_code,
    required String date_of_joining,
    required String gender
  }) async {
    Map<String, dynamic> data = {
      "uuid": uuid,
      "first_name": firstName,
      "middle_name": middleName,
      "last_name": lastName,
      "phone": phone,
      "dob": dob,
      "email": email,
      "employee_code": employee_code,
      "date_of_joining": date_of_joining,
      "gender": gender
    };

    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
      await _dio.put('verify-request/entity/update', queryParameters: data);
      // log('verifyRequestUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in verifyRequestUpdate: $e');
      throw Exception('Failed to fetch verifyRequestUpdate: $e');
    }
  }

  Future<Response> VerifyRequestEditUpdate({
    required String token,
    required String uuid,
    required String firstName,
    required String middleName,
    required String lastName,
    required String phone,
    required String dob,
    required String email,
    required String employee_code,
    required String date_of_joining,
    required String gender,
  }) async {
    Map<String, dynamic> data = {
      "uuid": uuid,
      "first_name": firstName,
      "middle_name": middleName,
      "last_name": lastName,
      "phone": phone,
      "dob": dob,
      "email": email,
      "employee_code": employee_code,
      "date_of_joining": date_of_joining,
      "gender": gender,
    };

    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.put('verify-request/update', queryParameters: data);
      // log('verifyRequestUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in verifyRequestUpdate: $e');
      throw Exception('Failed to fetch verifyRequestUpdate: $e');
    }
  }
  Future<Response> VerifyDetailsView({
    required String token,
    required String request_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify-request/$request_id/show');
      // log('VerifyDetailsView Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in VerifyDetailsView: $e');
      throw Exception('Failed to fetch VerifyDetailsView: $e');
    }
  }

  Future<Response> VerifyRequestReportDownload({
    required String token,
    required String case_uuid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'verify-request/report/pdf/$case_uuid',
        options: Options(responseType: ResponseType.bytes),
      );

      log('VerifyDetailsView Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in VerifyDetailsView: $e');
      throw Exception('Failed to fetch VerifyDetailsView: $e');
    }
  }



  /// Education Verification
  Future<Response> educationList({
    required String token,
    required int request_id,
    required int service_request_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
          'verify/education/education-list?request_id=$request_id&service_request_id=$service_request_id');
      // log('educationList Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in educationList: $e');
      throw Exception('Failed to fetch educationList: $e');
    }
  }

  Future<Response> EducationFormSave({required String token,
    required String customer_id,
    required EducationSaveFormModel educationSaveFormModel}) async {
    try {
      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": educationSaveFormModel.request_id,
        "service_request_id": educationSaveFormModel.service_request_id,
        "university_name": educationSaveFormModel.university_name,
        "institution_name": educationSaveFormModel.instituition_name,
        "year_of_passing": educationSaveFormModel.year_of_passing,
        "degree_qualification_name": educationSaveFormModel
            .degree_qualification_name,
        "grades_type": educationSaveFormModel.grades_type,
        "grades_obtained": educationSaveFormModel.grades_obtained,
        "case_uuid": educationSaveFormModel.case_uuid
      });
      print("education ${formData.fields}");
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
      await _dio.post('verify/education/form/save', data: formData);
      // log('EducationFormSave Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in EducationFormSave: $e');
      throw Exception('Failed to fetch EducationFormSave: $e');
    }
  }

  Future<Response> EducationFormUpdate({required String customer_id,
    required String token,
    required EducationUpdateFormModel educationUpdateFormModel}) async {
    try {
      FormData formData = FormData.fromMap({
        "uid": educationUpdateFormModel.uid,
        "customer_id": customer_id,
        "request_id": educationUpdateFormModel.request_id,
        "service_request_id": educationUpdateFormModel.service_request_id,
        "university_name": educationUpdateFormModel.university_name,
        "institution_name": educationUpdateFormModel.instituition_name,
        "year_of_passing": educationUpdateFormModel.year_of_passing,
        "degree_qualification_name": educationUpdateFormModel
            .degree_qualification_name,
        "grades_type": educationUpdateFormModel.grades_type,
        "grades_obtained": educationUpdateFormModel.grades_obtained,
        "case_uuid": educationUpdateFormModel.case_uuid,
        "education_uuid": educationUpdateFormModel.education_uuid
      });

      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
      await _dio.post('verify/education/form/update', data: formData);
      // log('EducationFormUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in EducationFormUpdate: $e');
      throw Exception('Failed to fetch EducationFormUpdate: $e');
    }
  }

  Future<Response> educationShowDataDetails({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/education/edit/$uid');
      // log('educationShowDataDetails Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in educationShowDataDetails: $e');
      throw Exception('Failed to fetch educationShowDataDetails: $e');
    }
  }

  Future<Response> EducationDocsUpload({
    required String token,
    required String caseUuid,
    required List<File> documents,
  }) async {
    try {
      // Build FormData with fields + files
      final formData = FormData.fromMap({
        "case_uuid": caseUuid,
        "type": "education",
        // "documents[0][file]": await MultipartFile.fromFile(documents[0].path)
        for (int i = 0; i < documents.length; i++)
          "documents[$i][file]": await MultipartFile.fromFile(documents[i].path,
          ),
      });

      // Debug logs
      // log("=== EducationDocsUpload Request ===");
      // log("Fields: case_uuid=$caseUuid, type=education");
      // log("Files: ${documents.map((d) =>
      // d.path
      //     .split('/')
      //     .last).toList()}");

      // POST with headers
      final response = await _dio.post(
        'verify/documents/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'X-Action-From': 'mobile'
          },
        ),
      );
      // log("=== EducationDocsUpload Response ===");
      // log("Status: ${response.statusCode}");
      // log("Data: ${response.data}");

      return response;
    } catch (e) {
      // log("Error in EducationDocUpload: $e");
      throw Exception("Failed to upload education documents: $e");
    }
  }

  Future<Response> educationDocumentList({
    required String token,
    required String caseUuid,
    required String type, // e.g. "education"
  }) async {
    try {
      // Set Authorization header
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // GET request with query parameters
      final response = await _dio.get(
        'verify/documents/list',
        queryParameters: {
          "case_uuid": caseUuid,
          "type": type,
        },
      );

      // log('educationDocumentList Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in educationDocumentList: $e');
      throw Exception('Failed to fetch educationDocumentList: $e');
    }
  }



  /// Employment Verification
  Future<Response> employmentList({
    required String token,
    required int request_id,
    required int service_request_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
          'verify/employment/employment-list?request_id=$request_id&service_request_id=$service_request_id');
      // log('employmentList Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in employmentList: $e');
      throw Exception('Failed to fetch employmentList: $e');
    }
  }

  Future<Response> EmploymentSaveForm({required String token,
    required String customer_id,
    required EmploymentSaveFormModel employmentSaveFormModel}) async {
    try {
      FormData formData = FormData.fromMap({
        "request_id": employmentSaveFormModel.request_id,
        "customer_id": customer_id,
        "service_request_id": employmentSaveFormModel.service_request_id,
        "employer_name": employmentSaveFormModel.employer_name,
        "employed_from": employmentSaveFormModel.employed_from,
        "employed_to": employmentSaveFormModel.employed_to,
        "designation": employmentSaveFormModel.designation,
        "department": employmentSaveFormModel.department,
        "remunaration": employmentSaveFormModel.remunaration,
        "reporting_manager": employmentSaveFormModel.reporting_manager,
        "reason_for_leaving": employmentSaveFormModel.reason_for_leaving,
        "case_uuid": employmentSaveFormModel.case_uuid,
        "till_date": employmentSaveFormModel.till_date,
      });

      print("employSave ${formData.fields}");

      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
      await _dio.post('verify/employment/form/save', data: formData);
      // log('EmploymentSaveDoc Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in EmploymentSaveDoc: $e');
      throw Exception('Failed to fetch EmploymentSaveDoc: $e');
    }
  }

  Future<Response> employmentUpdateForm({required String token,
    required String customer_id,
    required EmploymentUpdateFormModel employmentUpdateFormModel}) async {
    try {
      FormData formData = FormData.fromMap({
        "uid": employmentUpdateFormModel.uid,
        "request_id": employmentUpdateFormModel.request_id,
        "customer_id": customer_id,
        "service_request_id": employmentUpdateFormModel.service_request_id,
        "employer_name": employmentUpdateFormModel.employer_name,
        "employed_from": employmentUpdateFormModel.employed_from,
        "employed_to": employmentUpdateFormModel.employed_to,
        "designation": employmentUpdateFormModel.designation,
        "department": employmentUpdateFormModel.department,
        "remunaration": employmentUpdateFormModel.remunaration,
        "reporting_manager": employmentUpdateFormModel.reporting_manager,
        "reason_for_leaving": employmentUpdateFormModel.reason_for_leaving,
        "employment_uuid": employmentUpdateFormModel.employment_uuid,
        "case_uuid": employmentUpdateFormModel.case_uuid,
        "till_date": employmentUpdateFormModel.till_date
      });

      print("employSave ${formData.fields}");

      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
      await _dio.post('verify/employment/form/update', data: formData);
      // log('employmentUpdateForm Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in employmentUpdateForm: $e');
      throw Exception('Failed to fetch employmentUpdateForm: $e');
    }
  }

  Future<Response> employShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/employment/$uid/show');
      // log('employShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in employShowData: $e');
      throw Exception('Failed to fetch employShowData: $e');
    }
  }

  Future<Response> EmploymentDocsUpload({
    required String token,
    required String caseUuid,
    required List<File> documents,
  }) async {
    try {
      // Build FormData with fields + files
      final formData = FormData.fromMap({
        "case_uuid": caseUuid,
        "type": "employment",
        // "documents[0][file]": await MultipartFile.fromFile(documents[0].path)
        for (int i = 0; i < documents.length; i++)
          "documents[$i][file]": await MultipartFile.fromFile(documents[i].path,
          ),
      });

      // Debug logs
      // log("=== EmploymentDocsUpload Request ===");
      // log("Fields: case_uuid=$caseUuid, type=education");
      // log("Files: ${documents.map((d) =>
      // d.path
      //     .split('/')
      //     .last).toList()}");

      // POST with headers
      final response = await _dio.post(
        'verify/documents/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'X-Action-From': 'mobile'
          },
        ),
      );

      // log("=== EmploymentDocsUpload Response ===");
      // log("Status: ${response.statusCode}");
      // log("Data: ${response.data}");

      return response;
    } catch (e) {
      // log("Error in EmploymentDocUpload: $e");
      throw Exception("Failed to upload employment documents: $e");
    }
  }

  Future<Response> employmentDocumentList({
    required String token,
    required String caseUuid,
    required String type, // e.g. "education"
  }) async {
    try {
      // Set Authorization header
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // GET request with query parameters
      final response = await _dio.get(
        'verify/documents/list',
        queryParameters: {
          "case_uuid": caseUuid,
          "type": type,
        },
      );

      // log('employmentDocumentList Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in employmentDocumentList: $e');
      throw Exception('Failed to fetch employmentDocumentList: $e');
    }
  }



  ///  Address Verification
  Future<Response> addressList({
    required String token,
    required int request_id,
    required int service_request_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
          'verify/address/list?request_id=$request_id&service_request_id=$service_request_id');
      // log('employmentList Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in addressList: $e');
      throw Exception('Failed to fetch addressList: $e');
    }
  }

  Future<Response> NameAddressStore(
      {required String token,
        required String customer_id,
        required NameAddressVerificationModel nameAddressVerificationModel}) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": nameAddressVerificationModel.request_id,
      "service_request_id": nameAddressVerificationModel.service_request_id,
      "current_address_line_1": nameAddressVerificationModel.current_address_line_1,
      "current_address_line_2": nameAddressVerificationModel.current_address_line_2,
      "current_address_city": nameAddressVerificationModel.current_city_id,
      "current_address_state": nameAddressVerificationModel.current_state,
      "current_address_postal_code": nameAddressVerificationModel.current_pinCode,
      // "permanent_address_line_1": nameAddressVerificationModel.permanent_address_line_1,
      // "permanent_address_line_2": nameAddressVerificationModel.permanent_address_line_2,
      // "permanent_address_city": nameAddressVerificationModel.permanent_city_id,
      // "permanent_address_state": nameAddressVerificationModel.permanent_state,
      // "permanent_address_postal_code": nameAddressVerificationModel.permanent_pinCode,
      "residing_from_date": nameAddressVerificationModel.residing_from_date,
      "residing_to_date": nameAddressVerificationModel.residing_to_date,
      "data_preference": nameAddressVerificationModel.data_preference,
      "case_uuid": nameAddressVerificationModel.case_uuid,
      "till_date": nameAddressVerificationModel.till_date,
    });

    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
      await _dio.post('verify/address/form/save', data: formData);
      log('NameAddressStoreVerification Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in NameAddressStoreVerification: $e');
      throw Exception('Failed to fetch NameAddressStoreVerification: $e');
    }
  }

  Future<Response> NameAddressUpdate(
      {required String token,
        required String customer_id,
        required NameAddressVerificationUpdateModel
        nameAddressVerificationUpdateModel}) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": nameAddressVerificationUpdateModel.request_id,
      "service_request_id": nameAddressVerificationUpdateModel.service_request_id,
      "current_address_line_1": nameAddressVerificationUpdateModel.current_address_line_1,
      "current_address_line_2": nameAddressVerificationUpdateModel.current_address_line_2,
      "current_address_city": nameAddressVerificationUpdateModel.current_city_id,
      "current_address_state": nameAddressVerificationUpdateModel.current_state,
      "current_address_postal_code": nameAddressVerificationUpdateModel.current_pinCode,
      // "permanent_address_line_1": nameAddressVerificationUpdateModel.permanent_address_line_1,
      // "permanent_address_line_2": nameAddressVerificationUpdateModel.permanent_address_line_2,
      // "permanent_address_city": nameAddressVerificationUpdateModel.permanent_city_id,
      // "permanent_address_state": nameAddressVerificationUpdateModel.permanent_state,
      // "permanent_address_postal_code": nameAddressVerificationUpdateModel.permanent_pinCode,
      "case_uuid": nameAddressVerificationUpdateModel.case_uuid,
      "address_uuid": nameAddressVerificationUpdateModel.address_uuid,
      "data_preference": nameAddressVerificationUpdateModel.data_preference,
      "residing_from_date": nameAddressVerificationUpdateModel.residing_from_date,
      "residing_to_date": nameAddressVerificationUpdateModel.residing_to_date,
      "uid": nameAddressVerificationUpdateModel.uid,
    });
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
      await _dio.post('verify/address/form/update', data: formData);
      log('NameAddressUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in NameAddressUpdate: $e');
      throw Exception('Failed to fetch NameAddressUpdate: $e');
    }
  }

  Future<Response> nameAddressShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/address/$uid/show');
      // log('nameAddressShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in nameAddressShowData: $e');
      throw Exception('Failed to fetch nameAddressShowData: $e');
    }
  }

  Future<Response> AddressDocsUpload({
    required String token,
    required String caseUuid,
    required List<File> documents,
  }) async {
    try {
      // Build FormData with fields + files
      final formData = FormData.fromMap({
        "case_uuid": caseUuid,
        "type": "all",
        // "documents[0][file]": await MultipartFile.fromFile(documents[0].path)
        for (int i = 0; i < documents.length; i++)
          "documents[$i][file]": await MultipartFile.fromFile(documents[i].path,
          ),
      });

      // Debug logs
      // log("=== AddressDocsUpload Request ===");
      // log("Fields: case_uuid=$caseUuid, type=education");
      // log("Files: ${documents.map((d) =>
      // d.path
      //     .split('/')
      //     .last).toList()}");

      // POST with headers
      final response = await _dio.post(
        'verify/documents/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'X-Action-From': 'mobile'
          },
        ),
      );

      // log("=== AddressDocsUpload Response ===");
      // log("Status: ${response.statusCode}");
      // log("Data: ${response.data}");

      return response;
    } catch (e) {
      // log("Error in AddressDocUpload: $e");
      throw Exception("Failed to upload address documents: $e");
    }
  }

  Future<Response> addressDocumentList({
    required String token,
    required String caseUuid,
    required String type, // e.g. "education"
  }) async {
    try {
      // Set Authorization header
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // GET request with query parameters
      final response = await _dio.get(
        'verify/documents/list',
        queryParameters: {
          "case_uuid": caseUuid,
          "type": type,
        },
      );

      // log('addressDocumentList Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in addressDocumentList: $e');
      throw Exception('Failed to fetch addressDocumentList: $e');
    }
  }



  /// KYC (PAN) Legal Verification
  Future<Response> panNumberSave(
      {required String token,
        required String serviceRequestId,
        required String requestId,
        required String customer_id,
        required String document_type,
        required String document_number
        // required String panNumber
      }) async {
    try {
      Map<String, dynamic> data = {
        "customer_id": customer_id,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "document_type": document_type,
        "document_number": document_number
        // "pan_number": panNumber,
      };

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/pan/form/store', queryParameters: data);
      // log('panNumberSave Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in panNumberSave: $e');
      throw Exception('Failed to fetch panNumberSave: $e');
    }
  }

  Future<Response> panNumberShowData({
    required String token,
    required String uid,
    // required String request_id,
    // required String service_request_id,
    // required String customer_id,
  }) async {
    FormData formData = FormData.fromMap({
      // "request_id": request_id,
      // "service_request_id": service_request_id,
      // "customer_id": customer_id
    });
    print(formData.fields);
    print(token);
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/pan/show/$uid', /*data: formData*/);
      // log('panNumberSave Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in panNumberShowData: $e');
      throw Exception('Failed to fetch panNumberShowData: $e');
    }
  }

  Future<Response> panNumberUpdate(
      {required String token,
        required String serviceRequestId,
        required String requestId,
        required String customer_id,
        required String document_type,
        required String document_number
        // required String panNumber
      }) async {
    try {
      Map<String, dynamic> data = {
        "customer_id": customer_id,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "document_type": document_type,
        "document_number": document_number
        // "pan_number": panNumber,
      };

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/pan/form/update', queryParameters: data);
      log('panNumberUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in panNumberUpdate: $e');
      throw Exception('Failed to fetch panNumberUpdate: $e');
    }
  }

  Future<Response> PanDocsUpload({
    required String token,
    required String request_id,
    required String service_request_id,
    required String customer_id,
    required List<File> documents,
  }) async {
    try {
      // Build FormData with fields + files
      final formData = FormData.fromMap({
        "request_id": request_id,
        "service_request_id": service_request_id,
        "customer_id": customer_id,
        // "documents[0][file]": await MultipartFile.fromFile(documents[0].path)
        for (int i = 0; i < documents.length; i++)
          "documents[$i]": await MultipartFile.fromFile(documents[i].path,
          ),
      });

      // Debug logs
      log("=== AddressDocsUpload Request ===");
      log("Files: ${documents.map((d) =>
      d.path
          .split('/')
          .last).toList()}");

      // POST with headers
      final response = await _dio.post(
        'verify/pan/document/store',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log("=== AddressDocsUpload Response ===");
      log("Status: ${response.statusCode}");
      log("Data: ${response.data}");

      return response;
    } catch (e) {
      // log("Error in AddressDocUpload: $e");
      throw Exception("Failed to upload address documents: $e");
    }
  }

  Future<Response> PanDocsUpdate({
    required String token,
    required String request_id,
    required String service_request_id,
    required String customer_id,
    required List<File> documents,
  }) async {
    try {
      // Build FormData with fields + files
      final formData = FormData.fromMap({
        "request_id": request_id,
        "service_request_id": service_request_id,
        "customer_id": customer_id,
        // "documents[0][file]": await MultipartFile.fromFile(documents[0].path)
        for (int i = 0; i < documents.length; i++)
          "documents[$i]": await MultipartFile.fromFile(documents[i].path,
          ),
      });

      // Debug logs
      log("=== AddressDocsUpload Request ===");
      log("Files: ${documents.map((d) =>
      d.path
          .split('/')
          .last).toList()}");

      // POST with headers
      final response = await _dio.post(
        'verify/pan/document/store',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      log("=== AddressDocsUpload Response ===");
      log("Status: ${response.statusCode}");
      log("Data: ${response.data}");

      return response;
    } catch (e) {
      // log("Error in AddressDocUpload: $e");
      throw Exception("Failed to upload address documents: $e");
    }
  }

  /// Court Legal Verification
  Future<Response> courtVerification({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required String first_name,
    required String last_name,
    required String father_name,
    required String dob,
    required String address,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "first_name": first_name,
      "last_name": last_name,
      "father_name": father_name,
      "dob": dob,
      "address": address,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/court/form/store', data: formData);
      // log('courtVerification Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in courtVerification: $e');
      throw Exception('Failed to fetch courtVerification: $e');
    }
  }

  Future<Response> courtVerificationUpdate({
    required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required String first_name,
    required String last_name,
    required String father_name,
    required String dob,
    required String address,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "first_name": first_name,
      "last_name": last_name,
      "father_name": father_name,
      "dob": dob,
      "address": address,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/court/form/update', data: formData);
      log('courtVerificationUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in courtVerificationUpdate: $e');
      throw Exception('Failed to fetch courtVerificationUpdate: $e');
    }
  }

  Future<Response> courtVerificationDocUpload({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File aadhaar_document,
    required File pan_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "aadhaar_document": await MultipartFile.fromFile(
        aadhaar_document.path,
        filename: aadhaar_document.path.split('/').last, // Use the file name
      ),
      "pan_document": await MultipartFile.fromFile(
        pan_document.path,
        filename: pan_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/court/document/store', data: formData);
      // log('courtVerificationDocUpload Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in courtVerificationDocUpload: $e');
      throw Exception('Failed to fetch courtVerificationDocUpload: $e');
    }
  }

  Future<Response> courtVerificationDocUpdate({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File aadhaar_document,
    required File pan_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "aadhaar_document": aadhaar_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        aadhaar_document.path,
        filename:
        aadhaar_document.path.split('/').last, // Use the file name
      ),
      "pan_document": pan_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        pan_document.path,
        filename: pan_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/court/document/update', data: formData);
      // log('courtVerificationDocUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in courtVerificationDocUpdate: $e');
      throw Exception('Failed to fetch courtVerificationDocUpdate: $e');
    }
  }



  /// Reference Check Verification
  Future<Response> ReferenceVerification(
      {required String customer_id,
        required String token,
        required ReferenceModel referenceModel}) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": referenceModel.request_id,
      "service_request_id": referenceModel.service_request_id,
      "person_name_1": referenceModel.person_name_one,
      "person_mobile_number_1": referenceModel.person_mobile_number_one,
      "person_relation_1": referenceModel.person_relation_one,
      "person_name_2": referenceModel.person_name_two,
      "person_mobile_number_2": referenceModel.person_mobile_number_two,
      "person_relation_2": referenceModel.person_relation_two,
    });

    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/reference/form/store', data: formData);
      // log('ReferenceVerification Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in ReferenceVerification: $e');
      throw Exception('Failed to fetch ReferenceVerification: $e');
    }
  }

  Future<Response> ReferenceVerificationUpdate(
      {required String token,
        required String customer_id,
        required ReferenceUpdateModel referenceUpdateModel}) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": referenceUpdateModel.request_id,
      "service_request_id": referenceUpdateModel.service_request_id,
      "person_name_1": referenceUpdateModel.person_name_one,
      "person_mobile_number_1": referenceUpdateModel.person_mobile_number_one,
      "person_relation_1": referenceUpdateModel.person_relation_one,
      "person_name_2": referenceUpdateModel.person_name_two,
      "person_mobile_number_2": referenceUpdateModel.person_mobile_number_two,
      "person_relation_2": referenceUpdateModel.person_relation_two,
    });

    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/reference/form/update', data: formData);
      // log('verifyRequestUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in verifyRequestUpdate:$e');
      throw Exception('Failed to fetch verifyRequestUpdate: $e');
    }
  }

  Future<Response> ReferenceCheckDetailsView({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/reference/show/$uid');
      // log('ReferenceCheckDetailsView Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in ReferenceCheckDetailsView: $e');
      throw Exception('Failed to fetch ReferenceCheckDetailsView: $e');
    }
  }

  Future<Response> referenceCheckDocUpload({
    required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required File data_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "data_document": await MultipartFile.fromFile(
        data_document.path,
        filename: data_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/reference/document/store', data: formData);
      // log('referenceCheckDocUpload Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in referenceCheckDocUpload: $e');
      throw Exception('Failed to fetch referenceCheckDocUpload: $e');
    }
  }

  Future<Response> referenceCheckDocShowData(
      {required String token, required String uid}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/reference/show/$uid');
      // log('referenceCheckDocShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in referenceCheckDocShowData: $e');
      throw Exception('Failed to fetch referenceCheckDocShowData: $e');
    }
  }

  Future<Response> referenceCheckDocUpdate({
    required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required File data_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "data_document": data_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        data_document.path,
        filename: data_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/reference/document/update', data: formData);
      // log('referenceCheckDocUpload Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in referenceCheckDocUpload: $e');
      throw Exception('Failed to fetch referenceCheckDocUpload: $e');
    }
  }



  /// Driving License Verification
  Future<Response> drivingLicenceSave({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required String driver_licence_number,
    required String dob,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "driver_licence_number": driver_licence_number,
      "dob": dob,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/driver-licence/form/store', data: formData);
      // log('drivingLicenceSave Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in drivingLicenceSave: $e');
      throw Exception('Failed to fetch drivingLicenceSave: $e');
    }
  }

  Future<Response> drivingLicenceUpdate({
    required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required String driver_licence_number,
    required String dob,
  }) async {
    FormData formData = FormData.fromMap({
      "request_id": request_id,
      "customer_id": customer_id,
      "service_request_id": service_request_id,
      "driver_licence_number": driver_licence_number,
      "dob": dob,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/driver-licence/form/update', data: formData);
      // log('drivingLicenceSave Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in drivingLicenceSave: $e');
      throw Exception('Failed to fetch drivingLicenceSave: $e');
    }
  }

  Future<Response> drivingLicenceShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/driver-licence/show/$uid');
      // log('drivingLicenceShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in drivingLicenceShowData: $e');
      throw Exception('Failed to fetch drivingLicenceShowData: $e');
    }
  }

  Future<Response> drivingDocUpload({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File data_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "data_document": await MultipartFile.fromFile(
        data_document.path,
        filename: data_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('verify/driver-licence/document/store',
          data: formData);
      // log('drivingDocUpload Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in drivingDocUpload: $e');
      throw Exception('Failed to fetch drivingDocUpload: $e');
    }
  }

  Future<Response> drivingDocUpdate({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File data_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "data_document": data_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        data_document.path,
        filename: data_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('verify/driver-licence/document/update',
          data: formData);
      // log('drivingDocUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in drivingDocUpdate: $e');
      throw Exception('Failed to fetch drivingDocUpdate: $e');
    }
  }



  /// GST CIN PAN Verification
  Future<Response> gstPanCinSave({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required String gst_number,
    required String pan_number,
    required String cin_number,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "gst_number": gst_number,
      "pan_number": pan_number,
      "cin_number": cin_number,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/gst-pan-cin/form/store', data: formData);
      // log('gstPanCinSave Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in gstPanCinSave: $e');
      throw Exception('Failed to fetch gstPanCinSave: $e');
    }
  }

  Future<Response> gstPanCinUpdate({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required String gst_number,
    required String pan_number,
    required String cin_number,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "gst_number": gst_number,
      "pan_number": pan_number,
      "cin_number": cin_number,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/gst-pan-cin/form/update', data: formData);
      // log('gstPanCinUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in gstPanCinUpdate: $e');
      throw Exception('Failed to fetch gstPanCinUpdate: $e');
    }
  }
  Future<Response> gstPanCinShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/gst-pan-cin/show/$uid');
      // log('gstPanCinShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in gstPanCinShowData: $e');
      throw Exception('Failed to fetch gstPanCinShowData: $e');
    }
  }
  Future<Response> gstPanCinDocUpload({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File gst_document,
    required File pan_document,
    required File cin_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "gst_document": gst_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        gst_document.path,
        filename: gst_document.path.split('/').last, // Use the file name
      ),
      "pan_document": pan_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        pan_document.path,
        filename: pan_document.path.split('/').last, // Use the file name
      ),
      "cin_document": cin_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        cin_document.path,
        filename: cin_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/gst-pan-cin/document/store', data: formData);
      // log('gstPanCinDocUpload Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in gstPanCinDocUpload: $e');
      throw Exception('Failed to fetch gstPanCinDocUpload: $e');
    }
  }

  Future<Response> gstPanCinDocUpdate({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File gst_document,
    required File pan_document,
    required File cin_document,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "gst_document": gst_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        gst_document.path,
        filename: gst_document.path.split('/').last, // Use the file name
      ),
      "pan_document": pan_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        pan_document.path,
        filename: pan_document.path.split('/').last, // Use the file name
      ),
      "cin_document": cin_document.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
        cin_document.path,
        filename: cin_document.path.split('/').last, // Use the file name
      ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/gst-pan-cin/document/update', data: formData);
      // log('gstPanCinDocUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in gstPanCinDocUpdate: $e');
      throw Exception('Failed to fetch gstPanCinDocUpdate: $e');
    }
  }



  /// Police Verification (Mumbai)
  Future<Response> tenantMumbaiForm(
      {required String customerId,
        required String token,
        required MumbaiModel mumbaiModel}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      FormData formData = FormData.fromMap({
        "customer_id": customerId,
        "request_id": mumbaiModel.request_id,
        "service_request_id": mumbaiModel.service_request_id,
        "police_station_id": mumbaiModel.police_station_id,
        "rented_address": mumbaiModel.rented_address,
        "rented_city": mumbaiModel.rented_city,
        "rented_state": mumbaiModel.rented_state,
        "rented_postal_code": mumbaiModel.rented_postal_code,
        'agreement_start_date': mumbaiModel.agreement_start_date,
        "agreement_end_date": mumbaiModel.agreement_end_date,
        "owner_full_name": mumbaiModel.owner_full_name,
        "owner_mob_no": mumbaiModel.owner_mob_no,
        "owner_email": mumbaiModel.owner_email,
        "owner_address": mumbaiModel.owner_address,
        "owner_city_district": mumbaiModel.owner_city_district,
        "owner_state": mumbaiModel.owner_state,
        "owner_postal_code": mumbaiModel.owner_postal_code,
        "tenant_name": mumbaiModel.tenant_name,
        "tenant_address": mumbaiModel.tenant_address,
        "tenant_city": mumbaiModel.tenant_city,
        "tenant_state": mumbaiModel.tenant_state,
        "tenant_postal_code": mumbaiModel.tenant_postal_code,
        "tenant_identity_proof_doc_type":
        mumbaiModel.tenant_identity_proof_doc_type,
        "tenant_identity_proof_no": mumbaiModel.tenant_identity_proof_no,
        "tenant_co_resident_males_no": mumbaiModel.tenant_co_resident_males_no,
        "tenant_co_resident_females_no":
        mumbaiModel.tenant_co_resident_females_no,
        "tenant_co_resident_children_no":
        mumbaiModel.tenant_co_resident_children_no,
        "tenant_work_phone": mumbaiModel.tenant_work_phone,
        "tenant_work_email": mumbaiModel.tenant_work_email,
        "tenant_occupation": mumbaiModel.tenant_occupation,
        "tenant_work_place_address": mumbaiModel.tenant_work_place_address,
        "tenant_work_city": mumbaiModel.tenant_work_city,
        "tenant_work_state": mumbaiModel.tenant_work_state,
        "tenant_work_postal_code": mumbaiModel.tenant_work_postal_code,
        "tenant_contact_one_full_name":
        mumbaiModel.tenant_contact_one_full_name,
        "tenant_contact_one_phone": mumbaiModel.tenant_contact_one_phone,
        "tenant_contact_two_full_name":
        mumbaiModel.tenant_contact_two_full_name,
        "tenant_contact_two_phone": mumbaiModel.tenant_contact_two_phone,
        "agent_name": mumbaiModel.agent_name,
        "agent_details": mumbaiModel.agent_details,
        "owner_photo": await MultipartFile.fromFile(
          mumbaiModel.owner_photo.path,
          filename:
          mumbaiModel.owner_photo.path.split('/').last, // Use the file name
        ),
        "tenant_photo": await MultipartFile.fromFile(
          mumbaiModel.tenant_photo.path,
          filename: mumbaiModel.tenant_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc": await MultipartFile.fromFile(
          mumbaiModel.tenant_identity_proof_doc.path,
          filename: mumbaiModel.tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_signature": await MultipartFile.fromFile(
          mumbaiModel.tenant_signature.path,
          filename: mumbaiModel.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "city_id": mumbaiModel.city_id
      });

      final response =
      await _dio.post('verify/police/mumbai/form/save', data: formData);
      // log('tenantMumbaiForm Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantMumbaiForm: $e');
      throw Exception('Failed to fetch tenantMumbaiForm: $e');
    }
  }

  Future<Response> tenantMumbaiFormUpdate(
      {required String token,
        required String customer_id,
        required MumbaiUpdateModel mumbaiUpdateModel}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": mumbaiUpdateModel.request_id,
        "service_request_id": mumbaiUpdateModel.service_request_id,
        "police_station_id": mumbaiUpdateModel.police_station_id,
        "rented_address": mumbaiUpdateModel.rented_address,
        "rented_city": mumbaiUpdateModel.rented_city,
        "rented_state": mumbaiUpdateModel.rented_state,
        "rented_postal_code": mumbaiUpdateModel.rented_postal_code,
        'agreement_start_date': mumbaiUpdateModel.agreement_start_date,
        "agreement_end_date": mumbaiUpdateModel.agreement_end_date,
        "owner_full_name": mumbaiUpdateModel.owner_full_name,
        "owner_mob_no": mumbaiUpdateModel.owner_mob_no,
        "owner_email": mumbaiUpdateModel.owner_email,
        "owner_address": mumbaiUpdateModel.owner_address,
        "owner_city_district": mumbaiUpdateModel.owner_city_district,
        "owner_state": mumbaiUpdateModel.owner_state,
        "owner_postal_code": mumbaiUpdateModel.owner_postal_code,
        "tenant_name": mumbaiUpdateModel.tenant_name,
        "tenant_address": mumbaiUpdateModel.tenant_address,
        "tenant_city": mumbaiUpdateModel.tenant_city,
        "tenant_state": mumbaiUpdateModel.tenant_state,
        "tenant_postal_code": mumbaiUpdateModel.tenant_postal_code,
        "tenant_identity_proof_doc_type":
        mumbaiUpdateModel.tenant_identity_proof_doc_type,
        "tenant_identity_proof_no": mumbaiUpdateModel.tenant_identity_proof_no,
        "tenant_co_resident_males_no":
        mumbaiUpdateModel.tenant_co_resident_males_no,
        "tenant_co_resident_females_no":
        mumbaiUpdateModel.tenant_co_resident_females_no,
        "tenant_co_resident_children_no":
        mumbaiUpdateModel.tenant_co_resident_children_no,
        "tenant_work_phone": mumbaiUpdateModel.tenant_work_phone,
        "tenant_work_email": mumbaiUpdateModel.tenant_work_email,
        "tenant_occupation": mumbaiUpdateModel.tenant_occupation,
        "tenant_work_place_address":
        mumbaiUpdateModel.tenant_work_place_address,
        "tenant_work_city": mumbaiUpdateModel.tenant_work_city,
        "tenant_work_state": mumbaiUpdateModel.tenant_work_state,
        "tenant_work_postal_code": mumbaiUpdateModel.tenant_work_postal_code,
        "tenant_contact_one_full_name":
        mumbaiUpdateModel.tenant_contact_one_full_name,
        "tenant_contact_one_phone": mumbaiUpdateModel.tenant_contact_one_phone,
        "tenant_contact_two_full_name":
        mumbaiUpdateModel.tenant_contact_two_full_name,
        "tenant_contact_two_phone": mumbaiUpdateModel.tenant_contact_two_phone,
        "agent_name": mumbaiUpdateModel.agent_name,
        "agent_details": mumbaiUpdateModel.agent_details,
        "owner_photo": mumbaiUpdateModel.owner_photo.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          mumbaiUpdateModel.owner_photo.path,
          filename: mumbaiUpdateModel.owner_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_photo": mumbaiUpdateModel.tenant_photo.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          mumbaiUpdateModel.tenant_photo.path,
          filename: mumbaiUpdateModel.tenant_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc":
        mumbaiUpdateModel.tenant_identity_proof_doc.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          mumbaiUpdateModel.tenant_identity_proof_doc.path,
          filename: mumbaiUpdateModel.tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_signature": mumbaiUpdateModel.tenant_signature.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          mumbaiUpdateModel.tenant_signature.path,
          filename: mumbaiUpdateModel.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "city_id": mumbaiUpdateModel.city_id
      });

      final response =
      await _dio.post('verify/police/mumbai/form/update', data: formData);
      // log('tenantMumbaiFormUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantMumbaiForm: $e');
      throw Exception('Failed to fetch tenantMumbaiFormUpdate: $e');
    }
  }

  Future<Response> mumbaiShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/police/mumbai/$uid');
      // log('mumbaiShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in mumbaiShowData: $e');
      throw Exception('Failed to fetch mumbaiShowData: $e');
    }
  }

  Future<Response> tenantMumbaiUploadDocuments(
      {required String customer_id,
        required String token,
        required UploadDocumentsMumbaiModel uploadDocumentsMumbaiModel}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": uploadDocumentsMumbaiModel.request_id,
        "service_request_id": uploadDocumentsMumbaiModel.service_request_id,
        "police_station_id": uploadDocumentsMumbaiModel.police_station_id,
        "tenant_photo": await MultipartFile.fromFile(
          uploadDocumentsMumbaiModel.tenant_photo.path,
          filename: uploadDocumentsMumbaiModel.tenant_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_signature": await MultipartFile.fromFile(
          uploadDocumentsMumbaiModel.tenant_signature.path,
          filename: uploadDocumentsMumbaiModel.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc": await MultipartFile.fromFile(
          uploadDocumentsMumbaiModel.tenant_identity_proof_doc.path,
          filename: uploadDocumentsMumbaiModel.tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "owner_photo": await MultipartFile.fromFile(
          uploadDocumentsMumbaiModel.owner_photo.path,
          filename: uploadDocumentsMumbaiModel.owner_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "data_document": await MultipartFile.fromFile(
          uploadDocumentsMumbaiModel.data_document.path,
          filename: uploadDocumentsMumbaiModel.data_document.path
              .split('/')
              .last, // Use the file name
        )
      });

      final response =
      await _dio.post('verify/police/mumbai/document/save', data: formData);
      // log('tenantMumbaiUploadDocuments Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantMumbaiUploadDocuments: $e');
      throw Exception('Failed to fetch tenantMumbaiUploadDocuments: $e');
    }
  }

  Future<Response> tenantMumbaiUpdateDocuments(
      {required String token,
        required String customer_id,
        required UpdateDocumentsMumbaiModel updateDocumentsMumbaiModel}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": updateDocumentsMumbaiModel.request_id,
        "service_request_id": updateDocumentsMumbaiModel.service_request_id,
        "police_station_id": updateDocumentsMumbaiModel.police_station_id,
        "tenant_photo": updateDocumentsMumbaiModel.tenant_photo.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsMumbaiModel.tenant_photo.path,
          filename: updateDocumentsMumbaiModel.tenant_photo.path
              .split('/')
              .last, // Use the file nameupdateDocumentsMumbaiModel
        ),
        "tenant_signature":
        updateDocumentsMumbaiModel.tenant_signature.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsMumbaiModel.tenant_signature.path,
          filename: updateDocumentsMumbaiModel.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc":
        updateDocumentsMumbaiModel.tenant_identity_proof_doc.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsMumbaiModel.tenant_identity_proof_doc.path,
          filename: updateDocumentsMumbaiModel
              .tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "owner_photo": updateDocumentsMumbaiModel.owner_photo.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsMumbaiModel.owner_photo.path,
          filename: updateDocumentsMumbaiModel.owner_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "data_document": updateDocumentsMumbaiModel.data_document.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsMumbaiModel.data_document.path,
          filename: updateDocumentsMumbaiModel.data_document.path
              .split('/')
              .last, // Use the file name
        )
      });

      final response = await _dio.post('verify/police/mumbai/document/update',
          data: formData);
      // log('tenantMumbaiUploadDocuments Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantMumbaiUploadDocuments: $e');
      throw Exception('Failed to fetch tenantMumbaiUploadDocuments: $e');
    }
  }

  Future<Response> mumbaiDocumentShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/police/mumbai/$uid');
      // log('mumbaiDocumentShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in mumbaiDocumentShowData: $e');
      throw Exception('Failed to fetch mumbaiDocumentShowData: $e');
    }
  }


  /// Police Verification (Non Mumbai)
  Future<Response> tenantNonMumbaiForm(
      {required String token,
        required String customer_id,
        required NonMumbaiModel nonMumbai}) async {
    try {
      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": nonMumbai.request_id,
        "service_request_id": nonMumbai.service_request_id,
        "tenant_name": nonMumbai.tenant_name,
        "tenant_address": nonMumbai.tenant_address,
        "tenant_city": nonMumbai.tenant_city,
        "tenant_state": nonMumbai.tenant_state,
        "tenant_postal_code": nonMumbai.tenant_postal_code,
        "tenant_identity_proof_doc_type":
        nonMumbai.tenant_identity_proof_doc_type,
        "tenant_identity_proof_no": nonMumbai.tenant_identity_proof_no,
        "tenant_identification_mark": nonMumbai.tenant_identification_mark,
        "tenant_dob": nonMumbai.tenant_dob,
        "tenant_birth_place": nonMumbai.tenant_birth_place,
        "tenant_age": nonMumbai.tenant_age,
        "tenant_is_employed": nonMumbai.tenant_is_employed,
        "tenant_employed_year": nonMumbai.tenant_employed_year,
        "tenant_employed_month": nonMumbai.tenant_employed_month,
        "tenant_employer_or_company": nonMumbai.tenant_employer_or_company,
        "tenant_fathers_name": nonMumbai.tenant_fathers_name,
        "tenant_fathers_address": nonMumbai.tenant_fathers_address,
        "tenant_fathers_occupation": nonMumbai.tenant_fathers_occupation,
        "tenant_contact_one_full_name": nonMumbai.tenant_contact_one_full_name,
        "tenant_contact_one_address": nonMumbai.tenant_contact_one_address,
        "tenant_contact_two_full_name": nonMumbai.tenant_contact_two_full_name,
        "tenant_contact_two_address": nonMumbai.tenant_contact_two_address,
        "tenant_has_criminal_offenses": nonMumbai.tenant_has_criminal_offenses,
        nonMumbai.tenant_crno_section.isEmpty ? "" : "tenant_crno_section":
        nonMumbai.tenant_crno_section,
        "tenant_whether_arrested": nonMumbai.tenant_whether_arrested,
        nonMumbai.tenant_present_case_status.isEmpty
            ? ""
            : "tenant_present_case_status":
        nonMumbai.tenant_present_case_status,
        "tenant_earlier_residential_place":
        nonMumbai.tenant_earlier_residential_place,
        "tenant_earlier_residential_months":
        nonMumbai.tenant_earlier_residential_months,
        "tenant_earlier_residential_years":
        nonMumbai.tenant_earlier_residential_years,
        "tenant_earlier_residential_jurisdiction_of_police_station":
        nonMumbai.tenant_earlier_residential_jurisdiction_of_police_station,
        "tenant_present_address_duration_years":
        nonMumbai.tenant_present_address_duration_years,
        "tenant_present_address_duration_months":
        nonMumbai.tenant_present_address_duration_months,
        "tenant_jurisdiction_of_police_station":
        nonMumbai.tenant_jurisdiction_of_police_station,
        "tenant_present_resendential_place":
        nonMumbai.tenant_present_resendential_place,
        "tenant_signature_place": nonMumbai.tenant_signature_place,
        "tenant_signature_date": nonMumbai.tenant_signature_date,
        "tenant_photo": await MultipartFile.fromFile(
          nonMumbai.tenant_photo.path,
          filename:
          nonMumbai.tenant_photo.path.split('/').last, // Use the file name
        ),
        "tenant_signature": await MultipartFile.fromFile(
          nonMumbai.tenant_signature.path,
          filename: nonMumbai.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc": await MultipartFile.fromFile(
          nonMumbai.tenant_identity_proof_doc.path,
          filename: nonMumbai.tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_letter_from_employer":
        nonMumbai.tenant_letter_from_employer!.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          nonMumbai.tenant_letter_from_employer!.path,
          filename: nonMumbai.tenant_letter_from_employer!.path
              .split('/')
              .last, // Use the file name
        ),
      });

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await _dio.post('verify/police/non-mumbai/form/save', data: formData);
      // log('tenantNonMumbaiForm Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantNonMumbaiForm: $e');
      throw Exception('Failed to fetch tenantNonMumbaiForm: $e');
    }
  }

  Future<Response> tenantNonMumbaiFormUpdate(
      {required String token,
        required String customer_id,
        required NonMumbaiUpdateModel nonMumbaiUpdateModel}) async {
    try {
      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": nonMumbaiUpdateModel.request_id,
        "service_request_id": nonMumbaiUpdateModel.service_request_id,
        "tenant_name": nonMumbaiUpdateModel.tenant_name,
        "tenant_address": nonMumbaiUpdateModel.tenant_address,
        "tenant_city": nonMumbaiUpdateModel.tenant_city,
        "tenant_state": nonMumbaiUpdateModel.tenant_state,
        "tenant_postal_code": nonMumbaiUpdateModel.tenant_postal_code,
        "tenant_identity_proof_doc_type":
        nonMumbaiUpdateModel.tenant_identity_proof_doc_type,
        "tenant_identity_proof_no":
        nonMumbaiUpdateModel.tenant_identity_proof_no,
        "tenant_identification_mark":
        nonMumbaiUpdateModel.tenant_identification_mark,
        "tenant_dob": nonMumbaiUpdateModel.tenant_dob,
        "tenant_birth_place": nonMumbaiUpdateModel.tenant_birth_place,
        "tenant_age": nonMumbaiUpdateModel.tenant_age,
        "tenant_is_employed": nonMumbaiUpdateModel.tenant_is_employed,
        "tenant_employed_year": nonMumbaiUpdateModel.tenant_employed_year,
        "tenant_employed_month": nonMumbaiUpdateModel.tenant_employed_month,
        "tenant_employer_or_company":
        nonMumbaiUpdateModel.tenant_employer_or_company,
        "tenant_fathers_name": nonMumbaiUpdateModel.tenant_fathers_name,
        "tenant_fathers_address": nonMumbaiUpdateModel.tenant_fathers_address,
        "tenant_fathers_occupation":
        nonMumbaiUpdateModel.tenant_fathers_occupation,
        "tenant_contact_one_full_name":
        nonMumbaiUpdateModel.tenant_contact_one_full_name,
        "tenant_contact_one_address":
        nonMumbaiUpdateModel.tenant_contact_one_address,
        "tenant_contact_two_full_name":
        nonMumbaiUpdateModel.tenant_contact_two_full_name,
        "tenant_contact_two_address":
        nonMumbaiUpdateModel.tenant_contact_two_address,
        "tenant_has_criminal_offenses":
        nonMumbaiUpdateModel.tenant_has_criminal_offenses,
        nonMumbaiUpdateModel.tenant_crno_section.isEmpty
            ? ""
            : "tenant_crno_section": nonMumbaiUpdateModel.tenant_crno_section,
        "tenant_whether_arrested": nonMumbaiUpdateModel.tenant_whether_arrested,
        nonMumbaiUpdateModel.tenant_present_case_status.isEmpty
            ? ""
            : "tenant_present_case_status":
        nonMumbaiUpdateModel.tenant_present_case_status,
        "tenant_earlier_residential_place":
        nonMumbaiUpdateModel.tenant_earlier_residential_place,
        "tenant_earlier_residential_months":
        nonMumbaiUpdateModel.tenant_earlier_residential_months,
        "tenant_earlier_residential_years":
        nonMumbaiUpdateModel.tenant_earlier_residential_years,
        "tenant_earlier_residential_jurisdiction_of_police_station":
        nonMumbaiUpdateModel
            .tenant_earlier_residential_jurisdiction_of_police_station,
        "tenant_present_address_duration_years":
        nonMumbaiUpdateModel.tenant_present_address_duration_years,
        "tenant_present_address_duration_months":
        nonMumbaiUpdateModel.tenant_present_address_duration_months,
        "tenant_jurisdiction_of_police_station":
        nonMumbaiUpdateModel.tenant_jurisdiction_of_police_station,
        "tenant_present_resendential_place":
        nonMumbaiUpdateModel.tenant_present_resendential_place,
        "tenant_signature_place": nonMumbaiUpdateModel.tenant_signature_place,
        "tenant_signature_date": nonMumbaiUpdateModel.tenant_signature_date,
        "tenant_photo": nonMumbaiUpdateModel.tenant_photo.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          nonMumbaiUpdateModel.tenant_photo.path,
          filename: nonMumbaiUpdateModel.tenant_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_signature": nonMumbaiUpdateModel.tenant_signature.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          nonMumbaiUpdateModel.tenant_signature.path,
          filename: nonMumbaiUpdateModel.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc": nonMumbaiUpdateModel
            .tenant_identity_proof_doc.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          nonMumbaiUpdateModel.tenant_identity_proof_doc.path,
          filename: nonMumbaiUpdateModel.tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_letter_from_employer": nonMumbaiUpdateModel
            .tenant_letter_from_employer!.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          nonMumbaiUpdateModel.tenant_letter_from_employer!.path,
          filename: nonMumbaiUpdateModel.tenant_letter_from_employer!.path
              .split('/')
              .last, // Use the file name
        ),
      });

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('verify/police/non-mumbai/form/update',
          data: formData);
      // log('tenantNonMumbaiFormUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantNonMumbaiFormUpdate: $e');
      throw Exception('Failed to fetch tenantNonMumbaiFormUpdate: $e');
    }
  }

  Future<Response> nonMumbaiShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/police/non-mumbai/$uid');
      // log('mumbaiShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in mumbaiShowData: $e');
      throw Exception('Failed to fetch mumbaiShowData: $e');
    }
  }

  Future<Response> tenantNonMumbaiUploadDocuments(
      {required String token,
        required String customer_id,
        required UploadDocumentsNonMumbaiModel
        uploadDocumentsNonMumbaiModel}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": uploadDocumentsNonMumbaiModel.request_id,
        "service_request_id": uploadDocumentsNonMumbaiModel.service_request_id,
        "tenant_photo": await MultipartFile.fromFile(
          uploadDocumentsNonMumbaiModel.tenant_photo.path,
          filename: uploadDocumentsNonMumbaiModel.tenant_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_signature": await MultipartFile.fromFile(
          uploadDocumentsNonMumbaiModel.tenant_signature.path,
          filename: uploadDocumentsNonMumbaiModel.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc": await MultipartFile.fromFile(
          uploadDocumentsNonMumbaiModel.tenant_identity_proof_doc.path,
          filename: uploadDocumentsNonMumbaiModel.tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_letter_from_employer": await MultipartFile.fromFile(
          uploadDocumentsNonMumbaiModel.tenant_letter_from_employer.path,
          filename: uploadDocumentsNonMumbaiModel
              .tenant_letter_from_employer.path
              .split('/')
              .last, // Use the file name
        ),
        "data_document": await MultipartFile.fromFile(
          uploadDocumentsNonMumbaiModel.data_document.path,
          filename: uploadDocumentsNonMumbaiModel.data_document.path
              .split('/')
              .last, // Use the file name
        )
      });

      final response = await _dio.post('verify/police/non-mumbai/document/save',
          data: formData);
      // log('tenantNonMumbaiUploadDocuments Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantNonMumbaiUploadDocuments: $e');
      throw Exception('Failed to fetch tenantNonMumbaiUploadDocuments: $e');
    }
  }
  Future<Response> tenantNonMumbaiUpdateDocuments(
      {required String token,
        required String customer_id,
        required UpdateDocumentsNonMumbaiModel
        updateDocumentsNonMumbaiModel}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';

      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "request_id": updateDocumentsNonMumbaiModel.request_id,
        "service_request_id": updateDocumentsNonMumbaiModel.service_request_id,
        "tenant_photo": updateDocumentsNonMumbaiModel.tenant_photo.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsNonMumbaiModel.tenant_photo.path,
          filename: updateDocumentsNonMumbaiModel.tenant_photo.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_signature": updateDocumentsNonMumbaiModel
            .tenant_signature.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsNonMumbaiModel.tenant_signature.path,
          filename: updateDocumentsNonMumbaiModel.tenant_signature.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_identity_proof_doc": updateDocumentsNonMumbaiModel
            .tenant_identity_proof_doc.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsNonMumbaiModel.tenant_identity_proof_doc.path,
          filename: updateDocumentsNonMumbaiModel
              .tenant_identity_proof_doc.path
              .split('/')
              .last, // Use the file name
        ),
        "tenant_letter_from_employer": updateDocumentsNonMumbaiModel
            .tenant_letter_from_employer.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsNonMumbaiModel.tenant_letter_from_employer.path,
          filename: updateDocumentsNonMumbaiModel
              .tenant_letter_from_employer.path
              .split('/')
              .last, // Use the file name
        ),
        "data_document":
        updateDocumentsNonMumbaiModel.data_document.path.isEmpty
            ? null
            : await MultipartFile.fromFile(
          updateDocumentsNonMumbaiModel.data_document.path,
          filename: updateDocumentsNonMumbaiModel.data_document.path
              .split('/')
              .last, // Use the file name
        )
      });

      final response = await _dio
          .post('verify/police/non-mumbai/document/update', data: formData);
      // log('tenantNonMumbaiUpdateDocuments Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in tenantNonMumbaiUpdateDocuments: $e');
      throw Exception('Failed to fetch tenantNonMumbaiUpdateDocuments: $e');
    }
  }

  Future<Response> nonMumbaiDocumentShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/police/non-mumbai/$uid');
      // log('nonMumbaiDocumentShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in nonMumbaiDocumentShowData: $e');
      throw Exception('Failed to fetch nonMumbaiDocumentShowData: $e');
    }
  }



  /// Police Verification
































  Future<Response> AadhaarGetOtp(
      {required String token,
      required String serviceRequestId,
      required String requestId,
      required String customer_id,
      required String aadhaarNumber}) async {
    try {
      Map<String, dynamic> data = {
        "customer_id": customer_id,
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "aadhaar_number": aadhaarNumber,
      };

      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await _dio.post('verify/aadhaar/get-otp', queryParameters: data);
      // log('AadhaarGetOtp Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in AadhaarGetOtp: $e');
      throw Exception('Failed to fetch AadhaarGetOtp: $e');
    }
  }



  Future<Response> AadhaarVerifyOtp(
      {required String token,
      required String customerId,
      required String serviceRequestId,
      required String requestId,
      required String aadhaarNumber,
      required String otp}) async {
    try {
      Map<String, dynamic> data = {
        "customer_id": customerId,
        "service_request_id": serviceRequestId,
        "request_id": requestId,
        "aadhaar_number": aadhaarNumber,
        "otp": otp
      };

      print("aadhaar Data $data");
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await _dio.post('verify/aadhaar/verify-otp', queryParameters: data);
      // log('AadhaarVerifyOtp Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in AadhaarVerifyOtp: $e');
      throw Exception('Failed to fetch AadhaarVerifyOtp: $e');
    }
  }
































  Future<Response> collageNameGetData({
    required String token,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('college-schools');
      // log('collageNameGetData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in collageNameGetData: $e');
      throw Exception('Failed to fetch collageNameGetData: $e');
    }
  }

  Future<Response> universityNameGetData({
    required String token,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('universities-boards');
      // log('universityNameGetData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in universityNameGetData: $e');
      throw Exception('Failed to fetch universityNameGetData: $e');
    }
  }







  Future<Response> policeStationCityId({
    required String token,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('cities');
      // log('policeStationCityId Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in policeStationCityId: $e');
      throw Exception('Failed to fetch policeStationCityId: $e');
    }
  }

  Future<Response> policeStationIdGetData({
    required String token,
    required String city_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio
          .get('police-stations', queryParameters: {"city_id": city_id});
      // log('universityNameGetData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in universityNameGetData: $e');
      throw Exception('Failed to fetch universityNameGetData: $e');
    }
  }

  Future<Response> pushNotificationApi(
      {required String token,
      required String customer_id,
      required String firebase_id,
      required String os_version,
      required String app_version,
      required String mobile_model,
      required String device_type}) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "firebase_id": firebase_id,
      "os_version": os_version,
      "app_version": app_version,
      "mobile_model": mobile_model,
      "device_type": device_type,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await _dio.post('account/firebase/update', data: formData);
      // log('pushNotificationApi Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in pushNotificationApi: $e');
      throw Exception('Failed to fetch pushNotificationApi: $e');
    }
  }

  // Method to fetch data from the API
  // Future<List<DataModel>> fetchData(int page) async {
  //   final response = await http.get(Uri.parse(
  //       'https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=20'));
  //
  //   if (response.statusCode == 200) {
  //     log('in fetchData: ${response.body}');
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => DataModel.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }



  Future<Response> courtShowData(
      {required String token, required String uid}) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/court/show/$uid');
      // log('courtShowData Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in courtShowData: $e');
      throw Exception('Failed to fetch courtShowData: $e');
    }
  }




  Future<Response> nameAddressDocUpload({
    required String customer_id,
    required String token,
    required String request_id,
    required String service_request_id,
    required File aadhaar_front_side,
    required File aadhaar_back_side,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "aadhaar_front_side": aadhaar_front_side.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(
              aadhaar_front_side.path,
              filename:
                  aadhaar_front_side.path.split('/').last, // Use the file name
            ),
      "aadhaar_back_side": aadhaar_back_side.path.isEmpty
          ? ""
          : await MultipartFile.fromFile(
              aadhaar_back_side.path,
              filename:
                  aadhaar_back_side.path.split('/').last, // Use the file name
            ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await _dio.post('verify/name-address/document/store', data: formData);
      // log('nameAddressDocUpload Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in nameAddressDocUpload: $e');
      throw Exception('Failed to fetch nameAddressDocUpload: $e');
    }
  }

  Future<Response> nameAddressDocUpdate({
    required String customerId,
    required String token,
    required String request_id,
    required String service_request_id,
    required File aadhaar_front_side,
    required File aadhaar_back_side,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customerId,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "aadhaar_front_side": aadhaar_front_side.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
              aadhaar_front_side.path,
              filename:
                  aadhaar_front_side.path.split('/').last, // Use the file name
            ),
      "aadhaar_back_side": aadhaar_back_side.path.isEmpty
          ? null
          : await MultipartFile.fromFile(
              aadhaar_back_side.path,
              filename:
                  aadhaar_back_side.path.split('/').last, // Use the file name
            ),
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('verify/name-address/document/update',
          data: formData);
      // log('nameAddressDocUpload Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in nameAddressDocUpload: $e');
      throw Exception('Failed to fetch nameAddressDocUpload: $e');
    }
  }





  Future<Response> userAgreeCondition(
      {required String token,
      required String customer_id,
      required String flag}) async {
    try {
      FormData formData = FormData.fromMap({
        "customer_id": customer_id,
        "flag": flag,
      });
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await _dio.post('account/update/agree/status', data: formData);
      // log('userAgreeCondition Response: ${response.data}');
      return response;
    } catch (e) {
      // log('Error in userAgreeCondition: $e');
      throw Exception('Failed to fetch userAgreeCondition: $e');
    }
  }

  Future<Response> applyCoupon({
    required String token,
    required String customer_id,
    required String subtotal,
    required String coupon_code
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('calculate/amount',
        data: { "customer_id": customer_id, "subtotal": subtotal, "coupon_code": coupon_code, },);
      log('apply coupon Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in apply coupon: $e');
      throw Exception('Failed to fetch employShowData: $e');
    }
  }
}
