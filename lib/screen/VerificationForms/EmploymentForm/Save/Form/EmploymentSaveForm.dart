import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Save/Form/EmploymentSaveForm2.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../TextController/EmploymentSaveFormController.dart';
import '../Bloc/EmploymentSaveForm.dart';

class EmploymentSaveForm extends StatefulWidget {
  const EmploymentSaveForm({super.key});

  @override
  State<EmploymentSaveForm> createState() => _EmploymentSaveFormState();
}

class _EmploymentSaveFormState extends State<EmploymentSaveForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    employmentControllerRecreate();
    super.initState();
  }

  @override
  void dispose() {
    employmentTextControllerDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employment Verification Form",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text("Choose an Option:",
                    style: Theme.of(context).textTheme.bodySmall),
                BlocProvider(
                  create: (_) => FormUploadEmploymentCubit(),
                  child: BlocBuilder<FormUploadEmploymentCubit, bool>(
                      builder: (context, frmUpload) {
                    return

                      Column(
                      children: [
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context
                                .read<FormUploadEmploymentCubit>()
                                .formUploadYesNo(yesNo: false);
                          },
                          contentPadding: const EdgeInsets.all(0),
                          leading: Icon(Icons.radio_button_checked,
                              color: !frmUpload
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).iconTheme.color),
                          title: Text("Fill the Form Manually",
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                        ListTile(
                          splashColor: Colors.transparent,
                          onTap: () {
                            context.pushReplacementNamed(
                                "EmploymentUploadDocument");

                            context
                                .read<FormUploadEmploymentCubit>()
                                .formUploadYesNo(yesNo: false);

                            context
                                .read<FormUploadEmploymentCubit>()
                                .formUploadYesNo(yesNo: true);
                          },
                          contentPadding: const EdgeInsets.all(0),
                          leading: Icon(
                            Icons.radio_button_checked,
                            color: frmUpload
                                ? Theme.of(context).primaryColorLight
                                : Theme.of(context).iconTheme.color,
                          ),
                          title: Text("Upload Documents",
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ],
                    );
                  }),
                ),
                Text(
                  "Employment Details",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 16),
                ),
                form_widget(
                    maskFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    controller: employmentTextController.employmentNameController,
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
                //     controller: employmentIndustryController,
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
                          Theme.of(context).primaryColorDark.withOpacity(0.5),
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
                            if (_formKey.currentState?.validate() ?? false) {
                              //context.pushNamed("EmploymentSaveForm2");
                              // context.push("/EmploymentSaveForm2");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EmploymentSaveForm2()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fill all fields")));
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
            ),
          ),
        ),
      ),
    );
  }
}
