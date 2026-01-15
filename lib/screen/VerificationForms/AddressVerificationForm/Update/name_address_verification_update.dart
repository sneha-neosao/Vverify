// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
// import 'package:v_verify/commonComponent/custom_button.dart';
// import 'package:v_verify/screen/VerificationForms/NameAddressVerificationForm/Update/model/name_address_verification_model.dart';
// import 'package:v_verify/screen/VerificationForms/common/id.dart';
// import 'package:v_verify/screen/VerificationForms/common/pickphoto.dart';
// import 'package:v_verify/screen/VerificationForms/common/validator.dart';
//
// import '../../common/form_widget.dart';
// import '../Save/Bloc/name_address_verification_cubit.dart';
// import 'Bloc/name_address_verification_cubit.dart';
// import 'Bloc/name_address_verification_state.dart';
// import 'ShowData/Bloc/nameAddress_showData_cubit.dart';
// import 'ShowData/Bloc/nameAddress_showData_state.dart';
// import 'ShowData/Model/nameAddress_showData_mdoel.dart';
//
// class NameAddressVerificationUpdate extends StatefulWidget {
//   String uid;
//
//   NameAddressVerificationUpdate({super.key, required this.uid});
//
//   @override
//   State<NameAddressVerificationUpdate> createState() =>
//       _NameAddressVerificationUpdateState();
// }
//
// class _NameAddressVerificationUpdateState
//     extends State<NameAddressVerificationUpdate> {
//   TextEditingController personNameController = TextEditingController();
//   TextEditingController line1AddressController = TextEditingController();
//   TextEditingController line2AddressController = TextEditingController();
//   TextEditingController cityAddressController = TextEditingController();
//   TextEditingController pinCodeController = TextEditingController();
//
//   @override
//   void initState() {
//     showDataLoad();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     personNameController.dispose();
//     line1AddressController.dispose();
//     line2AddressController.dispose();
//     cityAddressController.dispose();
//     super.dispose();
//   }
//
//   void nameAddressUpdate() {
//     print(requestId);
//     print(serviceRequestId);
//     String token = context.read<TokenCubit>().state;
//     String customerId = context.read<IdCubit>().state;
//     context
//         .read<NameAddressVerificationUpdateFormCubit>()
//         .nameAddressUpdateForm(
//             customer_id: customerId,
//             token: token,
//             nameAddressVerificationUpdateModel:
//                 NameAddressVerificationUpdateModel(
//                     request_id: requestId!,
//                     service_request_id: serviceRequestId!,
//                     person_name: personNameController.text,
//                     aadhaar_front_side: context
//                             .read<NameAddressAadhaarFrontSideCubit>()
//                             .state
//                             .path
//                             .isEmpty
//                         ? File("")
//                         : context
//                             .read<NameAddressAadhaarFrontSideCubit>()
//                             .state,
//                     aadhaar_back_side: context
//                             .read<NameAddressAadhaarBackSideCubit>()
//                             .state
//                             .path
//                             .isEmpty
//                         ? File("")
//                         : context.read<NameAddressAadhaarBackSideCubit>().state,
//                     address_line_1: line1AddressController.text,
//                     address_line_2: line2AddressController.text,
//                     city_id: cityAddressController.text,
//                     pincode: pinCodeController.text));
//   }
//
//   void pickImageClear() {
//     context.read<NameAddressAadhaarFrontSideCubit>().clearImage();
//     context.read<NameAddressAadhaarBackSideCubit>().clearImage();
//   }
//
//   void showDataLoad() {
//     String token = context.read<TokenCubit>().state;
//     context
//         .read<NameAddressShowDataCubit>()
//         .nameAddressShowData(token: token, uid: widget.uid);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
//           child:
//               BlocBuilder<NameAddressShowDataCubit, NameAddressShowDataState>(
//                   builder: (context, showData) {
//             if (showData is NameAddressShowDataSLoadingState) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (showData is NameAddressShowDataSErrorState) {
//               return Center(
//                 child: Text(showData.message),
//               );
//             } else if (showData is NameAddressShowDataSSuccessState) {
//               NameAddressShowDataModel data = showData.nameAddressShowDataModel;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Full Name & Address Verification",
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleMedium!
//                         .copyWith(color: Theme.of(context).primaryColorDark),
//                   ),
//                   Text(
//                     "Rejected Reason",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyLarge!
//                         .copyWith(color: Colors.red),
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     data.data!.reason!,
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall!
//                         .copyWith(color: Colors.red),
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   Text(
//                     "Person's Details",
//                     style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                         color: Theme.of(context).primaryColorDark, fontSize: 16),
//                   ),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   form_widget(
//                       controller: personNameController
//                         ..text = data.data!.personName!,
//                       titleText: "Person's Full Name",
//                       hintText: "Enter Person's Name",
//                       textInputType: TextInputType.text),
//                   form_widget(
//                       validator: addressValidator,
//                       controller: line1AddressController
//                         ..text = data.data!.addressLine1!,
//                       titleText: "Person's Address Line 1",
//                       hintText: "Enter Line 1 Address",
//                       textInputType: TextInputType.text),
//                   form_widget(
//                       validator: addressValidator,
//                       controller: line2AddressController
//                         ..text = data.data!.addressLine2!,
//                       titleText: "Person's Address Line 2",
//                       hintText: "Enter Line 2 Address",
//                       textInputType: TextInputType.text),
//                   form_widget(
//                       validator: addressValidator,
//                       controller: cityAddressController
//                         ..text = data.data!.city!,
//                       titleText: "Person's Address City",
//                       hintText: "Enter City Address",
//                       textInputType: TextInputType.text),
//                   form_widget(
//                       validator: validatePinCode,
//                       maskFormatter: [pinMask],
//                       controller: pinCodeController..text = data.data!.pincode!,
//                       titleText: 'PIN Code',
//                       hintText: "Enter PIN Code",
//                       textInputType: TextInputType.number),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   BlocBuilder<NameAddressAadhaarFrontSideCubit, File>(
//                       builder: (context, aadhaarFront) {
//                     return PickPhotoUpdate(
//                       starRemove: "remove",
//                       mainTitle: "Upload Documents Proof Front Side",
//                       widthSize: double.infinity,
//                       onPressedPickImage: () {
//                         context
//                             .read<NameAddressAadhaarFrontSideCubit>()
//                             .pickFile()
//                             .then((_) {
//                           context.pop();
//                         });
//                       },
//                       onPressedTakePhoto: () {
//                         context
//                             .read<NameAddressAadhaarFrontSideCubit>()
//                             .pickImageFromCamera()
//                             .then((_) {
//                           context.pop();
//                         });
//                       },
//                       title: 'Documents Front Side',
//                       image: aadhaarFront,
//                       uploadImage: data.data!.aadhaarBackSide == null
//                           ? ""
//                           : data.data!.aadhaarFrontSide!,
//                     );
//                   }),
//                   const SizedBox(
//                     height: 16,
//                   ),
//                   BlocBuilder<NameAddressAadhaarBackSideCubit, File>(
//                       builder: (context, aadhaarBack) {
//                     return PickPhotoUpdate(
//                       starRemove: "remove",
//                       mainTitle: "Upload Documents Proof Back Side",
//                       widthSize: double.infinity,
//                       onPressedPickImage: () {
//                         context
//                             .read<NameAddressAadhaarBackSideCubit>()
//                             .pickFile()
//                             .then((_) {
//                           context.pop();
//                         });
//                       },
//                       onPressedTakePhoto: () {
//                         context
//                             .read<NameAddressAadhaarBackSideCubit>()
//                             .pickImageFromCamera()
//                             .then((_) {
//                           context.pop();
//                         });
//                       },
//                       title: 'Documents Back Side',
//                       image: aadhaarBack,
//                       uploadImage: data.data!.aadhaarBackSide == null
//                           ? ""
//                           : data.data!.aadhaarBackSide!,
//                     );
//                   }),
//                   const SizedBox(
//                     height: 24,
//                   ),
//                   BlocConsumer<NameAddressVerificationUpdateFormCubit,
//                           NameAddressVerificationUpdateState>(
//                       listener: (context, updateData) {
//                     if (updateData
//                         is NameAddressVerificationUpdateSuccessState) {
//                       if (updateData.data["status"] == 200) {
//                         context.pushReplacementNamed("bottomNav");
//                         context
//                             .read<NameAddressAadhaarFrontSideCubit>()
//                             .clearImage();
//                         context
//                             .read<NameAddressAadhaarBackSideCubit>()
//                             .clearImage();
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(updateData.data["message"])));
//                         // pickImageClear();
//                       }
//                     } else if (updateData
//                         is NameAddressVerificationUpdateSuccessState) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(updateData.data["message"])));
//                     }
//                   }, builder: (context, updateData) {
//                     return CustomButton(
//                       isLoading: updateData
//                           is NameAddressVerificationUpdateLoadingState,
//                       onTap: () {
//                         nameAddressUpdate();
//                       },
//                       text: "Update",
//                       gradientColors: [
//                         Theme.of(context).primaryColor,
//                         Theme.of(context).primaryColorDark
//                       ],
//                     );
//                   }),
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
