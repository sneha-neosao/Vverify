import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentForm/Save/Form/EmploymentSaveForm2.dart';
import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
import 'package:v_verify/screen/VerificationForms/common/validator.dart';

import '../../../../../commonComponent/custom_button.dart';
import '../../TextController/EmploymentSaveFormController.dart';
import '../Bloc/EmploymentSaveForm.dart';

class EmploymentSaveFormNew extends StatefulWidget {
  const EmploymentSaveFormNew({super.key});

  @override
  State<EmploymentSaveFormNew> createState() => _EmploymentSaveFormNewState();
}

class _EmploymentSaveFormNewState extends State<EmploymentSaveFormNew> {
  final _formKey = GlobalKey<FormState>();
  var maskFormatter = MaskTextInputFormatter(
      mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController joinDateController = TextEditingController();
  TextEditingController leaveDateController = TextEditingController();

  @override
  void initState() {
    employmentControllerRecreate();
    super.initState();
  }

  DateTime _selectedDate = DateTime.now();

  // Function to calculate the date 18 years ago
  // DateTime _getDate18YearsAgo() {
  //   DateTime today = DateTime.now();
  //   return DateTime(today.year - 18, today.month, today.day);
  // }

  // Function to show the date picker
  Future<void> _selectLeaveDate(BuildContext context) async {
    // DateTime date18YearsAgo = _getDate18YearsAgo();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Min date: 18 years ago
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      leaveDateController.text = formattedDate;
      // });
    }
  }

  // Function to show the date picker
  Future<void> _selectJoinDate(BuildContext context) async {
    // DateTime date18YearsAgo = _getDate18YearsAgo();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950), // Min date: 18 years ago
      lastDate: DateTime.now(), // Max date: today
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

      //setState(() {
      _selectedDate = pickedDate;
      joinDateController.text = formattedDate;
      // });
    }
  }

  @override
  void dispose() {
    employmentTextControllerDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                      titleText: "Employer Name",
                      hintText: "Enter Employer Name",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "From Date (Joining)",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter joining date';
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: joinDateController,
                    decoration: InputDecoration(
                      hintText: "DD-MM-YYYY",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectJoinDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
                  ),
                  // form_widget(
                  //     controller: employmentTextController.employmentCompanyNameController,
                  //     titleText: "From Date (Joining)",
                  //     hintText: "Select From Date",
                  //     textInputType: TextInputType.text),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "To Date (Leaving)",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w700),
                          )),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    readOnly: true,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter birth date';
                    //   }
                    //   return null;
                    // },
                    style: Theme.of(context).textTheme.bodySmall,
                    keyboardType: TextInputType.number,
                    inputFormatters: [maskFormatter],
                    controller: leaveDateController,
                    decoration: InputDecoration(
                      hintText: "DD-MM-YYYY",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectLeaveDate(
                            context), // Open date picker when icon is pressed
                      ),
                    ),
                  ),
                  // FormFieldNotRequired(
                  //     validator: addressValidatorNotRequired,
                  //     controller: employmentTextController.employmentCompanyAddressController,
                  //     titleText: "To Date (Leaving)",
                  //     hintText: "Enter Company Address",
                  //     textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: employmentTextController.employmentCompanyCountryController,
                      titleText: "Designation",
                      hintText: "Enter Designation",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: employmentTextController.employmentCompanyStateController,
                      titleText: "Department",
                      hintText: "Enter Department",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: employmentTextController.employmentCompanyCityController,
                      titleText: "Remuneration",
                      hintText: "Enter Remuneration",
                      textInputType: TextInputType.text),
                  FormFieldNotRequired(
                      controller: employmentTextController.employmentCompanyPinCodeController,
                      titleText: "Reporting Manager",
                      hintText: "Enter Reporting Manager",
                      textInputType: TextInputType.text),
                  form_widget(
                      controller: employmentTextController.employmentJobTitleController,
                      titleText: "Reason For Leaving",
                      hintText: "Enter Reason For Leaving",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                      height: 45,
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState?.validate() ?? false) {
                          //context.pushNamed("EmploymentSaveForm2");
                          // context.push("/EmploymentSaveForm2");
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //         const EmploymentSaveForm2()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields")));
                        }
                      },
                      text: "Submit",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark,
                      ]),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: CustomButton(
                  //         height: 45,
                  //         onTap: () {
                  //           FocusManager.instance.primaryFocus?.unfocus();
                  //         },
                  //         text: "PREV",
                  //         gradientColors: [
                  //           Theme.of(context).primaryColor.withOpacity(0.5),
                  //           Theme.of(context).primaryColorDark.withOpacity(0.5),
                  //         ],
                  //       ),c
                  //     ),
                  //     const SizedBox(
                  //       width: 8,
                  //     ),
                  //     Expanded(
                  //       child: CustomButton(
                  //           height: 45,
                  //           onTap: () {
                  //             FocusManager.instance.primaryFocus?.unfocus();
                  //             if (_formKey.currentState?.validate() ?? false) {
                  //               //context.pushNamed("EmploymentSaveForm2");
                  //               // context.push("/EmploymentSaveForm2");
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) =>
                  //                       const EmploymentSaveForm2()));
                  //             } else {
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                   const SnackBar(
                  //                       content: Text("Please fill all fields")));
                  //             }
                  //           },
                  //           text: "Submit",
                  //           gradientColors: [
                  //             Theme.of(context).primaryColor,
                  //             Theme.of(context).primaryColorDark,
                  //           ]),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
