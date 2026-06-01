import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../screen/Order History/load_more/models/post.dart';
import '../screen/AllFormList/FormList/widgets/AddressVerification/Bloc/Models/address_save_model.dart';
import '../screen/AllFormList/FormList/widgets/AddressVerification/Bloc/Models/address_update_model.dart';
import '../screen/AllFormList/FormList/widgets/EducationVerification/Model/education_save_form_model.dart';
import '../screen/AllFormList/FormList/widgets/EducationVerification/Model/education_update_form_model.dart';
import '../screen/AllFormList/FormList/widgets/EmploymentVerification/Model/employment_save_form_model.dart';
import '../screen/AllFormList/FormList/widgets/EmploymentVerification/Model/employment_update_form_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  ApiService._internal() {
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

//resendOtp
  Future<Response> resendOtp({required String mobileNumber}) async {
    FormData formData = FormData.fromMap({
      'mobileNumber': mobileNumber,
    });
    final response = await _dio.post(
      'account/resend/otp',
      data: formData,
    );
    log('resendOtp $response');
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

  Future<Response> logout(
      {required String token, required String customerId}) async {
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      FormData formData = FormData.fromMap({
        'customerId': customerId,
      });
      final response = await _dio.post(
        'account/logout',
        data: formData,
      );
      log('logout Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in logout: $e');
      throw Exception('Failed to logout: $e');
    }
  }

  Future<Response> getServicesPricing(
      {required String token,
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

  // Future<Response> getAllEntities({required String token}) async {
  //   try {
  //     _dio.options.headers['Authorization'] = 'Bearer $token';
  //     final response = await _dio.get('all-entities');
  //     log('getAllEntities Response: ${response.data}');
  //     return response;
  //   } catch (e) {
  //     throw Exception('Failed to fetch getAllEntities: $e');
  //   }
  // }

  Future<Response> verifyRequestList({
    required String token,
    required int customer_id,
    required int page,
    required int limit,
    int? entity_id,
    String? v_status,
    String? search,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final queryParams = <String, dynamic>{
        'customer_id': customer_id,
        'page': page,
        'limit': limit,
        if (entity_id != null) 'entity_id': entity_id,
        if (v_status != null) 'v_status': v_status,
        if (search != null && search.isNotEmpty) 'search': search,
      };
      final response = await _dio.get(
        'verify-request/list',
        queryParameters: queryParams,
      );
      log('verifyRequestList Response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch verifyRequestList: $e');
    }
  }

  Future<Response> getTransactionCheckout({
    required String token,
    required int customer_id,
    required String payment_gateway,
    required String payment_mode,
    String? coupon_code,
    required List<Map<String, dynamic>> items,
    String device_type = "mobile",
  }) async {
    Map<String, dynamic> data = {
      "customer_id": customer_id,
      "device_type": device_type,
      "payment_gateway": payment_gateway,
      "payment_mode": payment_mode,
      "coupon_code": coupon_code,
      "items": items,
    };

    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('transaction/checkout', data: data);
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

  Future<Response> verifyRequestUpdate({
    required String token,
    required String uuid,
    int? group_id,
    String? company_name,
    String? firstName,
    String? middleName,
    String? lastName,
    String? phone,
    String? dob,
    String? email,
    String? employee_code,
    String? date_of_joining,
    String? gender,
  }) async {
    Map<String, dynamic> data = {
      "uuid": uuid,
      if (group_id != null) "group_id": group_id,
      if (company_name != null) "company_name": company_name,
      if (firstName != null) "first_name": firstName,
      if (middleName != null) "middle_name": middleName,
      if (lastName != null) "last_name": lastName,
      if (phone != null) "phone": phone,
      if (dob != null) "dob": dob,
      if (email != null) "email": email,
      if (employee_code != null) "employee_code": employee_code,
      if (date_of_joining != null) "date_of_joining": date_of_joining,
      if (gender != null) "gender": gender,
    };

    debugPrint('verifyRequestUpdate Request: ${data}');
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
          await _dio.put('verify-request/entity/update', data: data);
      log('verifyRequestUpdate Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in verifyRequestUpdate: $e');
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
      log('VerifyDetailsView Response: ${response.data}');
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

  Future<Response> VerifyServiceReportDownload({
    required String token,
    required String uuid,
    required int service_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'verify-request/report/service/pdf/$uuid/$service_id',
        options: Options(responseType: ResponseType.bytes),
      );
      return response;
    } catch (e) {
      log('Error in VerifyServiceReportDownload: $e');
      throw Exception('Failed to fetch VerifyServiceReportDownload: $e');
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

  Future<Response> EducationFormSave(
      {required String token,
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
        "degree_qualification_name":
            educationSaveFormModel.degree_qualification_name,
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

  Future<Response> EducationFormUpdate(
      {required String customer_id,
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
        "degree_qualification_name":
            educationUpdateFormModel.degree_qualification_name,
        "grades_type": educationUpdateFormModel.grades_type,
        "grades_obtained": educationUpdateFormModel.grades_obtained,
        "case_uuid": educationUpdateFormModel.case_uuid,
        "education_uuid": educationUpdateFormModel.education_uuid
      });
      print("education formData${formData.fields}");
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
          "documents[$i][file]": await MultipartFile.fromFile(
            documents[i].path,
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

  Future<Response> EmploymentSaveForm(
      {required String token,
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

  Future<Response> employmentUpdateForm(
      {required String token,
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
      log('employShowData Response: ${response.data}');
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
          "documents[$i][file]": await MultipartFile.fromFile(
            documents[i].path,
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
      required NameAddressVerificationModel
          nameAddressVerificationModel}) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": nameAddressVerificationModel.request_id,
      "service_request_id": nameAddressVerificationModel.service_request_id,
      "current_address_line_1":
          nameAddressVerificationModel.current_address_line_1,
      "current_address_line_2":
          nameAddressVerificationModel.current_address_line_2,
      "current_address_city": nameAddressVerificationModel.current_city_id,
      "current_address_state": nameAddressVerificationModel.current_state,
      "current_address_postal_code":
          nameAddressVerificationModel.current_pinCode,
      // "permanent_address_line_1": nameAddressVerificationModel.permanent_address_line_1,
      // "permanent_address_line_2": nameAddressVerificationModel.permanent_address_line_2,
      // "permanent_address_city": nameAddressVerificationModel.permanent_city_id,
      // "permanent_address_state": nameAddressVerificationModel.permanent_state,
      // "permanent_address_postal_code": nameAddressVerificationModel.permanent_pinCode,
      // "residing_from_date": nameAddressVerificationModel.residing_from_date,
      // "residing_to_date": nameAddressVerificationModel.residing_to_date,
      "data_preference": nameAddressVerificationModel.data_preference,
      "case_uuid": nameAddressVerificationModel.case_uuid,
      // "till_date": nameAddressVerificationModel.till_date,
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
      "service_request_id":
          nameAddressVerificationUpdateModel.service_request_id,
      "current_address_line_1":
          nameAddressVerificationUpdateModel.current_address_line_1,
      "current_address_line_2":
          nameAddressVerificationUpdateModel.current_address_line_2,
      "current_address_city":
          nameAddressVerificationUpdateModel.current_city_id,
      "current_address_state": nameAddressVerificationUpdateModel.current_state,
      "current_address_postal_code":
          nameAddressVerificationUpdateModel.current_pinCode,
      // "permanent_address_line_1": nameAddressVerificationUpdateModel.permanent_address_line_1,
      // "permanent_address_line_2": nameAddressVerificationUpdateModel.permanent_address_line_2,
      // "permanent_address_city": nameAddressVerificationUpdateModel.permanent_city_id,
      // "permanent_address_state": nameAddressVerificationUpdateModel.permanent_state,
      // "permanent_address_postal_code": nameAddressVerificationUpdateModel.permanent_pinCode,
      "case_uuid": nameAddressVerificationUpdateModel.case_uuid,
      "address_uuid": nameAddressVerificationUpdateModel.address_uuid,
      "data_preference": nameAddressVerificationUpdateModel.data_preference,
      // "residing_from_date": nameAddressVerificationUpdateModel.residing_from_date,
      // "residing_to_date": nameAddressVerificationUpdateModel.residing_to_date,
      "uid": nameAddressVerificationUpdateModel.uid,
    });
    print("address update formData fields: ${formData.fields}");

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
          "documents[$i][file]": await MultipartFile.fromFile(
            documents[i].path,
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
  Future<Response> panVerificationMultipart({
    required String token,
    required String requestId,
    required String serviceRequestId,
    required String serviceId,
    required String customerId,
    required String documentType,
    required String documentNumber,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "service_id": serviceId,
        "customer_id": customerId,
        "document_type": documentType,
        "document_number": documentNumber,
      });

      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile',
      };
      final response = await _dio.post(
        'verify/pan/form/store',
        data: formData,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to submit PAN verification: $e');
    }
  }

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
      final response = await _dio.get(
        'verify/pan/show/$uid', /*data: formData*/
      );
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
          "documents[$i]": await MultipartFile.fromFile(
            documents[i].path,
          ),
      });

      // Debug logs
      log("=== AddressDocsUpload Request ===");
      log("Files: ${documents.map((d) => d.path.split('/').last).toList()}");

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
          "documents[$i]": await MultipartFile.fromFile(
            documents[i].path,
          ),
      });

      // Debug logs
      log("=== AddressDocsUpload Request ===");
      log("Files: ${documents.map((d) => d.path.split('/').last).toList()}");

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

  Future<Response> courtVerificationShowData({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/court/show/$uid');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch courtVerificationShowData: $e');
    }
  }

  Future<Response> bankVerificationForm({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      FormData formData = FormData.fromMap(data);
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
          await _dio.post('verify/bank/form/store', data: formData);
      return response;
    } catch (e) {
      throw Exception('Failed to store bank verification form: $e');
    }
  }

  Future<Response> bankVerificationShowData({
    required String token,
    required String uid,
  }) async {
    print("bankVerificationShowData Token: $token");
    print("bankVerificationShowData Uid: $uid");
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('verify/bank/show/$uid');
      log('bankVerificationShowData Response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch bankVerificationShowData: $e');
    }
  }

  Future<Response> bankVerificationUpdate({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      FormData formData = FormData.fromMap(data);
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
          await _dio.post('verify/bank/form/update', data: formData);
      return response;
    } catch (e) {
      throw Exception('Failed to update bank verification form: $e');
    }
  }

  Future<Response> referenceFormStore({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    log("referenceFormStore Data: $data");
    try {
      FormData formData = FormData.fromMap(data);
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
          await _dio.post('verify/reference/form/store', data: formData);
      log('referenceFormStore Response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception('Failed to store reference form: $e');
    }
  }

  Future<Response> mediaCheckStore({
    required String token,
    required String requestId,
    required String serviceRequestId,
    required String customerId,
    required String serviceId,
    required String keyword,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'request_id': requestId,
        'service_request_id': serviceRequestId,
        'customer_id': customerId,
        'service_id': serviceId,
        'keyword': keyword,
      });
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
          await _dio.post('verify/media-check/store', data: formData);
      log('mediaCheckStore Response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception('Failed to verify media check: $e');
    }
  }

  Future<Response> mediaCheckShow({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response = await _dio.get('verify/media-check/show/$uid');
      log('mediaCheckShow Response: ${response.data}');
      return response;
    } catch (e) {
      throw Exception('Failed to fetch media check details: $e');
    }
  }

  Future<Response> referenceFormUpdate({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      FormData formData = FormData.fromMap(data);
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile'
      };
      final response =
          await _dio.post('verify/reference/form/update', data: formData);
      return response;
    } catch (e) {
      throw Exception('Failed to update reference form: $e');
    }
  }

  // Future<Response> ReferenceVerification(
  //     {required String customer_id,
  //     required String token,
  //     required ReferenceModel referenceModel}) async {
  //   FormData formData = FormData.fromMap({
  //     "customer_id": customer_id,
  //     "request_id": referenceModel.request_id,
  //     "service_request_id": referenceModel.service_request_id,
  //     "person_name_1": referenceModel.person_name_one,
  //     "person_mobile_number_1": referenceModel.person_mobile_number_one,
  //     "person_relation_1": referenceModel.person_relation_one,
  //     "person_name_2": referenceModel.person_name_two,
  //     "person_mobile_number_2": referenceModel.person_mobile_number_two,
  //     "person_relation_2": referenceModel.person_relation_two,
  //   });

  //   try {
  //     _dio.options.headers['Authorization'] = 'Bearer $token';
  //     final response =
  //         await _dio.post('verify/reference/form/store', data: formData);
  //     // log('ReferenceVerification Response: ${response.data}');
  //     return response;
  //   } catch (e) {
  //     // log('Error in ReferenceVerification: $e');
  //     throw Exception('Failed to fetch ReferenceVerification: $e');
  //   }
  // }

  // Future<Response> ReferenceVerificationUpdate(
  //     {required String token,
  //     required String customer_id,
  //     required ReferenceUpdateModel referenceUpdateModel}) async {
  //   FormData formData = FormData.fromMap({
  //     "customer_id": customer_id,
  //     "request_id": referenceUpdateModel.request_id,
  //     "service_request_id": referenceUpdateModel.service_request_id,
  //     "person_name_1": referenceUpdateModel.person_name_one,
  //     "person_mobile_number_1": referenceUpdateModel.person_mobile_number_one,
  //     "person_relation_1": referenceUpdateModel.person_relation_one,
  //     "person_name_2": referenceUpdateModel.person_name_two,
  //     "person_mobile_number_2": referenceUpdateModel.person_mobile_number_two,
  //     "person_relation_2": referenceUpdateModel.person_relation_two,
  //   });

  //   try {
  //     _dio.options.headers['Authorization'] = 'Bearer $token';
  //     final response =
  //         await _dio.post('verify/reference/form/update', data: formData);
  //     // log('verifyRequestUpdate Response: ${response.data}');
  //     return response;
  //   } catch (e) {
  //     // log('Error in verifyRequestUpdate:$e');
  //     throw Exception('Failed to fetch verifyRequestUpdate: $e');
  //   }
  // }

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
    required String service_id,
    required String document_type,
    required String document_number,
    required String dob,
    required File? document_scan_pdf,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "service_id": service_id,
      "document_type": document_type,
      "document_number": document_number,
      "dob": dob,
      "document_scan_pdf":
          document_scan_pdf != null && document_scan_pdf.path.isNotEmpty
              ? await MultipartFile.fromFile(
                  document_scan_pdf.path,
                  filename: document_scan_pdf.path.split('/').last,
                )
              : null,
    });
    log('drivingLicenceSave Request: ${formData.files}');
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile',
      };
      final response = await _dio.post('verify/pan/form/store', data: formData);
      log('drivingLicenceSave Response: ${response.data}');
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
      // final response = await _dio.get('verify/driver-licence/show/$uid');
      final response = await _dio.get('verify/pan/show/$uid');
      log('drivingLicenceShowData Response: ${response.data}');
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

  /// Aadhaar / DigiLocker Verification

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

  Future<Response> calculateAmount({
    required String token,
    String? coupon_code,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post(
        'calculate/amount',
        data: {
          if (coupon_code != null && coupon_code.isNotEmpty)
            "coupon_code": coupon_code,
          "items": items,
        },
      );
      log('calculateAmount Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in calculateAmount: $e');
      throw Exception('Failed to calculate amount: $e');
    }
  }

  Future<Response> extractAadhaarOcr(
      {required File file, String documentType = "adhaar"}) async {
    try {
      FormData formData = FormData.fromMap({
        "document_type": documentType,
        "attachment": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await _dio.post(
        "https://ocr.neosao.co.in/ocr/extract",
        data: formData,
      );
      log('extractAadhaarOcr Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in extractAadhaarOcr: $e');
      throw Exception('Failed to extract $documentType OCR: $e');
    }
  }

  Future<Response> dashboardCount({
    required String token,
    required String customer_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'dashboard-counts?customer_id=$customer_id',
      );
      log('dashboardCount Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in dashboardCount: $e');
      throw Exception('Failed to dashboardCount: $e');
    }
  }

  Future<Response> dashboardAllEntities({
    required String token,
    required String customer_id,
  }) async {
    log("dashboardAllEntities: $customer_id");
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'dashboard/all-entities?customer_id=$customer_id',
      );
      log('dashboardAllEntities Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in dashboardAllEntities: $e');
      throw Exception('Failed to dashboardAllEntities: $e');
    }
  }

  Future<Response> entitiesData({
    required String token,
    required String customer_id,
    required String entity_id,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'entities-data?customer_id=$customer_id&entity_id=$entity_id',
      );
      log('entitiesData Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in entitiesData: $e');
      throw Exception('Failed to entitiesData: $e');
    }
  }

  Future<Response> aadhaarDigilockerSave({
    required String token,
    required String customer_id,
    required String request_id,
    required String service_request_id,
    required String document_number,
    required String document_type,
    required String service_id,
    String? dob,
  }) async {
    FormData formData = FormData.fromMap({
      "customer_id": customer_id,
      "request_id": request_id,
      "service_request_id": service_request_id,
      "document_number": document_number,
      "document_type": document_type,
      "service_id": service_id,
      if (dob != null) "dob": dob,
    });
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('verify/pan/form/store', data: formData);
      log('aadhaarDigilockerSave Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in aadhaarDigilockerSave: $e');
      throw Exception('Failed to fetch aadhaarDigilockerSave: $e');
    }
  }

  Future<Response> verifyAadharDigilocker({
    required String token,
    required int request_id,
    required int service_request_id,
    required int customer_id,
    required String aadhaar_number,
    required String status,
    required String unifiedTransactionId,
    required int service_id,
  }) async {
    FormData formData = FormData.fromMap({
      "request_id": request_id,
      "service_request_id": service_request_id,
      "customer_id": customer_id,
      "aadhaar_number": aadhaar_number,
      "status": status,
      "unifiedTransactionId": unifiedTransactionId,
      "service_id": service_id,
    });

    log('verifyAadharDigilocker body: ${formData.fields}');
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('verification/aadhar', data: formData);
      log('verifyAadharDigilocker Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in verifyAadharDigilocker: $e');
      throw Exception('Failed to fetch verifyAadharDigilocker: $e');
    }
  }

  // Credit Report Send OTP
  Future<Response> sendCreditReportOtp({
    required String token,
    required String mobileNumber,
    required String type,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final Map<String, dynamic> data = {
        "mobile_number": mobileNumber,
        "type": type,
      };
      final response = await _dio.post(
        'verify/credit/report-otp',
        data: data,
      );
      log('sendCreditReportOtp Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in sendCreditReportOtp: $e');
      throw Exception('Failed to send credit report OTP: $e');
    }
  }

  // Credit Report Store (Multipart Form Data)
  Future<Response> storeCreditReport({
    required String token,
    required int requestId,
    required int serviceRequestId,
    required int customerId,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile',
      };
      FormData formData = FormData.fromMap({
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "customer_id": customerId,
        "first_name": firstName,
        "last_name": lastName,
        "mobile_number": mobileNumber,
        "otp": otp,
      });
      final response = await _dio.post(
        'verify/credit/form/store',
        data: formData,
      );
      log('storeCreditReport Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in storeCreditReport: $e');
      throw Exception('Failed to store credit report: $e');
    }
  }

  // Credit Report Show
  Future<Response> showCreditReport({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'verify/credit/show/$uid',
      );
      log('showCreditReport Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in showCreditReport: $e');
      throw Exception('Failed to show credit report: $e');
    }
  }

  // GST Verification Store (Multipart Form Data)
  Future<Response> storeGstVerification({
    required String token,
    required int requestId,
    required int serviceRequestId,
    required int customerId,
    required String gstNumber,
  }) async {
    try {
      _dio.options.headers = {
        'Authorization': 'Bearer $token',
        'X-Action-From': 'mobile',
      };
      FormData formData = FormData.fromMap({
        "request_id": requestId,
        "service_request_id": serviceRequestId,
        "customer_id": customerId,
        "gst_number": gstNumber,
      });
      final response = await _dio.post(
        'verify/gst-pan-cin/form/store',
        data: formData,
      );
      log('storeGstVerification Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in storeGstVerification: $e');
      throw Exception('Failed to store GST verification: $e');
    }
  }

  // GST Verification Show
  Future<Response> showGstVerification({
    required String token,
    required String uid,
  }) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get(
        'verify/gst-pan-cin/show/$uid',
      );
      log('showGstVerification Response: ${response.data}');
      return response;
    } catch (e) {
      log('Error in showGstVerification: $e');
      throw Exception('Failed to show GST verification: $e');
    }
  }
}
