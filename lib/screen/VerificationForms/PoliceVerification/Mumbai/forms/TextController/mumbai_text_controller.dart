import 'package:flutter/cupertino.dart';

class mumbaiTextController {


//mumbai form 1 controller
  static TextEditingController policeStationMumbaiController = TextEditingController();
  static TextEditingController ownerMobileNumberMumbaiController =
   TextEditingController();
  static TextEditingController ownerAddressMumbaiController = TextEditingController();
  static TextEditingController ownerStateMumbaiController = TextEditingController();
  static TextEditingController ownerFullNameMumbaiController = TextEditingController();
  static TextEditingController ownerEmailAddressMumbaiController =
   TextEditingController();
  static TextEditingController ownerCityDistrictMumbaiController =
   TextEditingController();
  static TextEditingController ownerPinCodeMumbaiController = TextEditingController();

//mumbai form 2 controller
  static TextEditingController rentedPropertyAddressMumbaiController =
   TextEditingController();
  static TextEditingController rentedPropertyStateMumbaiController =
   TextEditingController();
  static TextEditingController rentedPropertyCityDistrictMumbaiController =
   TextEditingController();
  static TextEditingController rentedPropertyPinCodeMumbaiController =
   TextEditingController();
  static TextEditingController rentedPropertyAgreementStartDateController =
   TextEditingController();
  static TextEditingController rentedPropertyAgreementEndDateController =
   TextEditingController();

//mumbai form 3 controller
  static TextEditingController tenantNameMumbaiController = TextEditingController();
  static TextEditingController tenantCityDistrictMumbaiController =
   TextEditingController();
  static TextEditingController tenantPinCodeMumbaiController = TextEditingController();
  static TextEditingController tenantIdentityProofNoMumbaiController =
   TextEditingController();
  static TextEditingController tenantPermanentAddressMumbaiController =
   TextEditingController();
  static TextEditingController tenantStateMumbaiController = TextEditingController();
  static TextEditingController tenantIdentityProofMumbaiController =
   TextEditingController();
  static TextEditingController tenantNoOfMaleController = TextEditingController();
  static TextEditingController tenantNoOfFemaleController = TextEditingController();
  static TextEditingController tenantNoOfChildController = TextEditingController();

//mumbai form 4 controller
  static TextEditingController tenantMobileNumberWorkPlaceMumbaiController =
   TextEditingController();
  static TextEditingController tenantOccupationWorkPlaceMumbaiController =
   TextEditingController();
  static TextEditingController tenantCityDistrictWorkPlaceMumbaiController =
   TextEditingController();
  static TextEditingController tenantPinCodeWorkPlaceMumbaiController =
   TextEditingController();
  static TextEditingController tenantEmailIdWorkPlaceMumbaiController =
   TextEditingController();
  static TextEditingController tenantAddressPlaceOfWorkPlaceMumbaiController =
   TextEditingController();
  static TextEditingController tenantStateWorkPlaceMumbaiController =
   TextEditingController();

//mumbai form 5 controller
  static TextEditingController person1NamePersonKnowingMumbaiController =
   TextEditingController();
  static TextEditingController person1MobileNoPersonKnowingMumbaiController =
   TextEditingController();
  static TextEditingController person2NamePersonKnowingMumbaiController =
   TextEditingController();
  static TextEditingController person2MobileNOPersonKnowingMumbaiController =
   TextEditingController();
  static TextEditingController agentNamePersonKnowingMumbaiController =
   TextEditingController();
  static TextEditingController agentDetailsPersonKnowingMumbaiController =
   TextEditingController();

}

String? mumbaiSelectedValue;
String? mumbaiPoliceStationId;
String mumbaiPoliceStationCityId = "";



