// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:v_verify/screen/VerificationForms/EmploymentForm/Save/Form/employmentSaveForm3.dart';
// import 'package:v_verify/screen/VerificationForms/EmploymentForm/TextController/EmploymentSaveFormController.dart';
//
// import '../../../../../commonComponent/custom_button.dart';
// import '../../../common/form_widget.dart';
// import '../../../common/validator.dart';
//
// const List<String> joiningDateList = <String>['DD/MM/YYYY', 'MM/YYYY'];
// const List<String> leavingDateList = <String>[
//   'DD/MM/YYYY',
//   'MM/YYYY',
//   'Till Date'
// ];
//
// class EmploymentSaveForm2 extends StatefulWidget {
//   const EmploymentSaveForm2({super.key});
//
//   @override
//   State<EmploymentSaveForm2> createState() => _EmploymentSaveForm2State();
// }
//
// class _EmploymentSaveForm2State extends State<EmploymentSaveForm2> {
//   DateTime selectedJoiningDate = DateTime.now();
//   DateTime selectedLeavingDate = DateTime.now();
//
//   String calculateYear = "";
//   String calculateMonth = "";
//
//   final _formKey = GlobalKey<FormState>();
//
//   // Function to call the date picker
//   Future<void> _selectJoiningDate(BuildContext context, dateFormat) async {
//     final DateTime? picked = await showDatePicker(
//       //initialDatePickerMode: DatePickerMode.year,
//       context: context,
//       initialDate: selectedJoiningDate, // initial date
//       firstDate: DateTime(1900), // the earliest possible date
//       lastDate: DateTime(2101), // the latest possible date
//     );
//     if (picked != null && picked != selectedJoiningDate) {
//       String formattedDate = DateFormat('$dateFormat').format(picked);
//
//       setState(() {
//         selectedJoiningDate = picked;
//         employmentTextController.employmentCompanyJoiningDateController.text =
//             formattedDate;
//       });
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
//                             employmentTextController
//                                 .employmentCompanyJoiningDateController
//                                 .text = formattedDate;
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
//                             employmentTextController
//                                 .employmentCompanyLeavingDateController
//                                 .text = formattedDate;
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
//                             employmentTextController
//                                 .employmentExperienceYearController
//                                 .text = years.toString();
//                             employmentTextController
//                                 .employmentExperienceMonthsController
//                                 .text = months.toString();
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
//   // Function to call the date picker
//   Future<void> _selectLeavingDate(BuildContext context, dateFormat) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(), // initial date
//       firstDate: selectedJoiningDate, // the earliest possible date
//       lastDate: DateTime(2101), // the latest possible date
//       // Shows year view first
//     );
//     if (picked != null && picked != selectedLeavingDate) {
//       String formattedDate = DateFormat('$dateFormat').format(picked);
//       // String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
//
//       setState(() {
//         selectedLeavingDate = picked;
//         employmentTextController.employmentCompanyLeavingDateController.text =
//             formattedDate;
//
//         int years = selectedLeavingDate.year - selectedJoiningDate.year;
//         int months = selectedLeavingDate.month - selectedJoiningDate.month;
//
//         if (months < 0) {
//           years--;
//           months += 12;
//         }
//         employmentTextController.employmentExperienceYearController.text =
//             years.toString();
//         employmentTextController.employmentExperienceMonthsController.text =
//             months.toString();
//       });
//     }
//   }
//
//   var maskFormatter = MaskTextInputFormatter(
//       mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});
//
//   var maskFormatterMY =
//       MaskTextInputFormatter(mask: '##-####', filter: {"#": RegExp(r'[0-9]')});
//   final List<String> employStatus = [
//     'Active',
//     'Resigned',
//     'Terminated',
//     'Retired',
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
//   // String joiningDateValue = joiningDateList.first;
//   // String leavingDateValue = leavingDateList.first;
//
//   @override
//   void initState() {
//     super.initState();
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
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // RichText(
//                 //     text: TextSpan(
//                 //         text: "Employment Type",
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
//                 // DropdownButtonFormField<String>(
//                 //   validator: (value) {
//                 //     if (value == null || value.isEmpty) {
//                 //       return 'Please select employment type';
//                 //     }
//                 //     return null;
//                 //   },
//                 //   dropdownColor: Theme.of(context).cardColor,
//                 //   hint: Text('Employment Type',
//                 //       style: Theme.of(context).textTheme.bodySmall),
//                 //   value: employmentType,
//                 //   onChanged: (String? newValue) {
//                 //     setState(() {
//                 //       employmentType = newValue;
//                 //     });
//                 //   },
//                 //   items:
//                 //       employType.map<DropdownMenuItem<String>>((String value) {
//                 //     return DropdownMenuItem<String>(
//                 //       value: value,
//                 //       child: Text(
//                 //         textAlign: TextAlign.center,
//                 //         value,
//                 //         style: Theme.of(context).textTheme.bodySmall,
//                 //       ),
//                 //     );
//                 //   }).toList(),
//                 // ),
//                 FormFieldNotRequired(
//                     controller: employmentTextController
//                         .employmentEmployeeCodeController,
//                     titleText: "Employee Code",
//                     hintText: "Enter Employee Code",
//                     textInputType: TextInputType.text),
//                 const SizedBox(
//                   height: 16,
//                 ),
//
//                 RichText(
//                     text: TextSpan(
//                         text: "Select Date Format",
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
//                   height: 4,
//                 ),
//                 DropdownButtonFormField<String>(
//                   validator: (value) {
//                     if (value == null && value!.isEmpty) {
//                       return "Please Select joining date format";
//                     }
//                     return null;
//                   },
//                   dropdownColor: Theme.of(context).cardColor,
//                   value: joinDateFormat,
//                   hint: const Text("Select Date Format"),
//                   elevation: 16,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                   onChanged: (String? value) {
//                     // This is called when the user selects an item.
//                     setState(() {
//                       joinDateFormat = value;
//                       employmentTextController
//                           .employmentCompanyJoiningDateController
//                           .clear();
//                     });
//                   },
//                   items: joiningDateList
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                         value: value, child: Text(value));
//                   }).toList(),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 RichText(
//                     text: TextSpan(
//                         text: "Company Joining Date",
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
//                 TextFormField(
//                   readOnly: true,
//                   onTap: () {
//                     joinDateFormat == "MM/YYYY"
//                         ? _selectJoiningDateMY()
//                         : _selectJoiningDate(
//                             context,
//                             joinDateFormat == "MM/YYYY"
//                                 ? "MM-yyyy"
//                                 : joinDateFormat == "DD/MM/YYYY"
//                                     ? "dd-MM-yyyy"
//                                     : "");
//                   },
//                   enabled: joinDateFormat == null ? false : true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a date';
//                     }
//                     return null;
//                   },
//                   style: Theme.of(context).textTheme.bodySmall,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: joinDateFormat == "MM/YYYY"
//                       ? [maskFormatterMY]
//                       : [maskFormatter],
//                   controller: employmentTextController
//                       .employmentCompanyJoiningDateController,
//                   decoration: InputDecoration(
//                     hintText: joinDateFormat == "MM/YYYY"
//                         ? "MM-YYYY"
//                         : joinDateFormat == "DD/MM/YYYY"
//                             ? "DD-MM-YYYY"
//                             : "",
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.calendar_today),
//                       onPressed: () => joinDateFormat == "MM/YYYY"
//                           ? _selectJoiningDateMY()
//                           : _selectJoiningDate(
//                               context,
//                               joinDateFormat == "MM/YYYY"
//                                   ? "MM-yyyy"
//                                   : joinDateFormat == "DD/MM/YYYY"
//                                       ? "dd-MM-yyyy"
//                                       : ""), // Open date picker when icon is pressed
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 RichText(
//                     text: TextSpan(
//                         text: "Select Date Format",
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
//                   height: 4,
//                 ),
//                 DropdownButtonFormField<String>(
//                   dropdownColor: Theme.of(context).cardColor,
//                   value: leavingDateFormat,
//                   hint: const Text("Select Leaving Date Format"),
//                   elevation: 16,
//                   style: Theme.of(context).textTheme.bodyMedium,
//                   onChanged: (String? value) {
//                     // This is called when the user selects an item.
//                     setState(() {
//                       leavingDateFormat = value;
//                       employmentTextController
//                           .employmentCompanyLeavingDateController
//                           .clear();
//
//                       if (value == "Till Date") {
//                         setState(() {
//                           int years =
//                               DateTime.now().year - selectedJoiningDate.year;
//                           int months =
//                               DateTime.now().month - selectedJoiningDate.month;
//
//                           if (months < 0) {
//                             years--;
//                             months += 12;
//                           }
//                           employmentTextController
//                               .employmentExperienceYearController
//                               .text = years.toString();
//                           employmentTextController
//                               .employmentExperienceMonthsController
//                               .text = months.toString();
//                         });
//                       }
//                     });
//                   },
//                   items: leavingDateList
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                         value: value, child: Text(value));
//                   }).toList(),
//                 ),
//                 leavingDateFormat == "Till Date"
//                     ? const SizedBox()
//                     : const SizedBox(
//                         height: 16,
//                       ),
//                 leavingDateFormat == "Till Date"
//                     ? const SizedBox()
//                     : RichText(
//                         text: TextSpan(
//                             text: "Company Leaving Date",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall!
//                                 .copyWith(fontWeight: FontWeight.w700),
//                             children: [
//                             TextSpan(
//                               text: " * ",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodySmall!
//                                   .copyWith(
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.red),
//                             ),
//                           ])),
//                 leavingDateFormat == "Till Date"
//                     ? const SizedBox()
//                     : const SizedBox(
//                         height: 8,
//                       ),
//                 leavingDateFormat == "Till Date"
//                     ? const SizedBox()
//                     : TextFormField(
//                         readOnly: true,
//                         onTap: () {
//                           leavingDateFormat == "MM/YYYY"
//                               ? _selectLeavingDateMY()
//                               : _selectLeavingDate(
//                                   context,
//                                   leavingDateFormat == "MM/YYYY"
//                                       ? "MM-yyyy'"
//                                       : leavingDateFormat == "DD/MM/YYYY"
//                                           ? "dd-MM-yyyy"
//                                           : "",
//                                 );
//                         },
//                         enabled: leavingDateFormat == null ? false : true,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a date';
//                           }
//                           return null;
//                         },
//                         style: Theme.of(context).textTheme.bodySmall,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: leavingDateFormat == "MM/YYYY"
//                             ? [maskFormatterMY]
//                             : [maskFormatter],
//                         controller: employmentTextController
//                             .employmentCompanyLeavingDateController,
//                         decoration: InputDecoration(
//                           hintText: leavingDateFormat == "MM/YYYY"
//                               ? "MM-YYYY"
//                               : leavingDateFormat == "DD/MM/YYYY"
//                                   ? "DD-MM-YYYY"
//                                   : "",
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.calendar_today),
//                             onPressed: () => leavingDateFormat == "MM/YYYY"
//                                 ? _selectLeavingDateMY()
//                                 : _selectLeavingDate(
//                                     context,
//                                     leavingDateFormat == "MM/YYYY"
//                                         ? "MM-yyyy'"
//                                         : leavingDateFormat == "DD/MM/YYYY"
//                                             ? "dd-MM-yyyy"
//                                             : "",
//                                   ), // Open date picker when icon is pressed
//                           ),
//                         ),
//                       ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: form_widget(
//                           maskFormatter: [onlyYearMask],
//                           controller: employmentTextController
//                               .employmentExperienceYearController,
//                           titleText: "Experience In Years",
//                           hintText: "Years",
//                           textInputType: TextInputType.number),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     Expanded(
//                       child: form_widget(
//                           maskFormatter: [onlyMonthMask],
//                           controller: employmentTextController
//                               .employmentExperienceMonthsController,
//                           titleText: "Experience in Months",
//                           hintText: "Months",
//                           textInputType: TextInputType.number),
//                     ),
//                   ],
//                 ),
//                 // const SizedBox(
//                 //   height: 16,
//                 // ),
//                 // RichText(
//                 //     text: TextSpan(
//                 //         text: "Employment Status",
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
//                 // DropdownButtonFormField<String>(
//                 //   validator: (value) {
//                 //     if (value == null || value.isEmpty) {
//                 //       return 'Please select employment status';
//                 //     }
//                 //     return null;
//                 //   },
//                 //   dropdownColor: Theme.of(context).cardColor,
//                 //   hint: Text('Employment Status',
//                 //       style: Theme.of(context).textTheme.bodySmall),
//                 //   value: employmentStatus,
//                 //   onChanged: (String? newValue) {
//                 //     setState(() {
//                 //       employmentStatus = newValue;
//                 //     });
//                 //   },
//                 //   items: employStatus
//                 //       .map<DropdownMenuItem<String>>((String value) {
//                 //     return DropdownMenuItem<String>(
//                 //       value: value,
//                 //       child: Text(
//                 //         textAlign: TextAlign.center,
//                 //         value,
//                 //         style: Theme.of(context).textTheme.bodySmall,
//                 //       ),
//                 //     );
//                 //   }).toList(),
//                 // ),
//
//                 // const SizedBox(
//                 //   height: 16,
//                 // ),
//                 // RichText(
//                 //     text: TextSpan(
//                 //         text: "Employment Status",
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
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 RichText(
//                     text: TextSpan(
//                         text: "Reason For Leaving Previous Company",
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
//                     if (value == null || value.isEmpty) {
//                       return 'Please select Leaving Reason';
//                     }
//                     return null;
//                   },
//                   dropdownColor: Theme.of(context).cardColor,
//                   hint: Text('Leaving Reason',
//                       style: Theme.of(context).textTheme.bodySmall),
//                   value: leavingReasonValue,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       leavingReasonValue = newValue;
//
//                       employmentTextController.employmentCompanyLeavingReason
//                           .clear();
//                     });
//                   },
//                   items: leavingReason
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(
//                         textAlign: TextAlign.center,
//                         value,
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 leavingReasonValue == "Other"
//                     ? FormFieldNotRequired(
//                         controller: employmentTextController
//                             .employmentCompanyLeavingReason,
//                         titleText: "Other Reason For Leaving ",
//                         hintText: "Enter Leaving Reason",
//                         textInputType: TextInputType.text)
//                     : const SizedBox(),
//                 // FormFieldNotRequired(
//                 //     controller: employmentEmployeeCurrencyController,
//                 //     titleText: "Employee Currency",
//                 //     hintText: "Enter Employee Currency",
//                 //     textInputType: TextInputType.text),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 RichText(
//                     text: TextSpan(
//                         text: "Salary Drawn",
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodySmall!
//                             .copyWith(fontWeight: FontWeight.w700),
//                         children: [
//                       TextSpan(
//                         text: "  ",
//                         style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                             fontWeight: FontWeight.w700, color: Colors.red),
//                       ),
//                     ])),
//                 const SizedBox(
//                   height: 8,
//                 ),
//                 DropdownButtonFormField<String>(
//                   dropdownColor: Theme.of(context).cardColor,
//                   hint: Text('Select pay frequency',
//                       style: Theme.of(context).textTheme.bodySmall),
//                   value: employPayFrequency,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       employPayFrequency = newValue;
//                     });
//                   },
//                   items: payFrequency
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(
//                         textAlign: TextAlign.center,
//                         value,
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//                 FormFieldNotRequired(
//                     controller: employmentTextController
//                         .employmentEmployeeSalaryController,
//                     titleText: "Employee Salary",
//                     hintText: "Enter Salary",
//                     textInputType: TextInputType.number),
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
//                     Expanded(
//                       child: CustomButton(
//                           height: 45,
//                           onTap: () {
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             if (_formKey.currentState?.validate() ?? false) {
//                               //  context.pushNamed("EmploymentSaveForm3");
//
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const EmploymentSaveForm3()));
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text("Please fill all fields")));
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
