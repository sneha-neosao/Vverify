// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
// import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/Model/education_save_form_model.dart';
// import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/TextController/Education_Text_controller.dart';
// import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
// import 'package:v_verify/screen/VerificationForms/common/id.dart';
//
// import '../../../../commonComponent/custom_button.dart';
// import '../../EmploymentForm/Save/Form/employmentSaveForm3.dart';
// import '../../common/pickphoto.dart';
// import '../../common/validator.dart';
// import 'Bloc/education_save_form_bloc.dart';
// import 'Bloc/education_save_form_state.dart';
//
// const List<String> list = <String>['Regular', 'External', 'Online'];
//
// class EducationSaveForm2 extends StatefulWidget {
//   const EducationSaveForm2({super.key});
//
//   @override
//   State<EducationSaveForm2> createState() => _EducationSaveForm2State();
// }
//
// class _EducationSaveForm2State extends State<EducationSaveForm2> {
//   TextEditingController educationNameController = TextEditingController();
//
//   DateTime selectedJoiningDate = DateTime.now();
//
//   // Function to call the date picker
//   // Future<void> _selectJoiningDate(BuildContext context) async {
//   //   final DateTime? picked = await showDatePicker(
//   //     context: context,
//   //     initialDate: selectedJoiningDate, // initial date
//   //     firstDate: DateTime(1900), // the earliest possible date
//   //     lastDate: DateTime(2101), // the latest possible date
//   //   );
//   //   if (picked != null && picked != selectedJoiningDate) {
//   //     setState(() {
//   //       selectedJoiningDate = picked;
//   //       educationCertificateIssuedDateController.text =
//   //           "${selectedJoiningDate.toLocal()}".split(' ')[0];
//   //     });
//   //   }
//   // }
//   String dropdownValue = list.first;
//   var maskFormatter = MaskTextInputFormatter(
//       mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});
//
//   void educationSaveData() {
//     String token = context.read<TokenCubit>().state;
//     String customerId = context.read<IdCubit>().state;
//     context.read<EducationSaveFormCubit>().educationSaveForm(
//         customer_id: customerId,
//         token: token,
//         educationSaveFormModel: EducationSaveFormModel(
//             request_id: requestId!,
//             service_request_id: serviceRequestId!,
//             customer_id: educationTextController.educationUniversityController.text,
//             university_name: educationTextController.educationCollageController.text,
//             instituition_name: educationTextController.educationCourseDegreeNameController.text,
//             year_of_passing: dropdownValue,
//             degree_qualification_name: educationTextController.educationInstitutionAddressController.text,
//             grades_type: educationTextController.educationInstitutionCityDistrictController.text,
//             grades_obtained: educationTextController.educationInstitutionStateController.text,
//             institution_postal_code: educationTextController.educationInstitutionPincodeController.text,
//             certificate_number: educationTextController.educationCertificateNumberController.text,
//             document: context.read<EducationCertificateDocuments>().state,
//             show_on_report: "1",
//             //_character!.name == "yes" ? "1" : "0",
//             obtained_gpa_cgpa_grade_percentage: educationTextController.GPACGPAGradePercentage.text,
//             year_of_passing: educationTextController.educationYearOfPassingController.text));
//   }
//
//   final _formKey = GlobalKey<FormState>();
//   showOnReport? _character = showOnReport.yes;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 form_widget(
//                     titleDetails: " (with specialization)",
//                     controller: educationTextController.educationCourseDegreeNameController,
//                     titleText: "Course/Degree Name",
//                     hintText: "Enter Course/Degree Name",
//                     textInputType: TextInputType.text),
//                 // form_widget(
//                 //     titleDetails: "(Regular / External / Online)",
//                 //     controller: educationCourseDegreeTypeController,
//                 //     titleText: "Course/Degree Type",
//                 //     hintText: "Enter Course/Degree Type",
//                 //     textInputType: TextInputType.text),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 RichText(
//                     text: TextSpan(
//                         text: "Course/Degree Type",
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodySmall!
//                             .copyWith(fontWeight: FontWeight.w700),
//                         children: [
//                       TextSpan(
//                         text: " * ",
//                         style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                             fontWeight: FontWeight.w700, color: Colors.red),
//                       ),
//                     ])),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 DropdownButtonFormField<String>(
//                   validator: (value) {
//                     if (value == null) {
//                       return "Please select course type";
//                     }
//                     return null;
//                   },
//                   dropdownColor: Theme.of(context).cardColor,
//                   // value: dropdownValue,
//                   hint: const Text("Select Course Type"),
//                   elevation: 16,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                   onChanged: (String? value) {
//                     // This is called when the user selects an item.
//                     setState(() {
//                       dropdownValue = value!;
//                     });
//                   },
//                   items: list.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                         value: value, child: Text(value));
//                   }).toList(),
//                 ),
//
//                 form_widget(
//                     maskFormatter: [onlyYearMask],
//                     controller: educationTextController.educationYearOfPassingController,
//                     titleText: "Year Of Passing",
//                     hintText: "Enter Year",
//                     textInputType: TextInputType.number),
//
//                 form_widget(
//                     controller: educationTextController.GPACGPAGradePercentage,
//                     titleText: "Obtained GPA/CGPA/Grade/Percentage",
//                     hintText: "Enter GPA/CGPA/Grade/Percentage",
//                     textInputType: TextInputType.number),
//
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: FormFieldNotRequired(
//                 //           controller: educationTotalMarksController,
//                 //           titleText: "Obtained GPA/CGPA/Grade/percentage",
//                 //           hintText: "Enter Marks",
//                 //           textInputType: TextInputType.number),
//                 //     ),
//                 //     const SizedBox(
//                 //       width: 8,
//                 //     ),
//                 //     Expanded(
//                 //       child: FormFieldNotRequired(
//                 //           controller: educationObtainedMarksController,
//                 //           titleText: "Obtained Marks",
//                 //           hintText: "Obtained Marks",
//                 //           textInputType: TextInputType.number),
//                 //     ),
//                 //   ],
//                 // ),
//                 // FormFieldNotRequired(
//                 //     controller: educationPercentageController,
//                 //     titleText: "Percentage",
//                 //     hintText: "Enter Percentage",
//                 //     textInputType: TextInputType.number),
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       child: FormFieldNotRequired(
//                 //         controller: educationObtainedGPAController,
//                 //         titleText: 'Obtained GPA/CGPA',
//                 //         hintText: "Enter GPA",
//                 //         textInputType: TextInputType.number,
//                 //       ),
//                 //     ),
//                 //     const SizedBox(
//                 //       width: 8,
//                 //     ),
//                 //     Expanded(
//                 //       child: FormFieldNotRequired(
//                 //         controller: educationTotalGPAController,
//                 //         titleText: 'Total GPA/CGPA',
//                 //         hintText: "Enter Total GPA",
//                 //         textInputType: TextInputType.number,
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 form_widget(
//                     controller: educationTextController.educationCertificateNumberController,
//                     titleText: "Certificate Number",
//                     hintText: "Enter Certificate Number",
//                     textInputType: TextInputType.text),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 // RichText(
//                 //     text: TextSpan(
//                 //         text: "Certificate Issued Date",
//                 //         style: Theme.of(context)
//                 //             .textTheme
//                 //             .bodySmall!
//                 //             .copyWith(fontWeight: FontWeight.w700),
//                 //         children: [
//                 //       TextSpan(
//                 //         text: " * ",
//                 //         style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                 //             fontWeight: FontWeight.w700, color: Colors.red),
//                 //       ),
//                 //     ])),
//                 // const SizedBox(
//                 //   height: 8,
//                 // ),
//                 // TextFormField(
//                 //   validator: validateDate,
//                 //   style: Theme.of(context).textTheme.bodySmall,
//                 //   keyboardType: TextInputType.number,
//                 //   inputFormatters: [maskFormatter],
//                 //   controller: educationCertificateIssuedDateController,
//                 //   decoration: InputDecoration(
//                 //     hintText: "YYYY-MM-DD",
//                 //     suffixIcon: IconButton(
//                 //       icon: const Icon(Icons.calendar_today),
//                 //       onPressed: () => _selectJoiningDate(
//                 //           context), // Open date picker when icon is pressed
//                 //     ),
//                 //   ),
//                 // ),
//                 // const SizedBox(
//                 //   height: 16,
//                 // ),
//                 BlocBuilder<EducationCertificateDocuments, File>(
//                     builder: (context, certificateDoc) {
//                   return PickPhoto(
//                     widthSize: double.infinity,
//                     mainTitle: "Certificate Document Upload",
//                     onPressedPickImage: () {
//                       context
//                           .read<EducationCertificateDocuments>()
//                           .pickFile()
//                           .then((_) {
//                         context.pop();
//                       });
//                     },
//                     onPressedTakePhoto: () {
//                       context
//                           .read<EducationCertificateDocuments>()
//                           .pickImageFromCamera()
//                           .then((_) {
//                         context.pop();
//                       });
//                     },
//                     title: 'Certificate Document Upload',
//                     image: certificateDoc,
//                   );
//                 }),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 Text(
//                   "Note : Upload one combined PDF if you have multiple documents",
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                       color: Theme.of(context)
//                           .textTheme
//                           .bodySmall!
//                           .color!
//                           .withOpacity(0.5)),
//                 ),
//                 // const SizedBox(
//                 //   height: 16,
//                 // ),
//                 // Text(
//                 //   maxLines: 1,
//                 //   overflow: TextOverflow.ellipsis,
//                 //   "Show on report?",
//                 //   style: Theme.of(context)
//                 //       .textTheme
//                 //       .bodySmall!
//                 //       .copyWith(fontWeight: FontWeight.w700),
//                 // ),
//                 // const SizedBox(
//                 //   height: 4,
//                 // ),
//                 // Row(
//                 //   children: [
//                 //     SizedBox(
//                 //       width: 150,
//                 //       child: RadioListTile<showOnReport>(
//                 //         contentPadding: EdgeInsets.zero,
//                 //         title: const Text('Yes'),
//                 //         value: showOnReport.yes,
//                 //         groupValue: _character,
//                 //         onChanged: (showOnReport? value) {
//                 //           setState(() {
//                 //             _character = value;
//                 //             print(_character!.name);
//                 //           });
//                 //         },
//                 //       ),
//                 //     ),
//                 //     SizedBox(
//                 //       width: 150,
//                 //       child: RadioListTile<showOnReport>(
//                 //         contentPadding: EdgeInsets.zero,
//                 //         title: const Text('No'),
//                 //         value: showOnReport.no,
//                 //         groupValue: _character,
//                 //         onChanged: (showOnReport? value) {
//                 //           setState(() {
//                 //             _character = value;
//                 //           });
//                 //         },
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 const SizedBox(
//                   height: 24,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomButton(
//                         height: 45,
//                         onTap: () {
//                           FocusManager.instance.primaryFocus?.unfocus();
//                           context.pop();
//                         },
//                         text: "PREV",
//                         gradientColors: [
//                           Theme.of(context).primaryColor,
//                           Theme.of(context).primaryColorDark,
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 8,
//                     ),
//                     BlocConsumer<EducationSaveFormCubit,
//                         EducationSaveFormState>(listener: (context, education) {
//                       if (education is EducationSaveFormSuccessState) {
//                         if (education.data["status"] == 200) {
//                           educationUniversityBoards = null;
//                           educationSchoolBoards = null;
//                           context.pushReplacementNamed("EducationList");
//                           context
//                               .read<EducationCertificateDocuments>()
//                               .clearImage();
//                         }
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(education.data["message"])));
//                       } else if (education is EducationSaveFormErrorState) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(education.message)));
//                       }
//                     }, builder: (context, education) {
//                       return Expanded(
//                         child: CustomButton(
//                             isLoading:
//                                 education is EducationSaveFormLoadingState,
//                             height: 45,
//                             onTap: () {
//                               FocusManager.instance.primaryFocus?.unfocus();
//                               if (_formKey.currentState?.validate() ?? false) {
//                                 if (context
//                                     .read<EducationCertificateDocuments>()
//                                     .state
//                                     .path
//                                     .isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content: Text(
//                                               "Please Upload Certificate documents")));
//                                 } else {
//                                   educationSaveData();
//                                 }
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content:
//                                             Text("Please fill all fields")));
//                               }
//                             },
//                             text: "SUBMIT",
//                             gradientColors: [
//                               Theme.of(context).primaryColor,
//                               Theme.of(context).primaryColorDark,
//                             ]),
//                       );
//                     }),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
