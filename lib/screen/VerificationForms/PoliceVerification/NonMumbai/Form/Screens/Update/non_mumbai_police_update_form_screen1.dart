import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/TextControllers/non_mumbai_form_text_controller.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_show_details_bloc/non_mumbai_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Blocs/non_mumbai_show_details_bloc/non_mumbai_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/Models/non_mumbai_show_details_model.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';
import '../../../../../common/form_widget.dart';
import '../../../../../common/id.dart';
import '../../Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_cubit.dart';
import 'non_mumbai_police_update_form_screen2.dart';

class NonMumbaiPoliceUpdateFormScreen1 extends StatefulWidget {
  String uid;

  NonMumbaiPoliceUpdateFormScreen1({super.key, required this.uid});

  @override
  State<NonMumbaiPoliceUpdateFormScreen1> createState() =>
      _NonMumbaiPoliceUpdateFormScreen1State();
}

class _NonMumbaiPoliceUpdateFormScreen1State
    extends State<NonMumbaiPoliceUpdateFormScreen1> {
  // List of items in the dropdown menu
  final List<String> items = ['Pan', 'Aadhaar', 'Passport', 'Voter ID'];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nonMumbaiControllerRecreate();
    print("serviceId $serviceRequestId");
    print("serviceId $requestId");
    nonMumbaiShowData();
    super.initState();
  }

  @override
  void dispose() {
    nonMumbaiControllerCLear();
    super.dispose();
  }

  void nonMumbaiShowData() {
    String token = context.read<TokenCubit>().state;

    context
        .read<NonMumbaiShowDataCubit>()
        .nonMumbaiShowData(token: token, uid: widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: Form(
              key: _formKey,
              child:
                  BlocConsumer<NonMumbaiShowDataCubit, NonMumbaiShowDataState>(
                      listener: (context, nonMumbaiShowData) {
                if (nonMumbaiShowData is NonMumbaiShowDataSuccessState) {
                  NonMumbaiShowDataModel data =
                      nonMumbaiShowData.nonMumbaiShowDataModel;

                  nonMumbaiTextController.tenantsSignatureDateController.text =
                      "${data.data!.tenantSignatureDate!.toLocal()}"
                          .split(' ')[0];

                  nonMumbaiTextController.tenantNameController.text =
                      data.data!.tenantName!;

                  nonMumbaiTextController.permanentAddressController.text =
                      data.data!.tenantAddress!;

                  nonMumbaiTextController.cityDistrictController.text =
                      data.data!.tenantCity!;

                  nonMumbaiTextController.stateController.text =
                      data.data!.tenantState!;

                  nonMumbaiTextController.pinCodeController.text =
                      data.data!.tenantPostalCode!;

                  nonMumbaiTextController.tenantBirthPlaceController.text =
                      data.data!.tenantBirthPlace!;

                  nonMumbaiTextController.tenantBirthDateController.text =
                      "${data.data!.tenantDob!.toLocal()}".split(' ')[0];

                  nonMumbaiTextController.tenantAgeController.text =
                      data.data!.tenantAge!.toString();

                  nonMumbaiTextController.tenantCompanyNameController.text =
                      data.data!.tenantEmployerOrCompany.toString()!;

                  nonMumbaiTextController.tenantEmploymentYearsController.text =
                      data.data!.tenantEmployedYear.toString();

                  nonMumbaiTextController.tenantEmploymentMonthController.text =
                      data.data!.tenantEmployedMonth.toString()!;

                  nonMumbaiTextController.tenantFatherNameController.text =
                      data.data!.tenantFathersName!;

                  nonMumbaiTextController.tenantFatherAddressController.text =
                      data.data!.tenantAddress!;

                  nonMumbaiTextController.tenantFatherOccupationController
                      .text = data.data!.tenantFathersOccupation!;

                  nonMumbaiTextController.person1NameController.text =
                      data.data!.tenantContactOneFullName!;

                  nonMumbaiTextController.person1AddressController.text =
                      data.data!.tenantContactOneAddress!;

                  nonMumbaiTextController.person2NameController.text =
                      data.data!.tenantContactTwoFullName!;

                  nonMumbaiTextController.person2AddressController.text =
                      data.data!.tenantContactTwoAddress!;

                  nonMumbaiTextController
                          .residentialPoliceStationController3.text =
                      data.data!
                          .tenantEarlierResidentialJurisdictionOfPoliceStation!;

                  nonMumbaiTextController.residentialYearsController.text =
                      data.data!.tenantEarlierResidentialYears!;

                  nonMumbaiTextController.residentialMonthController.text =
                      data.data!.tenantEarlierResidentialMonths.toString()!;

                  nonMumbaiTextController.earlierResidentialPlaceController
                      .text = data.data!.tenantEarlierResidentialPlace!;

                  nonMumbaiTextController.residentialPoliceStationController4
                      .text = data.data!.tenantJurisdictionOfPoliceStation!;

                  // nonMumbaiTextController.tenantPresentResidentialPlace.text =
                  //     data.data!.tenantSignaturePlace!;

                  nonMumbaiTextController
                          .presentResidentialYearsController.text =
                      data.data!.tenantPresentAddressDurationYears.toString();

                  nonMumbaiTextController
                          .presentResidentialMonthController.text =
                      data.data!.tenantPresentAddressDurationMonths!.toString();

                  nonMumbaiTextController.signaturePlaceController.text =
                      data.data!.tenantSignaturePlace!.toString();
                }
              }, builder: (context, nonMumbaiShowData) {
                if (nonMumbaiShowData is NonMumbaiShowDataLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (nonMumbaiShowData is NonMumbaiShowDataErrorState) {
                  return Center(
                    child: Text(nonMumbaiShowData.message),
                  );
                } else if (nonMumbaiShowData is NonMumbaiShowDataSuccessState) {
                  NonMumbaiShowDataModel data =
                      nonMumbaiShowData.nonMumbaiShowDataModel;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Police Verification For Non-Mumbai Update",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Rejected Reason",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        data.data!.reason!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.red),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      form_widget(
                        maskFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z]')),
                        ],
                        textInputType: TextInputType.text,
                        controller:
                            nonMumbaiTextController.tenantNameController,
                        titleText: "Tenant's Name",
                        hintText: "Enter Tenant's Name",
                      ),
                      form_widget(
                        validator: addressValidator,
                        textInputType: TextInputType.text,
                        controller:
                            nonMumbaiTextController.permanentAddressController,
                        titleText: "Tenant's Permanent Address",
                        hintText: "Enter Tenant's Permanent Address",
                      ),
                      form_widget(
                        textInputType: TextInputType.text,
                        controller:
                            nonMumbaiTextController.cityDistrictController,
                        titleText: "Tenant's City/District",
                        hintText: "Enter City/District",
                      ),
                      form_widget(
                        textInputType: TextInputType.text,
                        controller: nonMumbaiTextController.stateController,
                        titleText: 'State',
                        hintText: "Enter State",
                      ),
                      form_widget(
                        maskFormatter: [pinMask],
                        validator: validatePinCode,
                        textInputType: TextInputType.number,
                        controller: nonMumbaiTextController.pinCodeController,
                        titleText: 'Pin Code',
                        hintText: "Enter Pin Code",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "Identity Proof Of Tenant's",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.w700),
                              children: [
                            TextSpan(
                              text: " * ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red),
                            ),
                          ])),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 50,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(gapPadding: 0)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              focusColor: Theme.of(context).cardColor,
                              dropdownColor: Theme.of(context).cardColor,
                              hint: Text(data.data!.tenantIdentityProofDocType!,
                                  style: Theme.of(context).textTheme.bodySmall),
                              value: nonMumbaiSelectedIdProof,
                              onChanged: (String? newValue) {
                                setState(() {
                                  nonMumbaiSelectedIdProof = newValue;
                                });
                              },
                              items: items.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    value,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      form_widget(
                        textInputType: TextInputType.text,
                        controller:
                            nonMumbaiTextController.identityProofNoController
                              ..text = data.data!.tenantIdentityProofNo!,
                        titleText: "Tenant's Identity Proof no",
                        hintText: "Enter Tenant's Identity Proof no",
                      ),
                      form_widget(
                        textInputType: TextInputType.text,
                        controller:
                            nonMumbaiTextController.identificationMarkController
                              ..text = data.data!.tenantIdentificationMark!,
                        titleText: "Tenant's identification Mark",
                        hintText: "Enter Tenant's identification Mark",
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      BlocBuilder<NonMumbaiPhotoCubit, File>(
                          builder: (context, tenantPhoto) {
                        return PickPhotoUpdate(
                          widthSize: double.infinity,
                          onPressedPickImage: () {
                            context
                                .read<NonMumbaiPhotoCubit>()
                                .pickImageFromGallery()
                                .then((_) {
                              context.pop();
                            });
                          },
                          onPressedTakePhoto: () {
                            context
                                .read<NonMumbaiPhotoCubit>()
                                .pickImageFromCamera()
                                .then((_) {
                              context.pop();
                            });
                          },
                          title: "Tenant's Photo",
                          image: tenantPhoto,
                          uploadImage: data.data!.tenantPhoto!,
                          mainTitle: "Select Tenant's Photo",
                        );
                      }),
                      const SizedBox(
                        height: 16,
                      ),
                      BlocBuilder<NonMumbaiIdentityProof, File>(
                          builder: (context, identityProof) {
                        return PickPhotoUpdate(
                          widthSize: double.infinity,
                          onPressedPickImage: () {
                            context
                                .read<NonMumbaiIdentityProof>()
                                .pickFile()
                                .then((_) {
                              context.pop();
                            });
                          },
                          onPressedTakePhoto: () {
                            context
                                .read<NonMumbaiIdentityProof>()
                                .pickImageFromCamera()
                                .then((_) {
                              context.pop();
                            });
                          },
                          title: 'Select Identity Proof',
                          image: identityProof,
                          uploadImage: data.data!.tenantIdentityProofDoc!,
                          mainTitle: "Upload Tenant's Identity Proof",
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
                              },
                              text: "PREV",
                              gradientColors: [
                                Theme.of(context).primaryColor.withOpacity(0.5),
                                Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.5),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: CustomButton(
                                height: 45,
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NonMumbaiUpdtaeFormScreen2()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill all fields')));
                                  }
                                },
                                text: "NEXT",
                                gradientColors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).primaryColorDark,
                                ]),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                }
                return const Center(
                  child: Text("Error..."),
                );
              }),
            )),
      ),
    );
  }
}
