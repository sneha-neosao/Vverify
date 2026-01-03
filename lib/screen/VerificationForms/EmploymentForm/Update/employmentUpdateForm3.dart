import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/TextController/EmploymentSaveFormController.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Model/employ_show_data_model.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/url.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../common/id.dart';
import '../../common/pickphoto.dart';
import '../Save/Bloc/EmploymentSaveForm.dart';
import '../Save/Form/employmentSaveForm3.dart';
import 'Bloc/employment_update_form.dart';
import 'Bloc/employment_update_form_state.dart';
import 'Model/employment_update_form_model.dart';

class EmploymentUpdateForm3 extends StatefulWidget {
  String uid;

  EmploymentUpdateForm3({super.key, required this.uid});

  @override
  State<EmploymentUpdateForm3> createState() => _EmploymentUpdateForm3State();
}

class _EmploymentUpdateForm3State extends State<EmploymentUpdateForm3> {
  void employmentUpdateForm({required String payFreq}) {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<EmploymentUpdateFormCubit>().employmentUpdateForm(
        token: token,
        customer_id: customerId,
        employmentUpdateFormModel: EmploymentUpdateFormModel(
            uid: widget.uid,
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
            salary: employmentTextController
                .employmentEmployeeSalaryController.text,
            reason_for_leaving: leavingReasonValue!,
            currency: employmentTextController
                .employmentEmployeeCurrencyController.text,
            hr_contact_name:
                employmentTextController.employmentHrNameController.text,
            hr_contact_email:
                employmentTextController.employmentHrEmailController.text,
            hr_contact_phone:
                employmentTextController.employmentHrPhoneNoController.text,
            employment_certificate_number: employmentTextController
                .employmentEmploymentCertificateNumberController.text,
            employment_supporting_doc:
                context.read<EmploymentSupportDocumentImage>().state,
            show_on_report: "1",
            //_character!.name == "yes" ? "1" : "0",
            joining_date_format: joinDateFormat.toString(),
            leaving_date_format: leavingDateFormat == "Till Date" ? "till_date" : leavingDateFormat.toString(),
            salaryDrawn: payFreq,
            other_reason_for_leaving: employmentTextController.employmentCompanyLeavingReason.text));
  }

  //final _formKey = GlobalKey<FormState>();
  showOnReport? _character;

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Scaffold(
      body: SingleChildScrollView(
        child: RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: BlocBuilder<EmployShowDataCubit, EmployShowDataState>(
                builder: (context, employData) {
              if (employData is EmployShowDataLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (employData is EmployShowDataErrorState) {
                return Center(
                  child: Text(employData.message),
                );
              } else if (employData is EmployShowDataSuccessState) {
                EmploymentShowDataModel data =
                    employData.employmentShowDataModel;

                _character ??= data.data!.showOnReport == 1
                    ? showOnReport.yes
                    : showOnReport.no;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormFieldNotRequired(
                        maskFormatter: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z]')),
                        ],
                        controller:
                            employmentTextController.employmentHrNameController,
                        titleText: "HR Name",
                        hintText: "Enter HR Name",
                        textInputType: TextInputType.text),
                    FormFieldNotRequired(
                        validator: validateMobile,
                        controller: employmentTextController
                            .employmentHrPhoneNoController,
                        titleText: "HR Phone No",
                        hintText: "Enter HR Phone No",
                        textInputType: TextInputType.number),
                    FormFieldNotRequired(
                        validator: validateEmail,
                        controller: employmentTextController
                            .employmentHrEmailController,
                        titleText: "HR Email",
                        hintText: "Enter HR Email",
                        textInputType: TextInputType.emailAddress),
                    form_widget(
                        controller: employmentTextController
                            .employmentEmploymentCertificateNumberController,
                        titleText: "Employment Certificate Number",
                        hintText: "Enter Employment Certificate Number",
                        textInputType: TextInputType.number),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<EmploymentSupportDocumentImage, File>(
                        builder: (BuildContext context, File letterImage) {
                      return PickPhotoUpdate(
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
                        uploadImage:
                            "$imageUrl/${data.data!.employmentSupportingDoc!}",
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
                    //             print(value);
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
                        BlocConsumer<EmploymentUpdateFormCubit,
                                EmploymentUpdateFormState>(
                            listener: (context, employUpdate) {
                          if (employUpdate
                              is EmploymentUpdateFormSuccessState) {
                            if (employUpdate.data["status"] == 200) {
                              context.pushReplacementNamed("EmployDataList");
                              context
                                  .read<EmploymentLetterImage>()
                                  .clearImage();
                              context
                                  .read<EmploymentSupportDocumentImage>()
                                  .clearImage();
                            }
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(employUpdate.data["message"])));
                          } else if (employUpdate
                              is EmploymentUpdateFormErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(employUpdate.message)));
                          }
                        }, builder: (context, employSave) {
                          return Expanded(
                            child: CustomButton(
                                isLoading: employSave
                                    is EmploymentUpdateFormLoadingState,
                                height: 45,
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  // if (_formKey.currentState?.validate() ??
                                  //     false) {
                                  employmentUpdateForm(
                                      payFreq: data.data!.salary_drawn ?? "");
                                  // } else {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //       const SnackBar(
                                  //           content: Text(
                                  //               "Please fill all fields")));
                                  // }
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
                );
              }
              return const Center(
                child: Text("Error..."),
              );
            }),
          ),
        ),
      ),
    );
  }
}
