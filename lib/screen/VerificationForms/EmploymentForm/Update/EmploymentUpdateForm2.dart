// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:v_verify/screen/VerificationForms/EmploymentForm/TextController/EmploymentSaveFormController.dart';
// import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_cubit.dart';
// import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Bloc/employ_show_data_state.dart';
// import 'package:v_verify/screen/VerificationForms/EmploymentForm/Update/showData/Model/employ_show_data_model.dart';
//
// import '../../../../../commonComponent/custom_button.dart';
// import '../../common/form_widget.dart';
// import '../Save/Form/EmploymentSaveForm2.dart';
// import 'employmentUpdateForm3.dart';
//
// class EmploymentUpdateForm2 extends StatefulWidget {
//   String uid;
//
//   EmploymentUpdateForm2({super.key, required this.uid});
//
//   @override
//   State<EmploymentUpdateForm2> createState() => _EmploymentUpdateForm2State();
// }
//
// class _EmploymentUpdateForm2State extends State<EmploymentUpdateForm2> {
//   DateTime selectedJoiningDate = DateTime.now();
//   DateTime selectedLeavingDate = DateTime.now();
//
//   final _formKey = GlobalKey<FormState>();
//
//   // Function to call the date picker
//   Future<void> _selectJoiningDate(BuildContext context, dateFormat) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedJoiningDate, // initial date
//       firstDate: DateTime(1900), // the earliest possible date
//       lastDate: DateTime(2101), // the latest possible date
//     );
//     if (picked != null && picked != selectedJoiningDate) {
//       String formattedDate = DateFormat('$dateFormat').format(picked);
//
//       //setState(() {
//         selectedJoiningDate = picked;
//       employmentTextController.employmentCompanyJoiningDateController.text = formattedDate;
//       //});
//     }
//   }
//
//   // Function to call the date picker
//   Future<void> _selectLeavingDate(BuildContext context, dateFormat) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedLeavingDate, // initial date
//       firstDate: selectedJoiningDate, // the earliest possible date
//       lastDate: DateTime(2101), // the latest possible date
//     );
//     if (picked != null && picked != selectedLeavingDate) {
//       String formattedDate = DateFormat('$dateFormat').format(picked);
//       // String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
//
//       setState(() {
//         selectedLeavingDate = picked;
//         employmentTextController.employmentCompanyLeavingDateController.text = formattedDate;
//
//         int years = selectedLeavingDate.year - selectedJoiningDate.year;
//         int months = selectedLeavingDate.month - selectedJoiningDate.month;
//
//         if (months < 0) {
//           years--;
//           months += 12;
//         }
//         employmentTextController.employmentExperienceYearController.text = years.toString();
//         employmentTextController.employmentExperienceMonthsController.text = months.toString();
//       });
//
//       // setState(() {
//       //   selectedLeavingDate = picked;
//       //   employmentCompanyLeavingDateController.text =
//       //       "${selectedLeavingDate.toLocal()}".split(' ')[0];
//       // });
//     }
//   }
//
//   void _selectJoiningDateMY() async {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => SizedBox(
//         height: 250,
//         child: Dialog(
//           backgroundColor: Theme.of(context).cardColor,
//           child: SizedBox(
//             width: 250,
//             height: 400,
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SfDateRangePicker(
//                     backgroundColor: Theme.of(context).cardColor,
//                     view: DateRangePickerView.year,
//                     allowViewNavigation: false,
//                     selectionMode: DateRangePickerSelectionMode.single,
//                     onSelectionChanged: (args) {
//                       if (args.value is DateTime) {
//                         setState(() {
//                           selectedJoiningDate = args.value;
//                         });
//                         print(selectedJoiningDate);
//                         print(
//                             'Selected Year: ${selectedJoiningDate.year}, Month: ${selectedJoiningDate.month}');
//                       }
//                     },
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           context.pop();
//                         },
//                         child: const Text("cancel")),
//                     TextButton(
//                         onPressed: () {
//                           setState(() {
//                             String formattedDate = DateFormat('MM-yyyy')
//                                 .format(selectedJoiningDate);
//
//                             employmentTextController.employmentCompanyJoiningDateController.text =
//                                 formattedDate;
//
//                             context.pop();
//                           });
//                         },
//                         child: const Text("Ok"))
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _selectLeavingDateMY() async {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => SizedBox(
//         height: 250,
//         child: Dialog(
//           backgroundColor: Theme.of(context).cardColor,
//           child: SizedBox(
//             width: 250,
//             height: 400,
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: SfDateRangePicker(
//                     selectionMode: DateRangePickerSelectionMode.single,
//                     minDate: selectedJoiningDate,
//                     view: DateRangePickerView.year,
//                     allowViewNavigation: false,
//                     // selectionMode: DateRangePickerSelectionMode.single,
//                     onSelectionChanged: (args) {
//                       if (args.value is DateTime) {
//                         setState(() {
//                           selectedLeavingDate = args.value;
//                         });
//                         print(selectedLeavingDate);
//                         print(
//                             'Selected Year: ${selectedLeavingDate.year}, Month: ${selectedLeavingDate.month}');
//                       }
//                     },
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           context.pop();
//                         },
//                         child: const Text("cancel")),
//                     TextButton(
//                         onPressed: () {
//                           setState(() {
//                             String formattedDate = DateFormat('MM-yyyy')
//                                 .format(selectedLeavingDate);
//
//                             employmentTextController.employmentCompanyJoiningDateController.text =
//                                 formattedDate;
//
//                             int years = selectedLeavingDate.year -
//                                 selectedJoiningDate.year;
//                             int months = selectedLeavingDate.month -
//                                 selectedJoiningDate.month;
//
//                             if (months < 0) {
//                               years--;
//                               months += 12;
//                             }
//                             employmentTextController.employmentExperienceYearController.text =
//                                 years.toString();
//                             employmentTextController.employmentExperienceMonthsController.text =
//                                 months.toString();
//
//                             context.pop();
//                           });
//                         },
//                         child: const Text("Ok"))
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   var maskFormatter = MaskTextInputFormatter(
//       mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});
//
//   var maskFormatterMY =
//       MaskTextInputFormatter(mask: '##-####', filter: {"#": RegExp(r'[0-9]')});
//
//   final List<String> employStatus = [
//     'Active',
//     'Resigned',
//     'Terminated',
//     'Retired',
//     'Other'
//   ];
//   final List<String> payFrequency = [
//     'Monthly',
//     'Annual',
//   ];
//   final List<String> employType = [
//     'Full-Time',
//     'Part-Time',
//     'Contract',
//     'Freelance',
//     'Other'
//   ];
//
//   final List<String> leavingReason = [
//     'Professional Growth',
//     'Career Change',
//     'Relocation or Personal Reasons',
//     'Company Issues',
//     'Seeking Better Fit',
//     'Other'
//   ];
//
//   // String joiningDateValue = joiningDateList.first;
//   // String leavingDateValue = leavingDateList.first;
//
//   @override
//   Widget build(BuildContext context) {
//     print("rebuild");
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
//           child: Form(
//             key: _formKey,
//             child: BlocBuilder<EmployShowDataCubit, EmployShowDataState>(
//                 builder: (context, employData) {
//               if (employData is EmployShowDataLoadingState) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (employData is EmployShowDataErrorState) {
//                 return Center(
//                   child: Text(employData.message),
//                 );
//               } else if (employData is EmployShowDataSuccessState) {
//                 EmploymentShowDataModel data =
//                     employData.employmentShowDataModel;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Text(
//                     //   "Employment Status",
//                     //   style: Theme.of(context)
//                     //       .textTheme
//                     //       .bodySmall!
//                     //       .copyWith(fontWeight: FontWeight.w700),
//                     // ),
//                     // const SizedBox(height: 8),
//                     // DropdownButtonFormField<String>(
//                     //   focusColor: Colors.white,
//                     //   dropdownColor: Theme.of(context).cardColor,
//                     //   hint: Text(data.data!.employmentType!,
//                     //       style: Theme.of(context).textTheme.bodySmall),
//                     //   value: employmentType,
//                     //   onChanged: (String? newValue) {
//                     //     setState(() {
//                     //       employmentType = newValue;
//                     //     });
//                     //   },
//                     //   items: employType
//                     //       .map<DropdownMenuItem<String>>((String value) {
//                     //     return DropdownMenuItem<String>(
//                     //       value: value,
//                     //       child: Text(
//                     //         textAlign: TextAlign.center,
//                     //         value,
//                     //         style: Theme.of(context).textTheme.bodySmall,
//                     //       ),
//                     //     );
//                     //   }).toList(),
//                     // ),
//                     FormFieldNotRequired(
//                         controller: employmentTextController.employmentEmployeeCodeController,
//                         titleText: "Employee Code",
//                         hintText: "Enter Employee Code",
//                         textInputType: TextInputType.text),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text: "Select Date Format",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(fontWeight: FontWeight.w700),
//                             children: [
//                           TextSpan(
//                             text: " * ",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.red),
//                           ),
//                         ])),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     DropdownButtonFormField<String>(
//                       dropdownColor: Theme.of(context).cardColor,
//                       value: joinDateFormat,
//                       hint: const Text("Please Select Format"),
//                       elevation: 16,
//                       style: Theme.of(context).textTheme.bodyMedium,
//                       onChanged: (String? value) {
//                         // This is called when the user selects an item.
//                         setState(() {
//                           joinDateFormat = value;
//                           employmentTextController.employmentCompanyJoiningDateController.clear();
//                         });
//                       },
//                       items: joiningDateList
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                             value: value, child: Text(value));
//                       }).toList(),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text: "Company Joining Date",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(fontWeight: FontWeight.w700),
//                             children: [
//                           TextSpan(
//                             text: " * ",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.red),
//                           ),
//                         ])),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     TextFormField(
//                       enabled: joinDateFormat == null ? false : true,
//                       readOnly: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a date';
//                         }
//                         return null;
//                       },
//                       style: Theme.of(context).textTheme.bodySmall,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: joinDateFormat == "MM/YYYY"
//                           ? [maskFormatterMY]
//                           : [maskFormatter],
//                       controller: employmentTextController.employmentCompanyJoiningDateController,
//                       decoration: InputDecoration(
//                         hintText: joinDateFormat == "MM/YYYY"
//                             ? "MM-YYYY"
//                             : joinDateFormat == "DD/MM/YYYY"
//                                 ? "DD-MM-YYYY"
//                                 : "",
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.calendar_today),
//                           onPressed: () => joinDateFormat == "MM/YYYY"
//                               ? _selectJoiningDateMY()
//                               : _selectJoiningDate(
//                                   context,
//                                   joinDateFormat == "MM/YYYY"
//                                       ? "MM-yyyy"
//                                       : joinDateFormat == "DD/MM/YYYY"
//                                           ? "dd-MM-yyyy"
//                                           : ""), // Open date picker when icon is pressed
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text: "Select Date Format",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(fontWeight: FontWeight.w700),
//                             children: [
//                           TextSpan(
//                             text: " * ",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.red),
//                           ),
//                         ])),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     DropdownButtonFormField<String>(
//                       dropdownColor: Theme.of(context).cardColor,
//                       value: leavingDateFormat,
//                       hint: const Text("select leaving date format"),
//                       elevation: 16,
//                       style: Theme.of(context).textTheme.bodyMedium,
//                       onChanged: (String? value) {
//                         // This is called when the user selects an item.
//                         setState(() {
//                           leavingDateFormat = value;
//                           employmentTextController.employmentCompanyLeavingDateController.clear();
//                         });
//                       },
//                       items: leavingDateList
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                             value: value, child: Text(value));
//                       }).toList(),
//                     ),
//                     leavingDateFormat == "Till Date"
//                         ? const SizedBox()
//                         : const SizedBox(
//                             height: 16,
//                           ),
//                     leavingDateFormat == "Till Date"
//                         ? const SizedBox()
//                         : RichText(
//                             text: TextSpan(
//                                 text: "Company Leaving Date",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodySmall!
//                                     .copyWith(fontWeight: FontWeight.w700),
//                                 children: [
//                                 TextSpan(
//                                   text: " * ",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodySmall!
//                                       .copyWith(
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.red),
//                                 ),
//                               ])),
//                     leavingDateFormat == "Till Date"
//                         ? const SizedBox()
//                         : const SizedBox(
//                             height: 8,
//                           ),
//                     leavingDateFormat == "Till Date"
//                         ? const SizedBox()
//                         : TextFormField(
//                             enabled: leavingDateFormat == null ? false : true,
//                             readOnly: true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a date';
//                               }
//                               return null;
//                             },
//                             style: Theme.of(context).textTheme.bodySmall,
//                             keyboardType: TextInputType.number,
//                             inputFormatters: leavingDateFormat == "MM/YYYY"
//                                 ? [maskFormatterMY]
//                                 : [maskFormatter],
//                             controller: employmentTextController.employmentCompanyLeavingDateController,
//                             decoration: InputDecoration(
//                               hintText: leavingDateFormat == "MM/YYYY"
//                                   ? "MM-YYYY"
//                                   : leavingDateFormat == "DD/MM/YYYY"
//                                       ? "DD-MM-YYYY"
//                                       : "",
//                               suffixIcon: IconButton(
//                                 icon: const Icon(Icons.calendar_today),
//                                 onPressed: () => leavingDateFormat == "MM/YYYY"
//                                     ? _selectLeavingDateMY()
//                                     : _selectLeavingDate(
//                                         context,
//                                         leavingDateFormat == "MM/YYYY"
//                                             ? "MM-yyyy'"
//                                             : leavingDateFormat == "DD/MM/YYYY"
//                                                 ? "dd-MM-yyyy"
//                                                 : "",
//                                       ), // Open date picker when icon is pressed
//                               ),
//                             ),
//                           ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: form_widget(
//                               controller: employmentTextController.employmentExperienceYearController,
//                               titleText: "Experience Years",
//                               hintText: "Years",
//                               textInputType: TextInputType.number),
//                         ),
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         Expanded(
//                           child: form_widget(
//                               controller: employmentTextController.employmentExperienceMonthsController,
//                               titleText: "Experience in Months",
//                               hintText: "Months",
//                               textInputType: TextInputType.number),
//                         ),
//                       ],
//                     ),
//                     // const SizedBox(
//                     //   height: 16,
//                     // ),
//                     // Text(
//                     //   "Employment Status",
//                     //   style: Theme.of(context)
//                     //       .textTheme
//                     //       .bodySmall!
//                     //       .copyWith(fontWeight: FontWeight.w700),
//                     // ),
//                     // const SizedBox(
//                     //   height: 8,
//                     // ),
//                     // DropdownButtonFormField<String>(
//                     //   focusColor: Colors.white,
//                     //   dropdownColor: Theme.of(context).cardColor,
//                     //   hint: Text(data.data!.employmentStatus!,
//                     //       style: Theme.of(context).textTheme.bodySmall),
//                     //   value: employmentStatus,
//                     //   onChanged: (String? newValue) {
//                     //     setState(() {
//                     //       employmentStatus = newValue;
//                     //     });
//                     //   },
//                     //   items: employStatus
//                     //       .map<DropdownMenuItem<String>>((String value) {
//                     //     return DropdownMenuItem<String>(
//                     //       value: value,
//                     //       child: Text(
//                     //         textAlign: TextAlign.center,
//                     //         value,
//                     //         style: Theme.of(context).textTheme.bodySmall,
//                     //       ),
//                     //     );
//                     //   }).toList(),
//                     // ),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     RichText(
//                         text: TextSpan(
//                             text: "Reason for Leaving Previous Company",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(fontWeight: FontWeight.w700),
//                             children: [
//                           TextSpan(
//                             text: " * ",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.red),
//                           ),
//                         ])),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     DropdownButtonFormField<String>(
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select Leaving Reason';
//                         }
//                         return null;
//                       },
//                       dropdownColor: Theme.of(context).cardColor,
//                       hint: Text('Leaving Reason',
//                           style: Theme.of(context).textTheme.bodySmall),
//                       value: leavingReasonValue,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           leavingReasonValue = newValue;
//                         });
//                       },
//                       items: leavingReason
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(
//                             textAlign: TextAlign.center,
//                             value,
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     leavingReasonValue == "Other"
//                         ? FormFieldNotRequired(
//                             controller: employmentTextController.employmentCompanyLeavingReason,
//                             titleText: "Other Reason For Leaving ",
//                             hintText: "Enter Leaving Reason",
//                             textInputType: TextInputType.text)
//                         : const SizedBox(),
//                     // form_widget(
//                     //     controller: employmentEmployeeCurrencyController
//                     //     !,
//                     //     titleText: "Employee Currency",
//                     //     hintText: "Enter Employee Currency",
//                     //     textInputType: TextInputType.number),
//                     const SizedBox(
//                       height: 16,
//                     ),
//                     Text(
//                       "Pay Frequency",
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodySmall!
//                           .copyWith(fontWeight: FontWeight.w700),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     DropdownButtonFormField<String>(
//                       focusColor: Colors.white,
//                       dropdownColor: Theme.of(context).cardColor,
//                       hint: Text(
//                           data.data!.salary_drawn == null
//                               ? "Select Pay Frequency "
//                               : data.data!.salary_drawn!,
//                           style: Theme.of(context).textTheme.bodySmall),
//                       value: employPayFrequency,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           employPayFrequency = newValue;
//                         });
//                       },
//                       items: payFrequency
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(
//                             textAlign: TextAlign.center,
//                             value,
//                             style: Theme.of(context).textTheme.bodySmall,
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     FormFieldNotRequired(
//                         controller: employmentTextController.employmentEmployeeSalaryController,
//                         titleText: "Employee Salary",
//                         hintText: "Enter Employee Salary",
//                         textInputType: TextInputType.number),
//                     const SizedBox(
//                       height: 16,
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
//                               context.pop();
//                             },
//                             text: "PREV",
//                             gradientColors: [
//                               Theme.of(context).primaryColor,
//                               Theme.of(context).primaryColorDark,
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
//                                 FocusManager.instance.primaryFocus?.unfocus();
//                                 if (_formKey.currentState?.validate() ??
//                                     false) {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               EmploymentUpdateForm3(
//                                                 uid: widget.uid,
//                                               )));
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content:
//                                               Text("Please fill all fields")));
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
