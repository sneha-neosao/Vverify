import 'package:flutter/cupertino.dart';
String? educationUniversityBoards;
String? educationSchoolBoards;

class employmentTextControllerNew {
  static TextEditingController employmentEmployerNameController = TextEditingController();
  static TextEditingController employmentDesignationController = TextEditingController();
  static TextEditingController employmentDepartmentController = TextEditingController();
  static TextEditingController employmentRemunerationController = TextEditingController();
  static TextEditingController employmentReportingManagerController = TextEditingController();
  static TextEditingController employmentReasonForLeavingController = TextEditingController();
}

void clearEmploymentControllerNew() {
  employmentTextControllerNew.employmentEmployerNameController.dispose();
  employmentTextControllerNew.employmentDesignationController.dispose();
  employmentTextControllerNew.employmentDepartmentController.dispose();
  employmentTextControllerNew.employmentRemunerationController.dispose();
  employmentTextControllerNew.employmentReportingManagerController.dispose();
  employmentTextControllerNew.employmentReasonForLeavingController.dispose();
}

void employmentControllerRecreateNew() {
  employmentTextControllerNew.employmentEmployerNameController = TextEditingController();
  employmentTextControllerNew.employmentDesignationController = TextEditingController();
  employmentTextControllerNew.employmentDepartmentController = TextEditingController();
  employmentTextControllerNew.employmentRemunerationController = TextEditingController();
  employmentTextControllerNew.employmentReportingManagerController = TextEditingController();
  employmentTextControllerNew.employmentReasonForLeavingController = TextEditingController();
}
