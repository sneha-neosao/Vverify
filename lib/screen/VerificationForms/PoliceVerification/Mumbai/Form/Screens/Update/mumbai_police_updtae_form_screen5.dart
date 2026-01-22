import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_show_details_bloc/mumbai_police_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Blocs/mumbai_police_verification_show_details_bloc/mumbai_police_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/Mumbai/Form/Models/mumbai_police_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import 'package:v_verify/widgets/custom_required_text_field.dart';

import '../../../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../common/form_widget.dart';
import '../../../../../common/id.dart';
import '../../TextControllers/mumbai_police_text_controller.dart';
import '../../Blocs/mumbai_police_verification_save_bloc/mumbai_police_save_form_cubit.dart';
import '../../Blocs/mumbai_police_verification_update_bloc/mumbai_police_update_form_cubit.dart';
import '../../Blocs/mumbai_police_verification_update_bloc/mumbai_police_update_form_state.dart';
import '../../Models/mumbai_police_update_form_model.dart';

class MumbaiPoliceVerificationUpdateForm5 extends StatefulWidget {
  const MumbaiPoliceVerificationUpdateForm5({super.key});

  @override
  State<MumbaiPoliceVerificationUpdateForm5> createState() =>
      _MumbaiPoliceVerificationForm5State();
}

class _MumbaiPoliceVerificationForm5State
    extends State<MumbaiPoliceVerificationUpdateForm5> {
  void mumbaiUpdateFormData(
      {required String idProof, required int id, required int city_id}) {
    final String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<MumbaiPoliceUpdateFromCubit>().mumbaiPoliceUpdateForm(
        token: token,
        customer_id: customerId,
        mumbaiUpdateModel: MumbaiUpdateModel(
          request_id: requestId!,
          service_request_id: serviceRequestId!,
          police_station_id: mumbaiPoliceStationId == null
              ? id
              : int.parse(mumbaiPoliceStationId!),
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
          tenant_identity_proof_doc_type:
              mumbaiSelectedValue == null ? idProof : mumbaiSelectedValue!,
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
          city_id: mumbaiPoliceStationCityId.isEmpty
              ? city_id
              : int.parse(mumbaiPoliceStationCityId),
        ));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: BlocBuilder<MumbaiShowDataCubit, MumbaiShowDataState>(
                  builder: (context, mumbaiDataShow) {
                if (mumbaiDataShow is MumbaiShowDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (mumbaiDataShow is MumbaiShowDataErrorState) {
                  return Center(child: Text(mumbaiDataShow.message));
                } else if (mumbaiDataShow is MumbaiShowDataSuccessState) {
                  MumbaiShowDataModel data = mumbaiDataShow.mumbaiShowDataModel;
                  return Column(
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
                      BlocBuilder<TenantCompanyLetterImage, File>(
                          builder: (context, letterImage) {
                        return PickPhotoUpdate(
                          widthSize: double.infinity,
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
                          title: "Tenant's Signature Photo",
                          image: letterImage,
                          uploadImage: data.data!.tenantSignature!,
                          mainTitle: "Tenant's Signature Photo",
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
                            child: BlocConsumer<MumbaiPoliceUpdateFromCubit,
                                    MumbaiPoliceUpdateFormState>(
                                listener: (context, mumbaiUpdateForm) {
                              if (mumbaiUpdateForm
                                  is MumbaiPoliceUpdateFormSuccessState) {
                                if (mumbaiUpdateForm.data["status"] == 200) {
                                  context.pushReplacementNamed("bottomNav");
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            mumbaiUpdateForm.data["message"])));
                              } else if (mumbaiUpdateForm
                                  is MumbaiPoliceUpdateFormErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(mumbaiUpdateForm.message)));
                              }
                            }, builder: (context, mumbaiUpdateForm) {
                              return CustomButton(
                                  isLoading: mumbaiUpdateForm
                                      is MumbaiPoliceUpdateFormLoadingState,
                                  height: 45,
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      mumbaiUpdateFormData(
                                          idProof: data
                                              .data!.tenantIdentityProofDocType!,
                                          id: data.data!.policeStationId!,
                                          city_id: data.data!.city_id!);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Please fill all fields')));
                                    }
                                  },
                                  text: "SUBMIT",
                                  gradientColors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColorDark,
                                  ]);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  );
                }
                return const Center(
                  child: Text("Error..."),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
