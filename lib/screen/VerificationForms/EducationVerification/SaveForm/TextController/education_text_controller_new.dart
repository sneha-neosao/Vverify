import 'package:flutter/cupertino.dart';
String? educationUniversityBoards;
String? educationSchoolBoards;

class educationTextControllerNew {
  static TextEditingController educationUniversityNameController = TextEditingController();
  static TextEditingController educationInstitutionNameController = TextEditingController();
  static TextEditingController educationYearOfPassingController = TextEditingController();
  static TextEditingController educationDegreeQualificationNameController = TextEditingController();
  static TextEditingController educationGradeObtainedController = TextEditingController();
}

void clearEducationControllerNew() {
  educationTextControllerNew.educationUniversityNameController.dispose();
  educationTextControllerNew.educationInstitutionNameController.dispose();
  educationTextControllerNew.educationYearOfPassingController.dispose();
  educationTextControllerNew.educationDegreeQualificationNameController.dispose();
  educationTextControllerNew.educationGradeObtainedController.dispose();
}

void educationControllerRecreateNew() {
  educationTextControllerNew.educationUniversityNameController = TextEditingController();
  educationTextControllerNew.educationInstitutionNameController = TextEditingController();
  educationTextControllerNew.educationYearOfPassingController = TextEditingController();
  educationTextControllerNew.educationDegreeQualificationNameController = TextEditingController();
  educationTextControllerNew.educationGradeObtainedController = TextEditingController();
}
