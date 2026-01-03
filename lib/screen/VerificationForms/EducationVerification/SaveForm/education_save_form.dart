// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
// import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/TextController/Education_Text_controller.dart';
// import 'package:v_verify/screen/VerificationForms/EducationVerification/SaveForm/education_save_form2.dart';
// import 'package:v_verify/screen/VerificationForms/common/form_widget.dart';
// import 'package:v_verify/screen/VerificationForms/common/validator.dart';
//
// import '../../../../commonComponent/custom_button.dart';
// import '../Names/Collage/Bloc/collage_name_cubit.dart';
// import '../Names/University/Bloc/university_name_bloc.dart';
// import 'Bloc/education_save_form_bloc.dart';
// import 'Model/education_save_form_model.dart';
//
// class EducationSaveForm extends StatefulWidget {
//   const EducationSaveForm({super.key});
//
//   @override
//   State<EducationSaveForm> createState() => _EducationSaveFormState();
// }
//
// class _EducationSaveFormState extends State<EducationSaveForm> {
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     educationControllerRecreate();
//     universityNameLoad();
//     collageNameLoad();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     clearEducationController();
//     super.dispose();
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
//                 Text(
//                   "Education Verification",
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(color: Theme.of(context).primaryColorDark),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Text("Choose an Option:",
//                     style: Theme.of(context).textTheme.bodySmall),
//
//                 BlocProvider(
//                   create: (_) => FormUploadEducationtCubit(),
//                   child: BlocBuilder<FormUploadEducationtCubit, bool>(
//                       builder: (context, frmUpload) {
//                     return Column(
//                       children: [
//                         ListTile(
//                           splashColor: Colors.transparent,
//                           onTap: () {
//                             context
//                                 .read<FormUploadEducationtCubit>()
//                                 .formUploadYesNo(yesNo: false);
//                           },
//                           contentPadding: const EdgeInsets.all(0),
//                           leading: Icon(Icons.radio_button_checked,
//                               color: !frmUpload
//                                   ? Theme.of(context).primaryColorLight
//                                   : Theme.of(context).iconTheme.color),
//                           title: Text("Fill the Form Manually",
//                               style: Theme.of(context).textTheme.bodySmall),
//                         ),
//                         ListTile(
//                           splashColor: Colors.transparent,
//                           onTap: () {
//                             context.pushReplacementNamed("EducationDocUpload");
//                             context
//                                 .read<FormUploadEducationtCubit>()
//                                 .formUploadYesNo(yesNo: true);
//                           },
//                           contentPadding: const EdgeInsets.all(0),
//                           leading: Icon(
//                             Icons.radio_button_checked,
//                             color: frmUpload
//                                 ? Theme.of(context).primaryColorLight
//                                 : Theme.of(context).iconTheme.color,
//                           ),
//                           title: Text("Upload Documents",
//                               style: Theme.of(context).textTheme.bodySmall),
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//                 Text(
//                   "Educational Details",
//                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                       color: Theme.of(context).primaryColorDark, fontSize: 16),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Text(
//                   "Note : At least one of University/Board and School/College is required",
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodySmall!
//                       .copyWith(fontSize: 12, color: Colors.grey),
//                 ),
//                 form_widget(
//                     controller: educationTextController.educationUniversityController,
//                     titleText: "University/Board ",
//                     hintText: "Enter University/Board",
//                     textInputType: TextInputType.text),
//                 form_widget(
//                     controller: educationTextController.educationCollageController,
//                     titleText: "School/College",
//                     hintText: "Enter School/College",
//                     textInputType: TextInputType.text),
//                 // RichText(
//                 //     text: TextSpan(
//                 //         text: "Select University",
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
//                 // BlocBuilder<UniversityNameBloc, UniversityNameState>(
//                 //   builder: (context, universityName) {
//                 //     if (universityName is UniversityNameLoadingState) {
//                 //       return const Center(
//                 //           child: SizedBox(
//                 //         height: 50,
//                 //         width: double.infinity,
//                 //       ));
//                 //     } else if (universityName is UniversityNameErrorState) {
//                 //       return Center(
//                 //         child: Text(universityName.message),
//                 //       );
//                 //     } else if (universityName is UniversityNameSuccessState) {
//                 //       UniversityNameModel data =
//                 //           universityName.universityNameModel;
//                 //
//                 //       List<String> uniList = [];
//                 //
//                 //       for (int i = 0; i < data.data!.length; i++) {
//                 //         uniList.add(data.data![i].uniBoardName!);
//                 //       }
//                 //       return DropdownButtonFormField<String>(
//                 //         // validator: (value) {
//                 //         //   if (value == null && value!.isEmpty) {
//                 //         //     return "Please Select University Boards";
//                 //         //   }
//                 //         //   return null;
//                 //         // },
//                 //         dropdownColor: Theme.of(context).cardColor,
//                 //         hint: Text('Select University Boards',
//                 //             style: Theme.of(context).textTheme.bodySmall),
//                 //         value: dropDownUniBordName,
//                 //         onChanged: (String? newValue) {
//                 //           setState(() {
//                 //             int index = uniList.indexOf(newValue!);
//                 //
//                 //             print(
//                 //                 "Selected Item: $newValue, Index: $index ${data.data![index].uniBoardName}");
//                 //
//                 //             educationUniversityBoards =
//                 //                 data.data![index].id.toString();
//                 //
//                 //             dropDownUniBordName = newValue;
//                 //           });
//                 //         },
//                 //         items: uniList
//                 //             .map<DropdownMenuItem<String>>((String value) {
//                 //           return DropdownMenuItem<String>(
//                 //             value: value,
//                 //             child: Text(
//                 //               textAlign: TextAlign.center,
//                 //               value,
//                 //               style: Theme.of(context).textTheme.bodySmall,
//                 //             ),
//                 //           );
//                 //         }).toList(),
//                 //       );
//                 //     }
//                 //     return const Center(
//                 //       child: Text("Error..."),
//                 //     );
//                 //   },
//                 // ),
//                 // const SizedBox(
//                 //   height: 16,
//                 // ),
//                 // RichText(
//                 //     text: TextSpan(
//                 //         text: "School Boards",
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
//                 // BlocBuilder<CollageNameCubit, CollageNameState>(
//                 //     builder: (context, collageName) {
//                 //   if (collageName is CollageNameLoadingState) {
//                 //     return const Center(
//                 //         child: SizedBox(
//                 //       height: 50,
//                 //       width: double.infinity,
//                 //     ));
//                 //   } else if (collageName is CollageNameErrorState) {
//                 //     return const Center(
//                 //       child: Text("Error"),
//                 //     );
//                 //   } else if (collageName is CollageNameSuccessState) {
//                 //     CollageNameModel data = collageName.collageNameModel;
//                 //
//                 //     List<String> uniList = [];
//                 //
//                 //     for (int i = 0; i < data.data!.length; i++) {
//                 //       uniList.add(data.data![i].schoolCollegeName!);
//                 //     }
//                 //     return DropdownButtonFormField<String>(
//                 //         validator: (value) {
//                 //           if (value == null && value!.isEmpty) {
//                 //             return "Please Select School Boards";
//                 //           }
//                 //           return null;
//                 //         },
//                 //         dropdownColor: Theme.of(context).cardColor,
//                 //         hint: Text('Select School Boards',
//                 //             style: Theme.of(context).textTheme.bodySmall),
//                 //         value: dropDownCollageName,
//                 //         onTap: () {},
//                 //         onChanged: (String? newValue) {
//                 //           setState(() {
//                 //             int index = uniList.indexOf(newValue!);
//                 //
//                 //             print(
//                 //                 "Selected Item: $newValue, Index: $index ${data.data![index].schoolCollegeName}");
//                 //
//                 //             educationSchoolBoards =
//                 //                 data.data![index].id.toString();
//                 //             dropDownCollageName = newValue;
//                 //           });
//                 //         },
//                 //         items: uniList
//                 //             .map<DropdownMenuItem<String>>((String value) {
//                 //           return DropdownMenuItem<String>(
//                 //             value: value,
//                 //             child: Text(
//                 //               textAlign: TextAlign.center,
//                 //               value,
//                 //               style: Theme.of(context).textTheme.bodySmall,
//                 //             ),
//                 //           );
//                 //         }).toList());
//                 //   }
//                 //
//                 //   return const Center(
//                 //     child: Text("Error..."),
//                 //   );
//                 // }),
//                 // form_widget(
//                 //   titleDetails: " (Private or Government)",
//                 //   controller: educationInsitutionTypeController,
//                 //   titleText: 'Institution Type',
//                 //   hintText: "Enter Institution Type",
//                 //   textInputType: TextInputType.text,
//                 // ),
//                 FormFieldNotRequired(
//                   validator: addressValidatorNotRequired,
//                   controller: educationTextController.educationInstitutionAddressController,
//                   titleText: 'Institution Address',
//                   hintText: "Enter Institution Address",
//                   textInputType: TextInputType.text,
//                 ),
//
//                 FormFieldNotRequired(
//                   controller: educationTextController.educationInstitutionStateController,
//                   titleText: 'Institution State',
//                   hintText: "Enter Institution State",
//                   textInputType: TextInputType.text,
//                 ),
//                 form_widget(
//                   controller: educationTextController.educationInstitutionCityDistrictController,
//                   titleText: 'Institution City/District',
//                   hintText: "Enter Institution City/District",
//                   textInputType: TextInputType.text,
//                 ),
//                 FormFieldNotRequired(
//                   maskFormatter: [pinMask],
//                   validator: validatePinCodeNotRequired,
//                   controller: educationTextController.educationInstitutionPincodeController,
//                   titleText: 'Institution Pin Code',
//                   hintText: "Enter Institution Pin Code",
//                   textInputType: TextInputType.number,
//                 ),
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
//                         },
//                         text: "PREV",
//                         gradientColors: [
//                           Theme.of(context).primaryColor.withOpacity(0.5),
//                           Theme.of(context).primaryColorDark.withOpacity(0.5),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 8,
//                     ),
//                     Expanded(
//                       child: CustomButton(
//                           height: 45,
//                           onTap: () {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             if (_formKey.currentState?.validate() ?? false) {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const EducationSaveForm2()));
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text("Please Fill All Fields")));
//                             }
//                           },
//                           text: "NEXT",
//                           gradientColors: [
//                             Theme.of(context).primaryColor,
//                             Theme.of(context).primaryColorDark,
//                           ]),
//                     )
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
