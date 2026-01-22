import 'package:flutter/cupertino.dart';

class nonMumbaiTextController {
//form1 controller
  static TextEditingController tenantNameController = TextEditingController();
  static TextEditingController cityDistrictController = TextEditingController();
  static TextEditingController pinCodeController = TextEditingController();
  static TextEditingController identityProofController =
      TextEditingController();
  static TextEditingController permanentAddressController =
      TextEditingController();
  static TextEditingController stateController = TextEditingController();
  static TextEditingController identificationMarkController =
      TextEditingController();
  static TextEditingController identityProofNoController =
      TextEditingController();

//form2 controller
  static TextEditingController tenantBirthPlaceController =
      TextEditingController();
  static TextEditingController tenantAgeController = TextEditingController();
  static TextEditingController tenantCompanyNameController =
      TextEditingController();
  static TextEditingController tenantBirthDateController =
      TextEditingController();
  static TextEditingController tenantEmploymentYearsController =
      TextEditingController();
  static TextEditingController tenantEmploymentMonthController =
      TextEditingController();
  static TextEditingController tenantFatherNameController =
      TextEditingController();
  static TextEditingController tenantFatherAddressController =
      TextEditingController();
  static TextEditingController tenantFatherOccupationController =
      TextEditingController();

//form3 controller
  static TextEditingController person1NameController = TextEditingController();
  static TextEditingController name = TextEditingController();
  static TextEditingController person2NameController = TextEditingController();
  static TextEditingController residentialPoliceStationController3 =
      TextEditingController();
  static TextEditingController residentialYearsController =
      TextEditingController();
  static TextEditingController residentialMonthController =
      TextEditingController();
  static TextEditingController person1AddressController =
      TextEditingController();
  static TextEditingController person2AddressController =
      TextEditingController();
  static TextEditingController caseRegNoController = TextEditingController();
  static TextEditingController caseStatusController = TextEditingController();
  static TextEditingController earlierResidentialPlaceController =
      TextEditingController();

//form4 controller
  static TextEditingController residentialPoliceStationController4 =
      TextEditingController();
  static TextEditingController tenantPresentResidentialPlace =
      TextEditingController();
  static TextEditingController presentResidentialYearsController =
      TextEditingController();
  static TextEditingController presentResidentialMonthController =
      TextEditingController();
  static TextEditingController tenantsSignatureDateController =
      TextEditingController();
  static TextEditingController signaturePlaceController =
      TextEditingController();
}

String? nonMumbaiSelectedIdProof;

void nonMumbaiControllerCLear() {
  //form1 controller
  nonMumbaiTextController.tenantNameController.dispose();
  nonMumbaiTextController.cityDistrictController.dispose();
  nonMumbaiTextController.pinCodeController.dispose();
  nonMumbaiTextController.identityProofController.dispose();
  nonMumbaiTextController.permanentAddressController.dispose();
  nonMumbaiTextController.stateController.dispose();
  nonMumbaiTextController.identificationMarkController.dispose();
  nonMumbaiTextController.identityProofNoController.dispose();

//form2 controller
  nonMumbaiTextController.tenantBirthPlaceController.dispose();
  nonMumbaiTextController.tenantAgeController.dispose();
  nonMumbaiTextController.tenantCompanyNameController.dispose();
  nonMumbaiTextController.tenantBirthDateController.dispose();
  nonMumbaiTextController.tenantEmploymentYearsController.dispose();
  nonMumbaiTextController.tenantEmploymentMonthController.dispose();
  nonMumbaiTextController.tenantFatherNameController.dispose();
  nonMumbaiTextController.tenantFatherAddressController.dispose();
  nonMumbaiTextController.tenantFatherOccupationController.dispose();

//form3 controller
  nonMumbaiTextController.person1NameController.dispose();
  nonMumbaiTextController.name.dispose();
  nonMumbaiTextController.person2NameController.dispose();
  nonMumbaiTextController.residentialPoliceStationController3.dispose();
  nonMumbaiTextController.residentialYearsController.dispose();
  nonMumbaiTextController.residentialMonthController.dispose();
  nonMumbaiTextController.person1AddressController.dispose();
  nonMumbaiTextController.person2AddressController.dispose();
  nonMumbaiTextController.caseRegNoController.dispose();
  nonMumbaiTextController.caseStatusController.dispose();
  nonMumbaiTextController.earlierResidentialPlaceController.dispose();

//form4 controller
  nonMumbaiTextController.residentialPoliceStationController4.dispose();
  nonMumbaiTextController.tenantPresentResidentialPlace.dispose();
  nonMumbaiTextController.presentResidentialYearsController.dispose();
  nonMumbaiTextController.presentResidentialMonthController.dispose();
  nonMumbaiTextController.tenantsSignatureDateController.dispose();
  nonMumbaiTextController.signaturePlaceController.dispose();
}

void nonMumbaiControllerRecreate() {
  //form1 controller
  nonMumbaiTextController.tenantNameController = TextEditingController();
  nonMumbaiTextController.cityDistrictController = TextEditingController();
  nonMumbaiTextController.pinCodeController = TextEditingController();
  nonMumbaiTextController.identityProofController = TextEditingController();
  nonMumbaiTextController.permanentAddressController = TextEditingController();
  nonMumbaiTextController.stateController = TextEditingController();
  nonMumbaiTextController.identificationMarkController =
      TextEditingController();
  nonMumbaiTextController.identityProofNoController = TextEditingController();

//form2 controller
  nonMumbaiTextController.tenantBirthPlaceController = TextEditingController();
  nonMumbaiTextController.tenantAgeController = TextEditingController();
  nonMumbaiTextController.tenantCompanyNameController = TextEditingController();
  nonMumbaiTextController.tenantBirthDateController = TextEditingController();
  nonMumbaiTextController.tenantEmploymentYearsController =
      TextEditingController();
  nonMumbaiTextController.tenantEmploymentMonthController =
      TextEditingController();
  nonMumbaiTextController.tenantFatherNameController = TextEditingController();
  nonMumbaiTextController.tenantFatherAddressController =
      TextEditingController();
  nonMumbaiTextController.tenantFatherOccupationController =
      TextEditingController();

//form3 controller
  nonMumbaiTextController.person1NameController = TextEditingController();
  nonMumbaiTextController.name = TextEditingController();
  nonMumbaiTextController.person2NameController = TextEditingController();
  nonMumbaiTextController.residentialPoliceStationController3 =
      TextEditingController();
  nonMumbaiTextController.residentialYearsController = TextEditingController();
  nonMumbaiTextController.residentialMonthController = TextEditingController();
  nonMumbaiTextController.person1AddressController = TextEditingController();
  nonMumbaiTextController.person2AddressController = TextEditingController();
  nonMumbaiTextController.caseRegNoController = TextEditingController();
  nonMumbaiTextController.caseStatusController = TextEditingController();
  nonMumbaiTextController.earlierResidentialPlaceController =
      TextEditingController();

//form4 controller
  nonMumbaiTextController.residentialPoliceStationController4 =
      TextEditingController();
  nonMumbaiTextController.tenantPresentResidentialPlace =
      TextEditingController();
  nonMumbaiTextController.presentResidentialYearsController =
      TextEditingController();
  nonMumbaiTextController.presentResidentialMonthController =
      TextEditingController();
  nonMumbaiTextController.tenantsSignatureDateController =
      TextEditingController();
  nonMumbaiTextController.signaturePlaceController = TextEditingController();
}