void clearMumbaiController() {
  //mumbai form 1 controller
  mumbaiTextController.policeStationMumbaiController.dispose();
  mumbaiTextController.ownerMobileNumberMumbaiController.dispose();
  mumbaiTextController.ownerAddressMumbaiController.dispose();
  mumbaiTextController.ownerStateMumbaiController.dispose();
  mumbaiTextController.ownerFullNameMumbaiController.dispose();
  mumbaiTextController.ownerEmailAddressMumbaiController.dispose();
  mumbaiTextController.ownerCityDistrictMumbaiController.dispose();
  mumbaiTextController.ownerPinCodeMumbaiController.dispose();

//mumbai form 2 controller
  mumbaiTextController.rentedPropertyAddressMumbaiController.dispose();
  mumbaiTextController.rentedPropertyStateMumbaiController.dispose();
  mumbaiTextController.rentedPropertyCityDistrictMumbaiController.dispose();
  mumbaiTextController.rentedPropertyPinCodeMumbaiController.dispose();
  mumbaiTextController.rentedPropertyAgreementStartDateController.dispose();
  mumbaiTextController.rentedPropertyAgreementEndDateController.dispose();

//mumbai form 3 controller
  mumbaiTextController.tenantNameMumbaiController.dispose();
  mumbaiTextController.tenantCityDistrictMumbaiController.dispose();
  mumbaiTextController.tenantPinCodeMumbaiController.dispose();
  mumbaiTextController.tenantIdentityProofNoMumbaiController.dispose();
  mumbaiTextController.tenantPermanentAddressMumbaiController.dispose();
  mumbaiTextController.tenantStateMumbaiController.dispose();
  mumbaiTextController.tenantIdentityProofMumbaiController.dispose();
  mumbaiTextController.tenantNoOfMaleController.dispose();
  mumbaiTextController.tenantNoOfFemaleController.dispose();
  mumbaiTextController.tenantNoOfChildController.dispose();

//mumbai form 4 controller
  mumbaiTextController.tenantMobileNumberWorkPlaceMumbaiController.dispose();
  mumbaiTextController.tenantOccupationWorkPlaceMumbaiController.dispose();
  mumbaiTextController.tenantCityDistrictWorkPlaceMumbaiController.dispose();
  mumbaiTextController.tenantPinCodeWorkPlaceMumbaiController.dispose();
  mumbaiTextController.tenantEmailIdWorkPlaceMumbaiController.dispose();
  mumbaiTextController.tenantAddressPlaceOfWorkPlaceMumbaiController.dispose();
  mumbaiTextController.tenantStateWorkPlaceMumbaiController.dispose();

//mumbai form 5 controller
  mumbaiTextController.person1NamePersonKnowingMumbaiController.dispose();
  mumbaiTextController.person1MobileNoPersonKnowingMumbaiController.dispose();
  mumbaiTextController.person2NamePersonKnowingMumbaiController.dispose();
  mumbaiTextController.person2MobileNOPersonKnowingMumbaiController.dispose();
  mumbaiTextController.agentNamePersonKnowingMumbaiController.dispose();
  mumbaiTextController.agentDetailsPersonKnowingMumbaiController.dispose();
}

void mumbaiControllerRecreate() {
  //mumbai form 1 controller
  mumbaiTextController.policeStationMumbaiController=TextEditingController();
  mumbaiTextController.ownerMobileNumberMumbaiController=TextEditingController();
  mumbaiTextController.ownerAddressMumbaiController=TextEditingController();
  mumbaiTextController.ownerStateMumbaiController=TextEditingController();
  mumbaiTextController.ownerFullNameMumbaiController=TextEditingController();
  mumbaiTextController.ownerEmailAddressMumbaiController=TextEditingController();
  mumbaiTextController.ownerCityDistrictMumbaiController=TextEditingController();
  mumbaiTextController.ownerPinCodeMumbaiController=TextEditingController();

//mumbai form 2 controller
  mumbaiTextController.rentedPropertyAddressMumbaiController=TextEditingController();
  mumbaiTextController.rentedPropertyStateMumbaiController=TextEditingController();
  mumbaiTextController.rentedPropertyCityDistrictMumbaiController=TextEditingController();
  mumbaiTextController.rentedPropertyPinCodeMumbaiController=TextEditingController();
  mumbaiTextController.rentedPropertyAgreementStartDateController=TextEditingController();
  mumbaiTextController.rentedPropertyAgreementEndDateController=TextEditingController();

//mumbai form 3 controller
  mumbaiTextController.tenantNameMumbaiController=TextEditingController();
  mumbaiTextController.tenantCityDistrictMumbaiController=TextEditingController();
  mumbaiTextController.tenantPinCodeMumbaiController=TextEditingController();
  mumbaiTextController.tenantIdentityProofNoMumbaiController=TextEditingController();
  mumbaiTextController.tenantPermanentAddressMumbaiController=TextEditingController();
  mumbaiTextController.tenantStateMumbaiController=TextEditingController();
  mumbaiTextController.tenantIdentityProofMumbaiController=TextEditingController();
  mumbaiTextController.tenantNoOfMaleController=TextEditingController();
  mumbaiTextController.tenantNoOfFemaleController=TextEditingController();
  mumbaiTextController.tenantNoOfChildController=TextEditingController();

//mumbai form 4 controller
  mumbaiTextController.tenantMobileNumberWorkPlaceMumbaiController=TextEditingController();
  mumbaiTextController.tenantOccupationWorkPlaceMumbaiController=TextEditingController();
  mumbaiTextController.tenantCityDistrictWorkPlaceMumbaiController=TextEditingController();
  mumbaiTextController.tenantPinCodeWorkPlaceMumbaiController=TextEditingController();
  mumbaiTextController.tenantEmailIdWorkPlaceMumbaiController=TextEditingController();
  mumbaiTextController.tenantAddressPlaceOfWorkPlaceMumbaiController=TextEditingController();
  mumbaiTextController.tenantStateWorkPlaceMumbaiController=TextEditingController();

//mumbai form 5 controller
  mumbaiTextController.person1NamePersonKnowingMumbaiController=TextEditingController();
  mumbaiTextController.person1MobileNoPersonKnowingMumbaiController=TextEditingController();
  mumbaiTextController.person2NamePersonKnowingMumbaiController=TextEditingController();
  mumbaiTextController.person2MobileNOPersonKnowingMumbaiController=TextEditingController();
  mumbaiTextController.agentNamePersonKnowingMumbaiController=TextEditingController();
  mumbaiTextController.agentDetailsPersonKnowingMumbaiController=TextEditingController();
}
