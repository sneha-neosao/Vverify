// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
// import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/TextController/Education_Text_controller.dart';
// import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
// import 'package:v_verify/screen/VerificationForms/common/validator.dart';
//
// import '../../../../commonComponent/custom_button.dart';
// import '../Names/Collage/Bloc/collage_name_cubit.dart';
// import '../Names/University/Bloc/university_name_bloc.dart';
// import 'ShowDetails/Bloc/education_show_details_cubit.dart';
// import 'ShowDetails/Bloc/education_show_details_state.dart';
// import 'ShowDetails/Model/education_show_details_model.dart';
// import 'education_save_form2_update.dart';
//
// class EducationSaveForm1Update extends StatefulWidget {
//   String uid;
//
//   EducationSaveForm1Update({super.key, required this.uid});
//
//   @override
//   State<EducationSaveForm1Update> createState() =>
//       _EducationSaveForm1UpdateState();
// }
//
// class _EducationSaveForm1UpdateState extends State<EducationSaveForm1Update> {
//   @override
//   void initState() {
//     educationControllerRecreate();
//     educationDetailsDataLoad();
//     universityNameLoad();
//     collageNameLoad();
//     super.initState();
//   }
//
//   final _formKey = GlobalKey<FormState>();
//
//   void educationDetailsDataLoad() {
//     String token = context.read<TokenCubit>().state;
//     context
//         .read<EducationShowDetailsCubit>()
//         .educationUpdateForm(token: token, uid: widget.uid);
//   }
//
//   void universityNameLoad() {
//     String token = context.read<TokenCubit>().state;
//     context.read<UniversityNameBloc>().universityList(token: token);
//   }
//
//   void collageNameLoad() {
//     String token = context.read<TokenCubit>().state;
//     context.read<CollageNameCubit>().collageNameList(token: token);
//   }
//
//   String? dropDownUniBordName;
//   String? dropDownCollageName;
//
//   @override
//   void dispose() {
//     // clearEducationController();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
//           child: Form(
//             key: _formKey,
//             child: BlocConsumer<EducationShowDetailsCubit,
//                 EducationShowDetailsState>
//               (listener: (context, educationData) {
//               if (educationData is EducationShowDetailsSuccessState) {
//                 EducationDataDetailsModel data =
//                     educationData.educationDataDetailsModel;
//                 educationTextController.educationUniversityController.text = data.data!.universityBoard;
//                 educationTextController.educationCollageController.text = data.data!.schoolCollege!;
//
//                 educationTextController.educationCertificateNumberController.text =
//                     data.data!.certificateNumber!;
//
//                 educationTextController.educationCourseDegreeNameController.text =
//                     data.data!.courseDegreeName!;
//
//                 educationTextController.educationYearOfAdmissionController.text =
//                     data.data!.yearOfAdmission.toString();
//
//                 educationTextController.educationYearOfPassingController.text =
//                     data.data!.yearOfPassing.toString();
//
//                 educationTextController.educationInstitutionAddressController.text =
//                     data.data!.institutionAddress ?? "";
//
//                 educationTextController.educationInstitutionStateController.text =
//                     data.data!.institutionState ?? "";
//
//                 educationTextController.educationInstitutionCityDistrictController.text =
//                     data.data!.institutionCity!;
//
//                 educationTextController.educationInstitutionPincodeController.text =
//                     data.data!.institutionPostalCode ?? "";
//                 educationTextController.GPACGPAGradePercentage.text =
//                     data.data!.obtainedGpaCgpaGradePercentage.toString();
//               }
//             }, builder: (context, educationData) {
//               if (educationData is EducationShowDetailsLoadingState) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (educationData is EducationShowDetailsErrorState) {
//                 return Center(
//                   child: Text(educationData.message),
//                 );
//               } else if (educationData is EducationShowDetailsSuccessState) {
//                 EducationDataDetailsModel detailsData =
//                     educationData.educationDataDetailsModel;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Education Verification",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium!
//                           .copyWith(color: Theme.of(context).primaryColorDark),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     Text(
//                       "Rejected Reason",
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge!
//                           .copyWith(color: Colors.red),
//                     ),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       detailsData.data!.reason!,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodySmall!
//                           .copyWith(color: Colors.red),
//                     ),
//
//                     form_widget(
//                         controller: educationTextController.educationUniversityController,
//                         titleText: "University/Board ",
//                         hintText: "Enter University",
//                         textInputType: TextInputType.text),
//
//                     form_widget(
//                         controller: educationTextController.educationCollageController,
//                         titleText: "Collage",
//                         hintText: "Enter Collage",
//                         textInputType: TextInputType.text),
//                     // const SizedBox(
//                     //   height: 16,
//                     // ),
//                     // Text(
//                     //   "University Board",
//                     //   style: Theme.of(context)
//                     //       .textTheme
//                     //       .bodySmall!
//                     //       .copyWith(fontWeight: FontWeight.w700),
//                     // ),
//                     // const SizedBox(
//                     //   height: 8,
//                     // ),
//                     // BlocBuilder<UniversityNameBloc, UniversityNameState>(
//                     //     builder: (context, universityName) {
//                     //   if (universityName is UniversityNameLoadingState) {
//                     //     return const Center(
//                     //       child: CircularProgressIndicator(),
//                     //     );
//                     //   } else if (universityName is UniversityNameErrorState) {
//                     //     return Center(
//                     //       child: Text(universityName.message),
//                     //     );
//                     //   } else if (universityName is UniversityNameSuccessState) {
//                     //     UniversityNameModel data =
//                     //         universityName.universityNameModel;
//                     //
//                     //     List<String> uniList = [];
//                     //     Map<String, dynamic> uniListName = {};
//                     //
//                     //     for (int i = 0; i < data.data!.length; i++) {
//                     //       uniList.add(data.data![i].uniBoardName!);
//                     //       uniListName["${data.data![i].id}"] =
//                     //           data.data![i].uniBoardName;
//                     //     }
//                     //
//                     //     return SizedBox(
//                     //       height: 50,
//                     //       child: InputDecorator(
//                     //         decoration: const InputDecoration(
//                     //             border: OutlineInputBorder(gapPadding: 0)),
//                     //         child: DropdownButtonHideUnderline(
//                     //           child: DropdownButton<String>(
//                     //             focusColor: Colors.white,
//                     //             dropdownColor: Theme.of(context).cardColor,
//                     //             hint: Text(
//                     //                 "${uniListName["${detailsData.data!.universityBoardId}"]}",
//                     //                 style:
//                     //                     Theme.of(context).textTheme.bodySmall),
//                     //             value: dropDownUniBordName,
//                     //             onChanged: (String? newValue) {
//                     //               setState(() {
//                     //                 int index = uniList.indexOf(newValue!);
//                     //
//                     //                 print(
//                     //                     "Selected Item: $newValue, Index: $index ${data.data![index].uniBoardName}");
//                     //
//                     //                 educationUniversityBoards =
//                     //                     data.data![index].id.toString();
//                     //
//                     //                 dropDownUniBordName = newValue;
//                     //               });
//                     //             },
//                     //             items: uniList.map<DropdownMenuItem<String>>(
//                     //                 (String value) {
//                     //               return DropdownMenuItem<String>(
//                     //                 value: value,
//                     //                 child: Text(
//                     //                   textAlign: TextAlign.center,
//                     //                   value,
//                     //                   style:
//                     //                       Theme.of(context).textTheme.bodySmall,
//                     //                 ),
//                     //               );
//                     //             }).toList(),
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     );
//                     //   }
//                     //   return const Center(
//                     //     child: Text("Error..."),
//                     //   );
//                     // }),
//                     // const SizedBox(
//                     //   height: 16,
//                     // ),
//                     // Text(
//                     //   "School Boards",
//                     //   style: Theme.of(context)
//                     //       .textTheme
//                     //       .bodySmall!
//                     //       .copyWith(fontWeight: FontWeight.w700),
//                     // ),
//                     // const SizedBox(
//                     //   height: 8,
//                     // ),
//                     // BlocBuilder<CollageNameCubit, CollageNameState>(
//                     //     builder: (context, collageName) {
//                     //   if (collageName is CollageNameLoadingState) {
//                     //     return const Center(
//                     //       child: CircularProgressIndicator(),
//                     //     );
//                     //   } else if (collageName is CollageNameErrorState) {
//                     //     return Center(
//                     //       child: Text(collageName.message),
//                     //     );
//                     //   } else if (collageName is CollageNameSuccessState) {
//                     //     CollageNameModel data = collageName.collageNameModel;
//                     //
//                     //     List<String> uniList = [];
//                     //     Map<String, dynamic> uniListName = {};
//                     //
//                     //     for (int i = 0; i < data.data!.length; i++) {
//                     //       uniList.add(data.data![i].schoolCollegeName!);
//                     //       uniListName.addAll({
//                     //         "${data.data![i].id!}":
//                     //             "${data.data![i].schoolCollegeName}"
//                     //       });
//                     //     }
//                     //     return SizedBox(
//                     //       height: 50,
//                     //       child: InputDecorator(
//                     //         decoration: const InputDecoration(
//                     //             border: OutlineInputBorder(gapPadding: 0)),
//                     //         child: DropdownButtonHideUnderline(
//                     //           child: DropdownButton<String>(
//                     //             focusColor: Colors.white,
//                     //             dropdownColor: Theme.of(context).cardColor,
//                     //             hint: Text(
//                     //                 "${uniListName["${detailsData.data!.collegeSchoolId}"]}",
//                     //                 style:
//                     //                     Theme.of(context).textTheme.bodySmall),
//                     //             value: dropDownCollageName,
//                     //             onChanged: (String? newValue) {
//                     //               setState(() {
//                     //                 int index = uniList.indexOf(newValue!);
//                     //                 print(uniListName);
//                     //
//                     //                 print(
//                     //                     "Selected Item: $newValue, Index: $index ${data.data![index].schoolCollegeName}");
//                     //
//                     //                 educationSchoolBoards =
//                     //                     data.data![index].id.toString();
//                     //                 dropDownCollageName = newValue;
//                     //               });
//                     //             },
//                     //             items: uniList.map<DropdownMenuItem<String>>(
//                     //                 (String value) {
//                     //               return DropdownMenuItem<String>(
//                     //                 value: value,
//                     //                 child: Text(
//                     //                   textAlign: TextAlign.center,
//                     //                   value,
//                     //                   style:
//                     //                       Theme.of(context).textTheme.bodySmall,
//                     //                 ),
//                     //               );
//                     //             }).toList(),
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     );
//                     //   }
//                     //   return const Center(
//                     //     child: Text("Error..."),
//                     //   );
//                     // }),
//                     // form_widget(
//                     //   controller: educationInsitutionTypeController,
//                     //   titleText: 'Institution Type',
//                     //   hintText: "Enter Institution Type",
//                     //   textInputType: TextInputType.text,
//                     // ),
//                     FormFieldNotRequired(
//                       validator: addressValidatorNotRequired,
//                       controller: educationTextController.educationInstitutionAddressController,
//                       titleText: 'Institution Address',
//                       hintText: "Enter Institution Address",
//                       textInputType: TextInputType.text,
//                     ),
//
//                     FormFieldNotRequired(
//                       controller: educationTextController.educationInstitutionStateController,
//                       titleText: 'Institution State',
//                       hintText: "Enter Institution State",
//                       textInputType: TextInputType.text,
//                     ),
//                     form_widget(
//                       controller: educationTextController.educationInstitutionCityDistrictController,
//                       titleText: 'Institution City/District',
//                       hintText: "Enter Institution City/District",
//                       textInputType: TextInputType.text,
//                     ),
//                     FormFieldNotRequired(
//                       maskFormatter: [pinMask],
//                       validator: validatePinCodeNotRequired,
//                       controller: educationTextController.educationInstitutionPincodeController,
//                       titleText: 'Institution Pin code',
//                       hintText: "Enter Institution Pin code",
//                       textInputType: TextInputType.text,
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CustomButton(
//                             height: 45,
//                             onTap: () {
//                               FocusManager.instance.primaryFocus?.unfocus();
//                             },
//                             text: "PREV",
//                             gradientColors: [
//                               Theme.of(context).primaryColor.withOpacity(0.5),
//                               Theme.of(context)
//                                   .primaryColorDark
//                                   .withOpacity(0.5),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 8,
//                         ),
//                         Expanded(
//                           child: CustomButton(
//                               height: 45,
//                               onTap: () {
//                                 FocusManager.instance.primaryFocus?.unfocus();
//                                 if (_formKey.currentState?.validate() ??
//                                     false) {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               EducationSaveForm2Update(
//                                                 uid: widget.uid,
//                                               )));
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content:
//                                               Text("Please Fill All Fields")));
//                                 }
//                               },
//                               text: "NEXT",
//                               gradientColors: [
//                                 Theme.of(context).primaryColor,
//                                 Theme.of(context).primaryColorDark,
//                               ]),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                   ],
//                 );
//               }
//               return const Center(
//                 child: Text("Error..."),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }
