import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/form_widget.dart';
import '../../../../../common/id.dart';
import '../../TextControllers/mumbai_police_text_controller.dart';
import '../../Blocs/mumbai_police_verification_save_bloc/mumbai_police_save_form_cubit.dart';
import '../../Blocs/mumbai_police_verification_save_bloc/mumbai_police_save_state.dart';
import '../../Models/mumbai_police_save_form_model.dart';

class MumbaiPoliceSaveFormScreen5 extends StatefulWidget {
  const MumbaiPoliceSaveFormScreen5({super.key});

  @override
  State<MumbaiPoliceSaveFormScreen5> createState() =>
      _MumbaiPoliceSaveFormScreen5State();
}

class _MumbaiPoliceSaveFormScreen5State
    extends State<MumbaiPoliceSaveFormScreen5> {
  void mumbaiFormData() {
    print(mumbaiPoliceStationId);
    final String token = context.read<TokenCubit>().state;
    final String customerId = context.read<IdCubit>().state;

    context.read<MumbaiVerificationFormCubit>().nonMumbaiVerificationForm(
        customerId: customerId,
        token: token,
        mumbaiModel: MumbaiModel(
          request_id: requestId!,
          service_request_id: serviceRequestId!,
          police_station_id: int.parse(mumbaiPoliceStationId!),
          rented_address:
              mumbaiTextController.rentedPropertyAddressMumbaiController.text,
          rented_city: mumbaiTextController
              .rentedPropertyCityDistrictMumbaiController.text,
          rented_state:
              mumbaiTextController.rentedPropertyStateMumbaiController.text,
          rented_postal_code:
              mumbaiTextController.rentedPropertyPinCodeMumbaiController.text,
          agreement_start_date: mumbaiTextController
              .rentedPropertyAgreementStartDateController.text,
          agreement_end_date: mumbaiTextController
              .rentedPropertyAgreementEndDateController.text,
          owner_full_name:
              mumbaiTextController.ownerFullNameMumbaiController.text,
          owner_mob_no:
              mumbaiTextController.ownerMobileNumberMumbaiController.text,
          owner_email:
              mumbaiTextController.ownerEmailAddressMumbaiController.text,
          owner_address: mumbaiTextController.ownerAddressMumbaiController.text,
          owner_city_district:
              mumbaiTextController.ownerCityDistrictMumbaiController.text,
          owner_state: mumbaiTextController.ownerStateMumbaiController.text,
          owner_postal_code:
              mumbaiTextController.ownerPinCodeMumbaiController.text,
          tenant_name: mumbaiTextController.tenantNameMumbaiController.text,
          tenant_address:
              mumbaiTextController.tenantPermanentAddressMumbaiController.text,
          tenant_city:
              mumbaiTextController.tenantCityDistrictMumbaiController.text,
          tenant_state: mumbaiTextController.tenantStateMumbaiController.text,
          tenant_postal_code:
              mumbaiTextController.tenantPinCodeMumbaiController.text,
          tenant_identity_proof_doc_type: mumbaiSelectedValue.toString(),
          tenant_identity_proof_no:
              mumbaiTextController.tenantIdentityProofNoMumbaiController.text,
          tenant_co_resident_males_no:
              mumbaiTextController.tenantNoOfMaleController.text,
          tenant_co_resident_females_no:
              mumbaiTextController.tenantNoOfFemaleController.text,
          tenant_co_resident_children_no:
              mumbaiTextController.tenantNoOfChildController.text,
          tenant_work_phone: mumbaiTextController
              .tenantMobileNumberWorkPlaceMumbaiController.text,
          tenant_work_email:
              mumbaiTextController.tenantEmailIdWorkPlaceMumbaiController.text,
          tenant_occupation: mumbaiTextController
              .tenantOccupationWorkPlaceMumbaiController.text,
          tenant_work_place_address: mumbaiTextController
              .tenantAddressPlaceOfWorkPlaceMumbaiController.text,
          tenant_work_city: mumbaiTextController
              .tenantCityDistrictWorkPlaceMumbaiController.text,
          tenant_work_state:
              mumbaiTextController.tenantStateWorkPlaceMumbaiController.text,
          tenant_work_postal_code:
              mumbaiTextController.tenantPinCodeWorkPlaceMumbaiController.text,
          tenant_contact_one_full_name: mumbaiTextController
              .person1NamePersonKnowingMumbaiController.text,
          tenant_contact_one_phone: mumbaiTextController
              .person1MobileNoPersonKnowingMumbaiController.text,
          tenant_contact_two_full_name: mumbaiTextController
              .person2NamePersonKnowingMumbaiController.text,
          tenant_contact_two_phone: mumbaiTextController
              .person2MobileNOPersonKnowingMumbaiController.text,
          agent_name:
              mumbaiTextController.agentNamePersonKnowingMumbaiController.text,
          agent_details: mumbaiTextController
              .agentDetailsPersonKnowingMumbaiController.text,
          owner_photo: context.read<PropertyOwnersProfileImage>().state,
          tenant_photo: context.read<TenantPhotoProfileImage>().state,
          tenant_identity_proof_doc:
              context.read<TenantIdentityProofImage>().state,
          tenant_signature: context.read<TenantCompanyLetterImage>().state,
          city_id: mumbaiPoliceStationCityId,
        ));
  }

  final _formKey = GlobalKey<FormState>();

  void clearPickImage() {
    context.read<PropertyOwnersProfileImage>().clearImage();
    context.read<TenantPhotoProfileImage>().clearImage();
    context.read<TenantIdentityProofImage>().clearImage();
    context.read<TenantCompanyLetterImage>().clearImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Person Knowing Tenant's",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).primaryColorDark,
                        ),
                  ),
                  CustomRequiredTextField(
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .person1NamePersonKnowingMumbaiController,
                    titleText: 'Person 1 Name',
                    hintText: "Enter Person 1 Name",
                  ),
                  CustomRequiredTextField(
                    maskFormatter: [mobileMaskFormatter],
                    validator: validateMobile,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController
                        .person1MobileNoPersonKnowingMumbaiController,
                    titleText: 'Contact Number 1',
                    hintText: "Enter Contact Number 1",
                  ),
                  CustomRequiredTextField(
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .person2NamePersonKnowingMumbaiController,
                    titleText: 'Person 2 Name',
                    hintText: "Enter Person 2 Name",
                  ),
                  CustomRequiredTextField(
                    maskFormatter: [mobileMaskFormatter],
                    validator: validateMobile,
                    textInputType: TextInputType.number,
                    controller: mumbaiTextController
                        .person2MobileNOPersonKnowingMumbaiController,
                    titleText: 'Contact Number 2',
                    hintText: "Enter Contact Number 2",
                  ),
                  CustomRequiredTextField(
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .agentNamePersonKnowingMumbaiController,
                    titleText: 'Agent Name',
                    hintText: "Enter Agent Name",
                  ),
                  CustomRequiredTextField(
                    textInputType: TextInputType.text,
                    controller: mumbaiTextController
                        .agentDetailsPersonKnowingMumbaiController,
                    titleText: 'Agent Details',
                    hintText: "Enter Agent Details",
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocBuilder<TenantCompanyLetterImage, File>(
                      builder: (context, letterImage) {
                    return PickPhoto(
                      mainTitle: "Tenant's Signature Photo",
                      onPressedPickImage: () {
                        context
                            .read<TenantCompanyLetterImage>()
                            .pickFile()
                            .then((_) {
                          context.pop();
                        });
                      },
                      onPressedTakePhoto: () {
                        context
                            .read<TenantCompanyLetterImage>()
                            .pickImageFromCamera()
                            .then((_) {
                          context.pop();
                        });
                      },
                      title: "Select Tenant's Signature Photo",
                      image: letterImage,
                    );
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          height: 45,
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.pop();
                          },
                          text: "PREV",
                          gradientColors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColorDark,
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: BlocConsumer<MumbaiVerificationFormCubit,
                                MumbaiVerificationState>(
                            listener: (context, mumbaiForm) {
                          if (mumbaiForm is MumbaiVerificationSuccessState) {
                            if (mumbaiForm.data["status"] == 200) {
                              context.pushReplacementNamed("bottomNav");
          
                              clearPickImage();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(mumbaiForm.data["message"])));
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(mumbaiForm.data["message"])));
                          } else if (mumbaiForm is MumbaiVerificationErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(mumbaiForm.message)));
                          }
                        }, builder: (context, mumbaiForm) {
                          return CustomButton(
                              isLoading:
                                  mumbaiForm is MumbaiVerificationLoadingState,
                              height: 45,
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState?.validate() ?? false) {
                                  if (context
                                      .read<TenantCompanyLetterImage>()
                                      .state
                                      .path
                                      .isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Please upload documents")));
                                  }
                                  mumbaiFormData();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please fill all fields')));
                                }
                              },
                              text: "SUBMIT",
                              gradientColors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColorDark,
                              ]);
                        }),
                      )
                    ],
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
