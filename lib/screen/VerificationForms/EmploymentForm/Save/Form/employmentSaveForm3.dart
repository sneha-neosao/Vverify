import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Save/Model/employmentSaveForm_model.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/TextController/EmploymentSaveFormController.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../../common/id.dart';
import '../../../common/pickphoto.dart';
import '../Bloc/EmploymentSaveForm.dart';
import '../Bloc/EmploymentSaveFormState.dart';

enum showOnReport { yes, no }

class EmploymentSaveForm3 extends StatefulWidget {
  const EmploymentSaveForm3({super.key});

  @override
  State<EmploymentSaveForm3> createState() => _EmploymentSaveForm3State();
}

class _EmploymentSaveForm3State extends State<EmploymentSaveForm3> {
  void employmentSaveForm() {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    print(joinDateFormat.toString());
    print(leavingDateFormat.toString());
    context.read<EmploymentSaveFormCubit>().employmentSaveForm(
        customer_id: customerId,
        token: token,
        employmentSaveFormModel: EmploymentSaveFormModel(
            request_id: requestId!,
            service_request_id: serviceRequestId!,
            full_name: employmentTextController.employmentNameController.text,
            company_name:
                employmentTextController.employmentCompanyNameController.text,
            company_address: employmentTextController
                .employmentCompanyAddressController.text,
            company_city:
                employmentTextController.employmentCompanyCityController.text,
            company_state:
                employmentTextController.employmentCompanyStateController.text,
            company_country: employmentTextController
                .employmentCompanyCountryController.text,
            company_postal_code: employmentTextController
                .employmentCompanyPinCodeController.text,
            industry:
                employmentTextController.employmentIndustryController.text,
            job_title:
                employmentTextController.employmentJobTitleController.text,
            department:
                employmentTextController.employmentJobDepartmentController.text,
            employee_code_id:
                employmentTextController.employmentEmployeeCodeController.text,
            joining_date: employmentTextController
                .employmentCompanyJoiningDateController.text,
            exit_date: employmentTextController
                .employmentCompanyLeavingDateController.text,
            experience_years: employmentTextController
                .employmentExperienceYearController.text,
            experience_months: employmentTextController
                .employmentExperienceMonthsController.text,
            reason_for_leaving: leavingReasonValue.toString(),
            salary: employmentTextController
                .employmentEmployeeSalaryController.text,
            currency: employmentTextController
                .employmentEmployeeCurrencyController.text,
            salaryDrawn: employPayFrequency == null ? "" : employPayFrequency!,
            hr_contact_name:
                employmentTextController.employmentHrNameController.text,
            hr_contact_email:
                employmentTextController.employmentHrEmailController.text,
            hr_contact_phone:
                employmentTextController.employmentHrPhoneNoController.text,
            employment_certificate_number: employmentTextController
                .employmentEmploymentCertificateNumberController.text,
            //  employment_letter_doc: context.read<EmploymentLetterImage>().state,
            employment_supporting_doc:
                context.read<EmploymentSupportDocumentImage>().state,
            show_on_report: "1",
            // _character!.name == "yes" ? "1" : "0",
            joining_date_format: joinDateFormat.toString(),
            leaving_date_format: leavingDateFormat == "Till Date" ? "till_date" : leavingDateFormat.toString(),
            other_reason_for_leaving: employmentTextController.employmentCompanyLeavingReason.text));
  }

  final _formKey = GlobalKey<FormState>();

  var mobileMaskFormatter = MaskTextInputFormatter(
      mask: '##########', filter: {"#": RegExp(r'[0-9]')});
  showOnReport? _character = showOnReport.yes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormFieldNotRequired(
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    controller:
                        employmentTextController.employmentHrNameController,
                    titleText: "HR Name",
                    hintText: "Enter HR Name",
                    textInputType: TextInputType.text),
                FormFieldNotRequired(
                    maskFormatter: [mobileMaskFormatter],
                    // validator: validateMobile,
                    controller:
                        employmentTextController.employmentHrPhoneNoController,
                    titleText: "HR Phone Number",
                    hintText: "Enter HR Phone Number",
                    textInputType: TextInputType.number),
                FormFieldNotRequired(
                    // validator: validateEmail,
                    controller:
                        employmentTextController.employmentHrEmailController,
                    titleText: "HR Email",
                    hintText: "Enter Email Address",
                    textInputType: TextInputType.emailAddress),
                FormFieldNotRequired(
                    controller: employmentTextController
                        .employmentEmploymentCertificateNumberController,
                    titleText: "Employment Certificate Number",
                    hintText: "Enter Employment Certificate Number",
                    textInputType: TextInputType.number),
                const SizedBox(
                  height: 16,
                ),

