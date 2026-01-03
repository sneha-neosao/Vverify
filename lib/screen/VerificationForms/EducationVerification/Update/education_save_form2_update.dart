// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
// import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/TextController/Education_Text_controller.dart';
// import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
// import 'package:v_verify/screen/VerificationForms/common/id.dart';
// import 'package:v_verify/screen/VerificationForms/common/url.dart';
//
// import '../../../../commonComponent/custom_button.dart';
// import '../../EmploymentForm/Save/Form/employmentSaveForm3.dart';
// import '../../common/pickphoto.dart';
// import '../SaveForm/Bloc/education_save_form_bloc.dart';
// import 'Bloc/Education_update_form_cubit.dart';
// import 'Bloc/education_update_form_state.dart';
// import 'Model/education_update_form_model.dart';
// import 'ShowDetails/Bloc/education_show_details_cubit.dart';
// import 'ShowDetails/Bloc/education_show_details_state.dart';
// import 'ShowDetails/Model/education_show_details_model.dart';
//
// class EducationSaveForm2Update extends StatefulWidget {
//   String uid;
//
//   EducationSaveForm2Update({super.key, required this.uid});
//
//   @override
//   State<EducationSaveForm2Update> createState() =>
//       _EducationSaveForm2UpdateState();
// }
//
// class _EducationSaveForm2UpdateState extends State<EducationSaveForm2Update> {
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
//
//   var maskFormatter = MaskTextInputFormatter(
//       mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});
//
//   void educationSaveData(
//       {required String uniName, required String schoolName}) {
//     String token = context.read<TokenCubit>().state;
//     String customerId = context.read<IdCubit>().state;
//
//     context.read<EducationUpdateFormCubit>().educationUpdateForm(
//         customer_id: customerId,
//         token: token,
//         educationUpdateFormModel: EducationUpdateFormModel(
//           uid: widget.uid,
//           request_id: requestId!,
//           service_request_id: serviceRequestId!,
//           course_degree_name:
//               educationTextController.educationCourseDegreeNameController.text,
//           course_degree_type:
//               educationTextController.educationCourseDegreeTypeController.text,
//           institution_address: educationTextController
//               .educationInstitutionAddressController.text,
//           institution_city: educationTextController
//               .educationInstitutionCityDistrictController.text,
//           institution_state:
//               educationTextController.educationInstitutionStateController.text,
//           institution_postal_code: educationTextController
//               .educationInstitutionPincodeController.text,
//           year_of_passing:
//               educationTextController.educationYearOfPassingController.text,
//           certificate_number:
//               educationTextController.educationCertificateNumberController.text,
//           document: context.read<EducationCertificateDocuments>().state,
//           show_on_report: "1",
//           //_character!.name == "yes" ? "1" : "0",
//           obtained_gpa_cgpa_grade_percentage:
//               educationTextController.GPACGPAGradePercentage.text,
//           university_board:
//               educationTextController.educationUniversityController.text,
//           school_college:
//               educationTextController.educationCollageController.text,
//         ));
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   showOnReport? _character;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
//           child: BlocConsumer<EducationShowDetailsCubit,
//               EducationShowDetailsState>(listener: (context, educationData) {
//             if (educationData is EducationShowDetailsSuccessState) {
//               EducationDataDetailsModel data =
//                   educationData.educationDataDetailsModel;
//             }
//           }, builder: (context, educationData) {
//             if (educationData is EducationShowDetailsLoadingState) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (educationData is EducationShowDetailsErrorState) {
//               return Center(
//                 child: Text(educationData.message),
//               );
//             } else if (educationData is EducationShowDetailsSuccessState) {
//               EducationDataDetailsModel data =
//                   educationData.educationDataDetailsModel;
//               educationTextController.educationCourseDegreeNameController.text =
//                   data.data!.courseDegreeName!;
//
//               _character ??= data.data!.showOnReport == 1
//                   ? showOnReport.yes
//                   : showOnReport.no;
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   form_widget(
//                       titleDetails: " (with specialization)",
//                       controller: educationTextController
//                           .educationCourseDegreeNameController,
//                       titleText: "Course/Degree Name",
//                       hintText: "Enter Course/Degree Name",
//                       textInputType: TextInputType.text),
//                   form_widget(
//                       controller: educationTextController
//                           .educationCourseDegreeTypeController
//                         ..text = data.data!.courseDegreeType!,
//                       titleText: "Course/Degree Type",
//                       hintText: "Enter Course/Degree Type",
//                       textInputType: TextInputType.text),
//                   Row(
//                     children: [
//                       // Expanded(
//                       //   child: form_widget(
//                       //       controller: educationYearOfAdmissionController,
//                       //       titleText: "Year of Admission",
//                       //       hintText: "Enter Year",
//                       //       textInputType: TextInputType.number),
//                       // ),
//                       // const SizedBox(
//                       //   width: 8,
//                       // ),
//                       Expanded(
//                         child: form_widget(
//                             controller: educationTextController
//                                 .educationYearOfPassingController,
//                             titleText: "Year of Passing",
//                             hintText: "Enter Year",
//                             textInputType: TextInputType.number),
//                       ),
//                     ],
//                   ),
//
//                   form_widget(
//                       controller:
//                           educationTextController.GPACGPAGradePercentage,
//                       titleText: "Obtained GPA/CGPA/Grade/percentage",
//                       hintText: "Enter GPA/CGPA/Grade/percentage",
//                       textInputType: TextInputType.number),
//                   // Row(
//                   //   children: [
//                   //     Expanded(
//                   //       child: form_widget(
//                   //           controller: educationTotalMarksController
//                   //             ..text = data.data!.totalMarks.toString(),
//                   //           titleText: "Total Marks",
//                   //           hintText: "Enter Marks",
//                   //           textInputType: TextInputType.number),
//                   //     ),
//                   //     const SizedBox(
//                   //       width: 8,
//                   //     ),
//                   //     Expanded(
//                   //       child: form_widget(
//                   //           controller: educationObtainedMarksController
//                   //             ..text = data.data!.obtainedMark.toString(),
//                   //           titleText: "Obtained Marks",
//                   //           hintText: "Obtained Marks",
//                   //           textInputType: TextInputType.number),
//                   //     ),
//                   //   ],
//                   // ),
//                   // form_widget(
//                   //     controller: educationPercentageController,
//                   //     titleText: "Percentage",
//                   //     hintText: "Enter Percentage",
//                   //     textInputType: TextInputType.number),
//                   // Row(
//                   //   children: [
//                   //     Expanded(
//                   //       child: form_widget(
//                   //           controller: educationObtainedGPAController,
//                   //           titleText: "Obtained GPA",
//                   //           hintText: "Enter GPA",
//                   //           textInputType: TextInputType.number),
//                   //     ),
//                   //     const SizedBox(
//                   //       width: 8,
//                   //     ),
//                   //     Expanded(
//                   //       child: form_widget(
//                   //           controller: educationTotalGPAController,
//                   //           titleText: "Total GPA",
//                   //           hintText: "Enter Total GPA",
//                   //           textInputType: TextInputType.number),
//                   //     ),
//                   //   ],
//                   // ),
//                   form_widget(
//                       controller: educationTextController
//                           .educationCertificateNumberController,
//                       titleText: "Certificate Number",
//                       hintText: "Enter Certificate Number",
//                       textInputType: TextInputType.number),
//                   // const SizedBox(
//                   //   height: 16,
//                   // ),
//                   // Text(
//                   //   "Certificate Issued Date",
//                   //   style: Theme
//                   //       .of(context)
//                   //       .textTheme
//                   //       .bodySmall!
//                   //       .copyWith(fontWeight: FontWeight.w700),
//                   // ),
//                   // const SizedBox(
//                   //   height: 8,
//                   // ),
//                   // TextFormField(
//                   //   validator: validateDate,
//                   //   style: Theme
//                   //       .of(context)
//                   //       .textTheme
//                   //       .bodySmall,
//                   //   keyboardType: TextInputType.number,
//                   //   inputFormatters: [maskFormatter],
//                   //   controller: educationCertificateIssuedDateController,
//                   //   decoration: InputDecoration(
//                   //     hintText: "YYYY-MM-DD",
//                   //     suffixIcon: IconButton(
//                   //       icon: const Icon(Icons.calendar_today),
//                   //       onPressed: () =>
//                   //           _selectJoiningDate(
//                   //               context), // Open date picker when icon is pressed
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   BlocBuilder<EducationCertificateDocuments, File>(
//                       builder: (context, certificateDoc) {
//                     return PickPhotoUpdate(
//                       widthSize: double.infinity,
//                       mainTitle: "Certificate Document Upload",
//                       onPressedPickImage: () {
//                         context
//                             .read<EducationCertificateDocuments>()
//                             .pickFile()
//                             .then((_) {
//                           context.pop();
//                         });
//                       },
//                       onPressedTakePhoto: () {
//                         context
//                             .read<EducationCertificateDocuments>()
//                             .pickImageFromCamera()
//                             .then((_) {
//                           context.pop();
//                         });
//                       },
//                       title: 'Certificate Document Upload',
//                       image: certificateDoc,
//                       uploadImage: "$imageUrl/${data.data!.document!}",
//                     );
//                   }),
//                   Text(
//                     "Note : Upload one combined PDF if you have multiple documents",
//                     style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                         color: Theme.of(context)
//                             .textTheme
//                             .bodySmall!
//                             .color!
//                             .withOpacity(0.5)),
//                   ),
//                   // const SizedBox(
//                   //   height: 16,
//                   // ),
//                   // Text(
//                   //   maxLines: 1,
//                   //   overflow: TextOverflow.ellipsis,
//                   //   "Show On Report?",
//                   //   style: Theme.of(context)
//                   //       .textTheme
//                   //       .bodySmall!
//                   //       .copyWith(fontWeight: FontWeight.w700),
//                   // ),
//                   // const SizedBox(
//                   //   height: 4,
//                   // ),
//                   // Row(
//                   //   children: [
//                   //     SizedBox(
//                   //       width: 150,
//                   //       child: RadioListTile<showOnReport>(
//                   //         contentPadding: EdgeInsets.zero,
//                   //         title: const Text('Yes'),
//                   //         value: showOnReport.yes,
//                   //         groupValue: _character,
//                   //         onChanged: (showOnReport? value) {
//                   //           setState(() {
//                   //             _character = value;
//                   //             print(_character!.name);
//                   //           });
//                   //         },
//                   //       ),
//                   //     ),
//                   //     SizedBox(
//                   //       width: 150,
//                   //       child: RadioListTile<showOnReport>(
//                   //         contentPadding: EdgeInsets.zero,
//                   //         title: const Text('No'),
//                   //         value: showOnReport.no,
//                   //         groupValue: _character,
//                   //         onChanged: (showOnReport? value) {
//                   //           setState(() {
//                   //             _character = value;
//                   //           });
//                   //         },
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                   const SizedBox(
//                     height: 24,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomButton(
//                           height: 45,
//                           onTap: () {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             context.pop();
//                           },
//                           text: "PREV",
//                           gradientColors: [
//                             Theme.of(context).primaryColor,
//                             Theme.of(context).primaryColorDark,
//                           ],
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 8,
//                       ),
//                       BlocConsumer<EducationUpdateFormCubit,
//                               EducationUpdateFormState>(
//                           listener: (context, education) {
//                         if (education is EducationUpdateFormSuccessState) {
//                           if (education.data["status"] == 200) {
//                             context.pushReplacement("/EducationList");
//                             context
//                                 .read<EducationCertificateDocuments>()
//                                 .clearImage();
//                           }
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               content: Text(education.data["message"])));
//                         } else if (education is EducationUpdateFormErrorState) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text(education.message)));
//                         }
//                       }, builder: (context, educationUpdate) {
//                         return Expanded(
//                           child: CustomButton(
//                               isLoading: educationUpdate
//                                   is EducationUpdateFormLoadingState,
//                               height: 45,
//                               onTap: () {
//                                 FocusManager.instance.primaryFocus?.unfocus();
//                                 educationSaveData(
//                                     uniName:
//                                         data.data!.universityBoardId.toString(),
//                                     schoolName:
//                                         data.data!.collegeSchoolId.toString());
//                               },
//                               text: "Update",
//                               gradientColors: [
//                                 Theme.of(context).primaryColor,
//                                 Theme.of(context).primaryColorDark,
//                               ]),
//                         );
//                       }),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                 ],
//               );
//             }
//             return const Center(
//               child: Text("Error..."),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
