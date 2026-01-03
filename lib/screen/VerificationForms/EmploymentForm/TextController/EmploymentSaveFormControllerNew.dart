import 'package:flutter/cupertino.dart';

class employmentTextControllerNew {
  static TextEditingController employmentDesignationController = TextEditingController();
  static TextEditingController employmentDepartmentController = TextEditingController();
  static TextEditingController employmentRemunerationController = TextEditingController();
  static TextEditingController employmentReportingManagerController = TextEditingController();
  static TextEditingController employmentReasonForLeavingController = TextEditingController();
}

String? employmentStatus;
String? leavingReasonValue;
String? employPayFrequency;
String? employmentType;

String? joinDateFormat = "DD/MM/YYYY";
String? leavingDateFormat = "DD/MM/YYYY";

void employmentTextControllerDispose() {
//  employmentNameController.dispose();
  employmentTextControllerNew.employmentDesignationController.dispose();
  employmentTextControllerNew.employmentDepartmentController.dispose();
  employmentTextControllerNew.employmentReportingManagerController.dispose();
  employmentTextControllerNew.employmentRemunerationController.dispose();
  employmentTextControllerNew.employmentReasonForLeavingController.dispose();
}

void employmentControllerRecreate() {
  // employmentNameController = TextEditingController();
  employmentTextControllerNew.employmentDesignationController = TextEditingController();
  employmentTextControllerNew.employmentDepartmentController = TextEditingController();
  employmentTextControllerNew.employmentRemunerationController = TextEditingController();
  employmentTextControllerNew.employmentReportingManagerController = TextEditingController();
  employmentTextControllerNew.employmentReasonForLeavingController = TextEditingController();
}
