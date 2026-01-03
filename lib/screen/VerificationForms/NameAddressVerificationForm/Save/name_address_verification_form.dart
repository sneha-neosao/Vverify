// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
// import 'package:v_verify/commonComponent/custom_button.dart';
// import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
//
// import '../../common/form_widget.dart';
// import '../../common/id.dart';
// import '../../common/validator.dart';
// import 'Bloc/name_address_verification_cubit.dart';
// import 'Bloc/name_address_verification_state.dart';
// import 'model/name_address_verification_model.dart';
//
// TextEditingController personNameController = TextEditingController();
//
// class NameAddressVerificationForm extends StatefulWidget {
//   const NameAddressVerificationForm({super.key});
//
//   @override
//   State<NameAddressVerificationForm> createState() =>
//       _NameAddressVerificationFormState();
// }
//
// class _NameAddressVerificationFormState
//     extends State<NameAddressVerificationForm> {
//   TextEditingController line1AddressController = TextEditingController();
//   TextEditingController line2AddressController = TextEditingController();
//   TextEditingController cityAddressController = TextEditingController();
//   TextEditingController pinCodeController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     line1AddressController.dispose();
//     line2AddressController.dispose();
//     cityAddressController.dispose();
//
//     super.dispose();
//   }
//
//   final _formKey = GlobalKey<FormState>();
//
//   void nameAddressFormSave() {
//     String token = context.read<TokenCubit>().state;
//     String customerId = context.read<IdCubit>().state;
//     context.read<NameAddressVerificationFormCubit>().nameAddressForm(
//         customer_id: customerId,
//         token: token,
//         nameAddressVerificationModel: NameAddressVerificationModel(
//             request_id: requestId!,
//             service_request_id: serviceRequestId!,
//             person_name: personNameController.text,
//             aadhaar_front_side: context
//                     .read<NameAddressAadhaarFrontSideCubit>()
//                     .state
//                     .path
//                     .isEmpty
//                 ? File("")
//                 : context.read<NameAddressAadhaarFrontSideCubit>().state,
//             aadhaar_back_side: context
//                     .read<NameAddressAadhaarBackSideCubit>()
//                     .state
//                     .path
//                     .isEmpty
//                 ? File("")
//                 : context.read<NameAddressAadhaarBackSideCubit>().state,
//             address_line_1: line1AddressController.text,
//             address_line_2: line2AddressController.text,
//             city_id: cityAddressController.text,
//             pinCode: pinCodeController.text));
//   }
//
//   void pickImageClear() {
//     context.read<NameAddressAadhaarFrontSideCubit>().clearImage();
//     context.read<NameAddressAadhaarBackSideCubit>().clearImage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Full Name & Address Verification",
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
//                 BlocProvider(
//                   create: (_) => FormUploadNameAddressCubit(),
//                   child: BlocBuilder<FormUploadNameAddressCubit, bool>(
//                       builder: (context, frmUpload) {
//                     return Column(
//                       children: [
//                         ListTile(
//                           splashColor: Colors.transparent,
//                           onTap: () {
//                             context
//                                 .read<FormUploadNameAddressCubit>()
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
//                             context
//                                 .pushReplacementNamed("NameAddressDocUpload");
//
//                             context
//                                 .read<FormUploadNameAddressCubit>()
//                                 .formUploadYesNo(yesNo: false);
//
//                             context
//                                 .read<FormUploadNameAddressCubit>()
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
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 Text(
//                   "Person's Details",
//                   style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                       color: Theme.of(context).primaryColorDark, fontSize: 16),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 form_widget(
//                     controller: personNameController,
//                     titleText: "Person's Full Name",
//                     hintText: "Enter Person's Name",
//                     textInputType: TextInputType.text),
//                 form_widget(
//                     controller: line1AddressController,
//                     titleText: "Person's Address Line 1",
//                     hintText: "Enter Line 1 Address",
//                     textInputType: TextInputType.text),
//                 FormFieldNotRequired(
//                     controller: line2AddressController,
//                     titleText: "Person's Address Line 2",
//                     hintText: "Enter Line 2 Address",
//                     textInputType: TextInputType.text),
//                 form_widget(
//                     controller: cityAddressController,
//                     titleText: "Person's Address City",
//                     hintText: "Enter City",
//                     textInputType: TextInputType.text),
//                 form_widget(
//                     validator: validatePinCode,
//                     maskFormatter: [pinMask],
//                     controller: pinCodeController,
//                     titleText: 'PIN Code',
//                     hintText: "Enter PIN Code",
//                     textInputType: TextInputType.number),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 BlocBuilder<NameAddressAadhaarFrontSideCubit, File>(
//                     builder: (context, aadhaarFront) {
//                   //  return SizedBox();
//                   return PickPhoto(
//                     starRemove: "remove",
//                     mainTitle: "Upload Document Proof Front Side",
//                     widthSize: double.infinity,
//                     onPressedPickImage: () {
//                       context
//                           .read<NameAddressAadhaarFrontSideCubit>()
//                           .pickFile()
//                           .then((_) {
//                         context.pop();
//                       });
//                     },
//                     onPressedTakePhoto: () {
//                       context
//                           .read<NameAddressAadhaarFrontSideCubit>()
//                           .pickImageFromCamera()
//                           .then((_) {
//                         context.pop();
//                       });
//                     },
//                     title: 'Document Front Side',
//                     image: aadhaarFront,
//                   );
//                 }),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 BlocBuilder<NameAddressAadhaarBackSideCubit, File>(
//                     builder: (context, aadhaarBack) {
//                   //return SizedBox();
//                   return PickPhoto(
//                     starRemove: "remove",
//                     mainTitle: "Upload Document Proof Back Side",
//                     widthSize: double.infinity,
//                     onPressedPickImage: () {
//                       context
//                           .read<NameAddressAadhaarBackSideCubit>()
//                           .pickFile()
//                           .then((_) {
//                         context.pop();
//                       });
//                     },
//                     onPressedTakePhoto: () {
//                       context
//                           .read<NameAddressAadhaarBackSideCubit>()
//                           .pickImageFromCamera()
//                           .then((_) {
//                         context.pop();
//                       });
//                     },
//                     title: 'Document Back Side',
//                     image: aadhaarBack,
//                   );
//                 }),
//                 const SizedBox(height: 24),
//                 BlocConsumer<NameAddressVerificationFormCubit,
//                         NameAddressVerificationState>(
//                     listener: (context, nameAddress) {
//                   if (nameAddress is NameAddressVerificationSuccessState) {
//                     if (nameAddress.data["status"] == 200) {
//                       context.pushReplacementNamed("bottomNav");
//                       pickImageClear();
//                       context
//                           .read<NameAddressAadhaarFrontSideCubit>()
//                           .clearImage();
//                       context
//                           .read<NameAddressAadhaarBackSideCubit>()
//                           .clearImage();
//                     }
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(nameAddress.data["message"])));
//                   } else if (nameAddress is NameAddressVerificationErrorState) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(nameAddress.message)));
//                   }
//                 }, builder: (context, nameAddress) {
//                   return CustomButton(
//                     isLoading:
//                         nameAddress is NameAddressVerificationLoadingState,
//                     onTap: () {
//                       if (_formKey.currentState?.validate() ?? false) {
//                         nameAddressFormSave();
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('Please Fill All Fields')));
//                       }
//                     },
//                     text: "SUBMIT",
//                     gradientColors: [
//                       Theme.of(context).primaryColor,
//                       Theme.of(context).primaryColorDark
//                     ],
//                   );
//                 }),
//                 const SizedBox(height: 16)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
