import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:v_verify/screen/VerificationForms/PoliceVerification/NonMumbai/Form/TextControllers/non_mumbai_form_text_controller.dart';
import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../../../commonComponent/bloc/shared_preferences_cubit.dart';
import '../../../../../../../commonComponent/custom_button.dart';
import '../../../../../../Add Signature/add_signature.dart';
import '../../../../../common/form_widget.dart';
import '../../../../../common/id.dart';
import '../../Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_cubit.dart';
import '../../Blocs/non_mumbai_save_form_bloc/non_mumbai_save_form_state.dart';
import '../../Models/non_mumbai_police_save_form_model.dart';

class NonMumbaiPoliceSaveFormScreen4 extends StatefulWidget {
  const NonMumbaiPoliceSaveFormScreen4({super.key});

  @override
  State<NonMumbaiPoliceSaveFormScreen4> createState() =>
      _NonMumbaiPoliceSaveFormScreen4State();
}

class _NonMumbaiPoliceSaveFormScreen4State
    extends State<NonMumbaiPoliceSaveFormScreen4> {
  void nonMumbaiFormData() {
    print("dropDownValue $nonMumbaiSelectedIdProof");
    print("dropDownValue ${context.read<EmployedCubit>().state}");
    final String token = context.read<TokenCubit>().state;
    final String customerId = context.read<IdCubit>().state;

    context.read<NonMumbaiVerificationFormCubit>().nonMumbaiVerificationForm(
        token: token,
        customer_id: customerId,
        nonMumbaiModel: NonMumbaiModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            tenant_name: nonMumbaiTextController.tenantNameController.text,
            tenant_address:
                nonMumbaiTextController.permanentAddressController.text,
            tenant_city: nonMumbaiTextController.cityDistrictController.text,
            tenant_state: nonMumbaiTextController.stateController.text,
            tenant_postal_code: nonMumbaiTextController.pinCodeController.text,
            tenant_identity_proof_doc_type: nonMumbaiSelectedIdProof.toString(),
            tenant_identity_proof_no:
                nonMumbaiTextController.identityProofNoController.text,
            tenant_identification_mark:
                nonMumbaiTextController.identificationMarkController.text,
            tenant_dob: nonMumbaiTextController.tenantBirthDateController.text,
            tenant_birth_place:
                nonMumbaiTextController.tenantBirthPlaceController.text,
            tenant_age: nonMumbaiTextController.tenantAgeController.text,
            tenant_is_employed:
                context.read<EmployedCubit>().state == true ? "1" : "0",
            tenant_employed_year:
                nonMumbaiTextController.tenantEmploymentYearsController.text,
            tenant_employed_month:
                nonMumbaiTextController.tenantEmploymentMonthController.text,
            tenant_employer_or_company:
                nonMumbaiTextController.tenantCompanyNameController.text,
            tenant_fathers_name:
                nonMumbaiTextController.tenantFatherNameController.text,
            tenant_fathers_address:
                nonMumbaiTextController.tenantFatherAddressController.text,
            tenant_fathers_occupation:
                nonMumbaiTextController.tenantFatherOccupationController.text,
            tenant_contact_one_full_name:
                nonMumbaiTextController.person1NameController.text,
            tenant_contact_one_address:
                nonMumbaiTextController.person1AddressController.text,
            tenant_contact_two_full_name:
                nonMumbaiTextController.person2NameController.text,
            tenant_contact_two_address:
                nonMumbaiTextController.person2AddressController.text,
            tenant_has_criminal_offenses: context.read<CriminalCubit>().state == true ? "1" : "0",
            tenant_crno_section: context.read<CriminalCubit>().state == true ? nonMumbaiTextController.caseRegNoController.text : "",
            tenant_whether_arrested: context.read<ArrestedCubit>().state ? "1" : "0",
            tenant_present_case_status: nonMumbaiTextController.caseStatusController.text,
            tenant_earlier_residential_place: nonMumbaiTextController.earlierResidentialPlaceController.text,
            tenant_earlier_residential_months: nonMumbaiTextController.residentialMonthController.text,
            tenant_earlier_residential_years: nonMumbaiTextController.residentialYearsController.text,
            tenant_earlier_residential_jurisdiction_of_police_station: nonMumbaiTextController.residentialPoliceStationController3.text,
            tenant_present_address_duration_years: nonMumbaiTextController.presentResidentialYearsController.text,
            tenant_present_address_duration_months: nonMumbaiTextController.presentResidentialMonthController.text,
            tenant_jurisdiction_of_police_station: nonMumbaiTextController.residentialPoliceStationController4.text,
            tenant_present_resendential_place: nonMumbaiTextController.tenantPresentResidentialPlace.text,
            tenant_signature_place: nonMumbaiTextController.signaturePlaceController.text,
            tenant_signature_date: nonMumbaiTextController.tenantsSignatureDateController.text,
            tenant_photo: context.read<NonMumbaiPhotoCubit>().state,
            tenant_signature: context.read<NonMumbaiSignaturePhotoCubit>().state,
            tenant_identity_proof_doc: context.read<NonMumbaiIdentityProof>().state,
            tenant_letter_from_employer: context.read<NonMumbaiTenantCompanyLetterImage>().state.path.isEmpty ? File("") : context.read<NonMumbaiTenantCompanyLetterImage>().state));
  }

  final _formKey = GlobalKey<FormState>();
  DateTime selectedSignatureDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedSignatureDate, // initial date
        firstDate: DateTime(1900), // the earliest possible date
        lastDate: DateTime.now() // the latest possible date
        );
    if (picked != null && picked != selectedSignatureDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      setState(() {
        selectedSignatureDate = picked;
        nonMumbaiTextController.tenantsSignatureDateController.text =
            formattedDate;
        // "${selectedSignatureDate.toLocal()}".split(' ')[0];
      });
    }
  }

  void pickImageClear() {
    context.read<NonMumbaiTenantCompanyLetterImage>().clearImage();
    context.read<NonMumbaiSignaturePhotoCubit>().clearImage();
    context.read<NonMumbaiPhotoCubit>().clearImage();
    context.read<NonMumbaiIdentityProof>().clearImage();
    context.read<EmployedCubit>().clear();
    context.read<CriminalCubit>().clear();
    context.read<ArrestedCubit>().clear();
    context.read<FormUploadCubit>().clear();
  }

  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tenant's Details",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 18),
                ),
                form_widget(
                    validator: addressValidator,
                    textInputType: TextInputType.text,
                    controller: nonMumbaiTextController
                        .residentialPoliceStationController4,
                    titleText: "Tenant's Present Residential Police Station",
                    hintText: "Enter Residential Police Station"),
                // form_widget(
                //
                //     validator: addressValidator,
                //     textInputType: TextInputType.text,
                //     controller:
                //         nonMumbaiTextController.tenantPresentResidentialPlace,
                //     titleText: "Tenant's Present Residential Place",
                //     hintText: "Enter Present Residential Place"),
                form_widget(
                    maskFormatter: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.digitsOnly, // allows only digits 0–9
                    ],
                    textInputType: TextInputType.number,
                    controller: nonMumbaiTextController
                        .presentResidentialYearsController,
                    titleText: "Tenant's Present Residential Years",
                    hintText: "Enter Years"),
                const SizedBox(
                  width: 8,
                ),
                form_widget(
                    maskFormatter: [
                      LengthLimitingTextInputFormatter(2),
                      // limits to 2 characters
                      FilteringTextInputFormatter.digitsOnly,
                      // allows only digits
                    ],
                    textInputType: TextInputType.number,
                    controller: nonMumbaiTextController
                        .presentResidentialMonthController,
                    titleText: "Tenant's Present Residential Months",
                    hintText: "Enter Months"),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                    text: TextSpan(
                        text: "Tenant's Signature Date",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w700),
                        children: [
                      TextSpan(
                        text: " * ",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.red),
                      ),
                    ])),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  readOnly: true,
                  validator: validateDate,
                  style: Theme.of(context).textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  controller:
                      nonMumbaiTextController.tenantsSignatureDateController,
                  decoration: InputDecoration(
                    hintText: "YYYY-MM-DD",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectStartDate(
                          context), // Open date picker when icon is pressed
                    ),
                  ),
                ),
                form_widget(
                    validator: addressValidator,
                    textInputType: TextInputType.text,
                    controller:
                        nonMumbaiTextController.signaturePlaceController,
                    titleText: "Tenant's Signature Place",
                    hintText: "Enter Tenant's Signature Place"),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<NonMumbaiSignaturePhotoCubit, File>(
                    builder: (context, signaturePhoto) {
                  return PickPhoto(
                    isSign: true,
                    addSign: () {
                      context
                          .read<NonMumbaiSignaturePhotoCubit>()
                          .addSignature(context, _signaturePadKey)
                          .then((_) {
                        try {
                          // Deleting the image file from local storage
                          File(signaturePhoto.path).delete().then((_) {});
                          // Show confirmation message
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Image deleted!')));
                          // Pop the screen after deletion
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to delete image')));
                        }
                      });
                    },
                    mainTitle: "Tenant's Signature Photo",
                    widthSize: double.infinity,
                    onPressedPickImage: () {
                      context
                          .read<NonMumbaiSignaturePhotoCubit>()
                          .pickFile()
                          .then((_) {
                        context.pop();
                      });
                    },
                    onPressedTakePhoto: () {
                      context
                          .read<NonMumbaiSignaturePhotoCubit>()
                          .pickImageFromCamera()
                          .then((_) {
                        context.pop();
                      });
                    },
                    title: "Select Tenant's Signature Photo",
                    image: signImage != null ? signImage! : signaturePhoto,
                  );
                }),
                const SizedBox(
                  height: 24,
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
                      child: BlocConsumer<NonMumbaiVerificationFormCubit,
                              NonMumbaiVerificationState>(
                          listener: (context, nonMumbaiFrom) {
                        if (nonMumbaiFrom
                            is NonMumbaiVerificationSuccessState) {
                          if (nonMumbaiFrom.data["status"] == 200) {
                            context.pushReplacementNamed("bottomNav");

                            pickImageClear();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(nonMumbaiFrom.data["message"])));
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(nonMumbaiFrom.data["message"])));
                        } else if (nonMumbaiFrom
                            is NonMumbaiVerificationErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(nonMumbaiFrom.message)));
                        }
                      }, builder: (context, nonMumbaiFrom) {
                        return CustomButton(
                            isLoading: nonMumbaiFrom
                                is NonMumbaiVerificationLoadingState,
                            height: 45,
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState?.validate() ?? false) {
                                if (context
                                    .read<NonMumbaiSignaturePhotoCubit>()
                                    .state
                                    .path
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Please Upload Documents")));
                                } else {
                                  nonMumbaiFormData();
                                }
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
                    ),
                  ],
                ),
                const SizedBox(height: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