                // BlocBuilder<EmploymentLetterImage, File>(
                //     builder: (BuildContext context, File letterImage) {
                //   return PickPhoto(
                //     widthSize: double.infinity,
                //     mainTitle: "Employment Letter",
                //     onPressedPickImage: () {
                //       context
                //           .read<EmploymentLetterImage>()
                //           .pickFile()
                //           .then((_) {
                //         context.pop();
                //       });
                //       ;
                //     },
                //     onPressedTakePhoto: () {
                //       context
                //           .read<EmploymentLetterImage>()
                //           .pickImageFromCamera()
                //           .then((_) {
                //         context.pop();
                //       });
                //       ;
                //     },
                //     title: 'Employment Letter',
                //     image: letterImage,
                //   );
                // }),
                // const SizedBox(
                //   height: 16,
                // ),
                BlocBuilder<EmploymentSupportDocumentImage, File>(
                    builder: (BuildContext context, File letterImage) {
                  return PickPhoto(
                    widthSize: double.infinity,
                    mainTitle: "Employment Support Document",
                    onPressedPickImage: () {
                      context
                          .read<EmploymentSupportDocumentImage>()
                          .pickFile()
                          .then((_) {
                        context.pop();
                      });
                    },
                    onPressedTakePhoto: () {
                      context
                          .read<EmploymentSupportDocumentImage>()
                          .pickImageFromCamera()
                          .then((_) {
                        context.pop();
                      });
                    },
                    title: 'Employment Support Document',
                    image: letterImage,
                  );
                }),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Note : Upload one combined PDF if you have multiple documents",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .color!
                          .withOpacity(0.5)),
                ),
                // const SizedBox(
                //   height: 16,
                // ),
                // Text(
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   "Show On Report?",
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodySmall!
                //       .copyWith(fontWeight: FontWeight.w700),
                // ),
                // Row(
                //   children: [
                //     SizedBox(
                //       width: 150,
                //       child: RadioListTile<showOnReport>(
                //         contentPadding: EdgeInsets.zero,
                //         title: const Text('Yes'),
                //         value: showOnReport.yes,
                //         groupValue: _character,
                //         onChanged: (showOnReport? value) {
                //           setState(() {
                //             _character = value;
                //             print(_character!.name);
                //           });
                //         },
                //       ),
                //     ),
                //     SizedBox(
                //       width: 150,
                //       child: RadioListTile<showOnReport>(
                //         contentPadding: EdgeInsets.zero,
                //         title: const Text('No'),
                //         value: showOnReport.no,
                //         groupValue: _character,
                //         onChanged: (showOnReport? value) {
                //           setState(() {
                //             _character = value;
                //           });
                //         },
                //       ),
                //     ),
                //   ],
                // ),
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
                    BlocConsumer<EmploymentSaveFormCubit,
                            EmploymentSaveFormState>(
                        listener: (context, employSave) {
                      if (employSave is EmploymentSaveFormSuccessState) {
                        if (employSave.data["status"] == 200) {
                          context.pushReplacementNamed("EmployDataList");

                          context.read<EmploymentLetterImage>().clearImage();
                          context
                              .read<EmploymentSupportDocumentImage>()
                              .clearImage();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(employSave.data["message"])));
                      } else if (employSave is EmploymentSaveFormErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(employSave.message)));
                      }
                    }, builder: (context, employSave) {
                      return Expanded(
                        child: CustomButton(
                            isLoading:
                                employSave is EmploymentSaveFormLoadingState,
                            height: 45,
                            onTap: () {
                              context.pushReplacementNamed("EmployDataList");
                              FocusManager.instance.primaryFocus?.unfocus();
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_formKey.currentState?.validate() ?? false) {
                                if (context
                                    .read<EmploymentSupportDocumentImage>()
                                    .state
                                    .path
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please upload all documents")));
                                } else {
                                  employmentSaveForm();
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Please fill fields")));
                              }
                            },
                            text: "SUBMIT",
                            gradientColors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColorDark,
                            ]),
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
