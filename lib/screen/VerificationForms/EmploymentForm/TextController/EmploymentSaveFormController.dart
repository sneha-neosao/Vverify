import 'package:flutter/cupertino.dart';

class employmentTextController {
  static TextEditingController employmentNameController = TextEditingController();
  static TextEditingController employmentCompanyNameController = TextEditingController();
  static TextEditingController employmentCompanyAddressController =
  TextEditingController();
  static TextEditingController employmentCompanyCountryController =
  TextEditingController();
  static TextEditingController employmentCompanyStateController =
  TextEditingController();
  static TextEditingController employmentCompanyCityController = TextEditingController();
  static TextEditingController employmentCompanyPinCodeController =
  TextEditingController();
  static TextEditingController employmentIndustryController = TextEditingController();
  static TextEditingController employmentJobTitleController = TextEditingController();
  static TextEditingController employmentJobDepartmentController =
  TextEditingController();
  static TextEditingController employmentEmployeeCodeController =
  TextEditingController();
  static TextEditingController employmentCompanyJoiningDateController =
  TextEditingController();
  static TextEditingController employmentCompanyLeavingDateController =
  TextEditingController();
  static TextEditingController employmentExperienceYearController =
  TextEditingController();
  static TextEditingController employmentExperienceMonthsController =
  TextEditingController();
  static TextEditingController employmentCompanyLeavingReason = TextEditingController();
  static TextEditingController employmentEmployeeCurrencyController =
  TextEditingController();
  static TextEditingController employmentEmployeeSalaryController =
  TextEditingController();
  static TextEditingController employmentHrNameController = TextEditingController();
  static TextEditingController employmentHrPhoneNoController = TextEditingController();
  static TextEditingController employmentHrEmailController = TextEditingController();
  static TextEditingController employmentEmploymentCertificateNumberController =
  TextEditingController();
}

String? employmentStatus;
String? leavingReasonValue;
String? employPayFrequency;
String? employmentType;

String? joinDateFormat = "DD/MM/YYYY";
String? leavingDateFormat = "DD/MM/YYYY";

void employmentTextControllerDispose() {
//  employmentNameController.dispose();
  employmentTextController.employmentCompanyNameController.dispose();
  employmentTextController.employmentCompanyAddressController.dispose();
  employmentTextController.employmentCompanyCountryController.dispose();
  employmentTextController.employmentCompanyStateController.dispose();
  employmentTextController.employmentCompanyCityController.dispose();
  employmentTextController.employmentCompanyPinCodeController.dispose();
  employmentTextController.employmentIndustryController.dispose();
  employmentTextController.employmentJobTitleController.dispose();
  employmentTextController.employmentJobDepartmentController.dispose();
  employmentTextController.employmentEmployeeCodeController.dispose();
  employmentTextController.employmentCompanyJoiningDateController.dispose();
  employmentTextController.employmentCompanyLeavingDateController.dispose();
  employmentTextController.employmentExperienceYearController.dispose();
  employmentTextController.employmentExperienceMonthsController.dispose();
  employmentTextController.employmentEmployeeCurrencyController.dispose();
  employmentTextController.employmentEmployeeSalaryController.dispose();
  employmentTextController.employmentHrNameController.dispose();
  employmentTextController.employmentHrPhoneNoController.dispose();
  employmentTextController.employmentHrEmailController.dispose();
  employmentTextController.employmentEmploymentCertificateNumberController.dispose();
}

void employmentControllerRecreate() {
  // employmentNameController = TextEditingController();
  employmentTextController.employmentCompanyNameController = TextEditingController();
  employmentTextController.employmentCompanyAddressController = TextEditingController();
  employmentTextController.employmentCompanyCountryController = TextEditingController();
  employmentTextController.employmentCompanyStateController = TextEditingController();
  employmentTextController.employmentCompanyCityController = TextEditingController();
  employmentTextController.employmentCompanyPinCodeController = TextEditingController();
  employmentTextController.employmentIndustryController = TextEditingController();
  employmentTextController.employmentJobTitleController = TextEditingController();
  employmentTextController.employmentJobDepartmentController = TextEditingController();
  employmentTextController.employmentEmployeeCodeController = TextEditingController();
  employmentTextController.employmentCompanyJoiningDateController = TextEditingController();
  employmentTextController.employmentCompanyLeavingDateController = TextEditingController();
  employmentTextController.employmentExperienceYearController = TextEditingController();
  employmentTextController.employmentExperienceMonthsController = TextEditingController();
  employmentTextController.employmentEmployeeCurrencyController = TextEditingController();
  employmentTextController.employmentEmployeeSalaryController = TextEditingController();
  employmentTextController.employmentHrNameController = TextEditingController();
  employmentTextController.employmentHrPhoneNoController = TextEditingController();
  employmentTextController.employmentHrEmailController = TextEditingController();
  employmentTextController.employmentEmploymentCertificateNumberController = TextEditingController();
}
