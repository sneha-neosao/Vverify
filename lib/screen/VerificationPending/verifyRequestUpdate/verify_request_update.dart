// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:v_verify/commonComponent/custom_button.dart';
// import 'package:v_verify/screen/VerificationForms/common/validator.dart';
//
// import '../../../commonComponent/bloc/shared_preferences_cubit.dart';
// import '../../VerificationForms/common/form_widget.dart';
// import 'Bloc/verify_request_update_cubit.dart';
// import 'Bloc/verify_request_update_state.dart';
//
// class VerifyRequestUpdate extends StatefulWidget {
//   String uuid;
//
//   VerifyRequestUpdate({super.key, required this.uuid});
//
//   @override
//   State<VerifyRequestUpdate> createState() => _VerifyRequestUpdateState();
// }
//
// class _VerifyRequestUpdateState extends State<VerifyRequestUpdate> {
//   TextEditingController firstnameController = TextEditingController();
//   TextEditingController middleNameController = TextEditingController();
//   TextEditingController lastnameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController dobController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     firstnameController.dispose();
//     middleNameController.dispose();
//     lastnameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     dobController.dispose();
//     super.dispose();
//   }
//
//   void verifyUpdateData() {
//     final String token = context.read<TokenCubit>().state;
//     context.read<VerifyRequestUpdateCubit>().verifyRequestUpdate(
//           token: token,
//           uuid: widget.uuid,
//           phone: phoneController.text.trim(),
//           dob: dobController.text,
//           firstName: firstnameController.text,
//           middleName: middleNameController.text,
//           lastName: lastnameController.text,
//         );
//   }
//
//   final _formkey = GlobalKey<FormState>();
//
//   var maskFormatter = MaskTextInputFormatter(
//       mask: '##-##-####', filter: {"#": RegExp(r'[0-9]')});
//
//   var mobileMaskFormatter = MaskTextInputFormatter(
//       mask: '##########', filter: {"#": RegExp(r'[0-9]')});
//
//   DateTime _selectedDate = DateTime.now();
//
//   // Function to calculate the date 18 years ago
//   DateTime _getDate18YearsAgo() {
//     DateTime today = DateTime.now();
//     return DateTime(today.year - 18, today.month, today.day);
//   }
//
//   // Function to show the date picker
//   Future<void> _selectDate(BuildContext context) async {
//     DateTime date18YearsAgo = _getDate18YearsAgo();
//
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: date18YearsAgo,
//       firstDate: DateTime(1950), // Min date: 18 years ago
//       lastDate: date18YearsAgo, // Max date: today
//     );
//
//     if (pickedDate != null && pickedDate != _selectedDate) {
//       String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
//
//       //setState(() {
//         _selectedDate = pickedDate;
//         dobController.text = formattedDate;
//      // });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Padding(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
//       child: SingleChildScrollView(
//         child: Form(
//           key: _formkey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Fill User/Tenant Info",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium!
//                     .copyWith(color: Theme.of(context).primaryColorDark),
//               ),
//               form_widget(
//                 maskFormatter: [
//                   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
//                 ],
//                 textInputType: TextInputType.text,
//                 controller: firstnameController,
//                 titleText: 'First Name',
//                 hintText: "Enter First Name",
//               ),
//               FormFieldNotRequired(
//                 maskFormatter: [
//                   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
//                 ],
//                 textInputType: TextInputType.text,
//                 controller: middleNameController,
//                 titleText: 'Middle Name',
//                 hintText: "Enter Middle Name",
//               ),
//               form_widget(
//                 maskFormatter: [
//                   FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
//                 ],
//                 textInputType: TextInputType.text,
//                 controller: lastnameController,
//                 titleText: 'Last Name',
//                 hintText: "Enter Last Name",
//               ),
//               FormFieldNotRequired(
//                 maskFormatter: [mobileMaskFormatter],
//                 validator: validateMobileNotRequired,
//                 textInputType: TextInputType.number,
//                 controller: phoneController,
//                 titleText: 'Mobile Number',
//                 hintText: "Enter Mobile Number",
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               RichText(
//                   text: TextSpan(
//                       text: "Date of Birth",
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodySmall!
//                           .copyWith(fontWeight: FontWeight.w700),
//                       children: [
//                     TextSpan(
//                       text: " * ",
//                       style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                           fontWeight: FontWeight.w700, color: Colors.red),
//                     ),
//                   ])),
//               const SizedBox(
//                 height: 8,
//               ),
//               TextFormField(
//                 readOnly: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter birth date';
//                   }
//                   return null;
//                 },
//                 style: Theme.of(context).textTheme.bodySmall,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [maskFormatter],
//                 controller: dobController,
//                 decoration: InputDecoration(
//                   hintText: "DD-MM-YYYY",
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.calendar_today),
//                     onPressed: () => _selectDate(
//                         context), // Open date picker when icon is pressed
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               BlocConsumer<VerifyRequestUpdateCubit, VerifyRequestUpdateState>(
//                   listener: (context, verifyUpdate) {
//                 if (verifyUpdate is VerifyRequestUpdateSuccessState) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(verifyUpdate.data["message"])));
//                   if (verifyUpdate.data["status"] == 200) {
//                     context.pushReplacementNamed("bottomNav");
//                   }
//                 } else if (verifyUpdate is VerifyRequestUpdateErrorState) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(verifyUpdate.message)));
//                 }
//               }, builder: (context, verifyUpdate) {
//                 return CustomButton(
//                   isLoading: verifyUpdate is VerifyRequestUpdateLoadingState,
//                   onTap: () {
//                     if (_formkey.currentState?.validate() ?? false) {
//                       verifyUpdateData();
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                           content: Text("Please fill all fields")));
//                     }
//                   },
//                   text: "SAVE",
//                   gradientColors: [
//                     Theme.of(context).primaryColor,
//                     Theme.of(context).primaryColorDark,
//                   ],
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     ));
//   }
// }
