import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Model/employ_show_data_model.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../TextController/EmploymentSaveFormController.dart';
import 'EmploymentUpdateForm2.dart';

class EmploymentUpdateForm1 extends StatefulWidget {
  String uid;

  EmploymentUpdateForm1({super.key, required this.uid});

  @override
  State<EmploymentUpdateForm1> createState() => _EmploymentUpdateForm1State();
}

class _EmploymentUpdateForm1State extends State<EmploymentUpdateForm1> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    employShowData();
    employmentControllerRecreate();
    super.initState();
  }

  void employShowData() {
    String token = context.read<TokenCubit>().state;
    context
        .read<EmployShowDataCubit>()
        .employShowData(token: token, uid: widget.uid);
  }

  @override
  void dispose() {
    employmentTextControllerDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: BlocConsumer<EmployShowDataCubit, EmployShowDataState>(
              listener: (context, employData) {
                if (employData is EmployShowDataSuccessState) {
                  EmploymentShowDataModel data =
                      employData.employmentShowDataModel;

                  employmentTextController.employmentNameController/*.text = data.data!.fullName!*/;

                  employmentTextController.employmentCompanyNameController.text =
                      data.data!.companyName!;

                  employmentTextController.employmentCompanyAddressController.text =
                      data.data!.companyAddress ?? "";

                  employmentTextController.employmentCompanyCountryController.text =
                      data.data!.companyCountry ?? "";

                  employmentTextController.employmentCompanyStateController.text =
                      data.data!.companyState ?? "";

                  employmentTextController.employmentEmployeeCodeController.text =
                      data.data!.employeeCodeId ?? "";
                  employmentTextController.employmentCompanyCityController.text =
                      data.data!.companyCity ?? "";

                  employmentTextController.employmentCompanyJoiningDateController.text =
                      data.data!.joiningDate!;
                  employmentTextController.employmentCompanyLeavingDateController.text =
                      data.data!.exitDate ?? "";

                  employmentTextController.employmentCompanyPinCodeController.text =
                      data.data!.companyPostalCode ?? "";

                  employmentTextController.employmentIndustryController.text = data.data!.industry ?? "";

                  employmentTextController.employmentJobTitleController.text = data.data!.jobTitle!;

                  employmentTextController.employmentJobDepartmentController.text =
                      data.data!.department ?? "";

                  employmentTextController.employmentExperienceYearController.text =
                      data.data!.experienceYears.toString();

                  employmentTextController.employmentExperienceMonthsController.text =
                      data.data!.experienceMonths.toString();

                  employmentTextController.employmentCompanyLeavingReason.text =
                      data.data!.other_reason_for_leaving ?? "";

                  employmentTextController.employmentEmployeeCurrencyController.text =
                      data.data!.currency ?? "";

                  employmentTextController.employmentEmployeeSalaryController.text =
                      data.data!.amount ?? "";

                  employmentTextController.employmentHrNameController.text =
                      data.data!.hrContactName ?? "";

                  employmentTextController.employmentHrPhoneNoController.text =
                      data.data!.hrContactPhone ?? "";

                  employmentTextController.employmentHrEmailController.text =
                      data.data!.hrContactEmail ?? "";

                  employmentTextController.employmentEmploymentCertificateNumberController.text =
                      data.data!.employmentCertificateNumber ?? "";
                  leavingReasonValue = data.data!.reasonForLeaving;

                  //leavingDateFormat = data.data!.leaving_date_format;
                  // joinDateFormat = data.data!.joining_date_format;
                }
              },
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Employment Verification Form Update",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColorDark),
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
                      form_widget(
                          maskFormatter: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z]')),
                          ],
                          controller: employmentTextController.employmentNameController
                            ..text = data.data!.fullName!,
                          titleText: "Full Name",
                          hintText: "Enter Full Name",
                          textInputType: TextInputType.text),
                      form_widget(
                          controller: employmentTextController.employmentCompanyNameController,
                          titleText: "Company Name",
                          hintText: "Enter Company Name",
                          textInputType: TextInputType.text),
                      FormFieldNotRequired(
                          validator: addressValidatorNotRequired,
                          controller: employmentTextController.employmentCompanyAddressController,
                          titleText: "Company Address",
                          hintText: "Enter Company Address",
                          textInputType: TextInputType.text),
                      FormFieldNotRequired(
                          controller: employmentTextController.employmentCompanyCountryController,
                          titleText: "Company Country",
                          hintText: "Enter Company Country",
                          textInputType: TextInputType.text),
                      FormFieldNotRequired(
                          controller: employmentTextController.employmentCompanyStateController,
                          titleText: "Company State",
                          hintText: "Enter Company State",
                          textInputType: TextInputType.text),
                      FormFieldNotRequired(
                          controller: employmentTextController.employmentCompanyCityController,
                          titleText: "Company City",
                          hintText: "Enter Company City",
                          textInputType: TextInputType.text),
                      FormFieldNotRequired(
                          maskFormatter: [pinMask],
                          validator: validatePinCodeNotRequired,
                          controller: employmentTextController.employmentCompanyPinCodeController,
                          titleText: "Company Pin Code",
                          hintText: "Enter Company Pin Code",
                          textInputType: TextInputType.number),
                      // form_widget(
                      //     controller: employmentIndustryController
                      //       ..text = data.data!.industry!,
                      //     titleText: "Industry Type",
                      //     hintText: "Enter Industry Type",
                      //     textInputType: TextInputType.text),
                      form_widget(
                          controller: employmentTextController.employmentJobTitleController,
                          titleText: "Job Title/Designation",
                          hintText: "Enter Job Title/Designation",
                          textInputType: TextInputType.text),
                      FormFieldNotRequired(
                          controller: employmentTextController.employmentJobDepartmentController,
                          titleText: "Job Department",
                          hintText: "Enter Job Department",
                          textInputType: TextInputType.text),
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
                                                EmploymentUpdateForm2(
                                                  uid: widget.uid,
                                                )));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please fill all fields")));
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
              },
            ),
          ),
        ),
      ),
    );
  }
}
