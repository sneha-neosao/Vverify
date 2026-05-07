// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:v_verify/screen/VerificationForms/common/url.dart';
// import 'package:v_verify/screen/VerificationPending/blinking_widget.dart';
// import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_cubit.dart';
// import 'package:v_verify/screen/VerificationPending/bloc/verify_report_bloc/verify_request_report_state.dart';
// import '../../commonComponent/bloc/shared_preferences_cubit.dart';
// import '../../commonComponent/screen_size.dart';
// import '../VerificationForms/common/id.dart';
// import 'bloc/pendingDoc_cubit.dart';
// import 'bloc/pendingDoc_state.dart';
// import 'model/pendingDoc_model.dart';

// class PendingDoc extends StatefulWidget {
//   const PendingDoc({super.key});

//   @override
//   State<PendingDoc> createState() => _PendingDocState();
// }

// void checkCase({required String title, String? uuid,required BuildContext context}) {
//   switch (title) {
//     case "Police Verification":
//       context.pushNamed("NonMumbaiPoliceSaveFormScreen1");
//       break;
//     case "Aadhaar Verification":
//       context.pushNamed("AadhaarGetOtp");
//       break;
//     case "Reference Check":
//       context.pushNamed("ReferenceSaveFormScreen");
//       break;
//     case "Address verification":
//       context.pushNamed("AddressList",pathParameters: {'uid': uuid!},
//       );
//       break;
//     case "Employment Verification":
//       context.pushNamed("EmployDataList",pathParameters: {'uid': uuid!},
//       );
//       break;
//     case "Education Verification":
//       context.pushNamed("EducationList",pathParameters: {'uid': uuid!},
//       );
//       break;
//     case "Driving License":
//       context.pushNamed("DrivingLicenceSaveFormScreen");
//       break;
//     case "GST CIN PAN Verification":
//       context.pushNamed("GstVerificationSaveFormScreen");
//       break;
//     case "pan-card-verification":
//       context.pushNamed("PanSaveFormScreen");
//       break;
//     case "Court Legal Verification":
//       context.pushNamed("CourtVerificationSaveFormScreen");
//       break;
//   }
// }

// void secondCheckCase(
//     {required PendingDocModel data,
//     required BuildContext context,
//     required int index,
//     required int servicesIndex}) {
//   switch (data.data![index].services![servicesIndex].serviceTitle) {
//     case "Police Verification":
//       data.data![index].services![servicesIndex].policeEntryType == 1
//           ? data.data![index].services![servicesIndex].dataPreference == "form"
//               ? context.pushNamed("MumbaiPoliceUpdateFormScreen1",
//                   pathParameters: {
//                       'uid': data.data![index].services![servicesIndex].uid
//                           .toString()
//                     })
//               : context.pushNamed("MumbaiDocUpdate", pathParameters: {
//                   'uid':
//                       data.data![index].services![servicesIndex].uid.toString()
//                 })
//           : data.data![index].services![servicesIndex].dataPreference == "form"
//               ? context.pushNamed("NonMumbaiPoliceUpdateFormScreen1",
//                   pathParameters: {
//                       'uid': data.data![index].services![servicesIndex].uid
//                           .toString()
//                     })
//               : context.pushNamed("UpdateDocumentsNonMumbai", pathParameters: {
//                   'uid':
//                       data.data![index].services![servicesIndex].uid.toString()
//                 });
//       break;
//     case "Aadhaar Verification":
//       context.pushNamed("AadhaarGetOtp");
//       break;
//     case "pan-card-verification":
//       data.data![index].services![servicesIndex].dataPreference == "form"
//           ? context.pushNamed("PanUpdateFormScreen", pathParameters: {
//         'uid': data.data![index].services![servicesIndex].uid.toString()
//       })
//           : context.pushNamed("PanDocumentUpdate",
//           pathParameters: {
//           'uid': data.data![index].services![servicesIndex].uid.toString()
//         }
//       );
//       break;
//     case "Reference Check":
//       data.data![index].services![servicesIndex].dataPreference == "form"
//           ? context.pushNamed("ReferenceUpdateFormScreen", pathParameters: {
//               'uid': data.data![index].services![servicesIndex].uid.toString()
//             })
//           : context.pushNamed("ReferenceUpdateDoc", pathParameters: {
//               'uid': data.data![index].services![servicesIndex].uid.toString()
//             });
//       break;
//     case "Address verification":
//       data.data![index].services![servicesIndex].dataPreference == "form"
//           ? context.pushNamed("NameAddressVerificationUpdateNew", pathParameters: {
//               'uid': data.data![index].services![servicesIndex].uid.toString()
//             })
//           : context.pushNamed("NameAddressDocUpdate", pathParameters: {
//               'uid': data.data![index].services![servicesIndex].uid.toString()
//             });
//       break;
//     case "Driving License":
//       data.data![index].services![servicesIndex].dataPreference == "form"
//           ? context.pushNamed("DrivingLicenceUpdate", pathParameters: {
//               "uid": data.data![index].services![servicesIndex].uid.toString()
//             })
//           : context.pushNamed("DrivingDocUpdate", pathParameters: {
//               "uid": data.data![index].services![servicesIndex].uid.toString()
//             });
//       break;
//     case "GST CIN PAN Verification":
//       data.data![index].services![servicesIndex].dataPreference == "form"
//           ? context.pushNamed("GstVerificationUpdateFormScreen", pathParameters: {
//               "uid": data.data![index].services![servicesIndex].uid.toString()
//             })
//           : context.pushNamed("GstPanCinDocUpdate", pathParameters: {
//               "uid": data.data![index].services![servicesIndex].uid.toString()
//             });
//       break;

//     case "Court Legal Verification":
//       data.data![index].services![servicesIndex].dataPreference == "form"
//           ? context.pushNamed("CourtVerificationUpdateFormScreen", pathParameters: {
//               "uid": data.data![index].services![servicesIndex].uid.toString()
//             })
//           : context.pushNamed("CourtDocumentUpdateFormScreen", pathParameters: {
//               "uid": data.data![index].services![servicesIndex].uid.toString()
//             });
//       break;
//   }
// }

// class _PendingDocState extends State<PendingDoc> {
//   Set<int> loadingIndexes = {};

//   @override
//   void initState() {
//     pendingDoc();
//     super.initState();
//   }

//   void pendingDoc() {
//     final String token = context.read<TokenCubit>().state;

//     final String id = context.read<IdCubit>().state;

//     context.read<PendingDocCubit>().getPendingDoc(
//         token: token, customerId: int.parse(id), page: 1, limit: 100);
//   }

//   @override
//   Widget build(BuildContext context) {
//     const PageStorageKey<String> listViewKey =
//         PageStorageKey<String>('listViewKey');
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
//         child: RefreshIndicator(
//           onRefresh: () {
//             final String token = context.read<TokenCubit>().state;

//             final String id = context.read<IdCubit>().state;

//             return context.read<PendingDocCubit>().getPendingDoc(
//                 token: token, customerId: int.parse(id), page: 1, limit: 100);
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Verification List",
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge!
//                       .copyWith(fontSize: 28)),
//               const SizedBox(
//                 height: 24,
//               ),
//               BlocBuilder<PendingDocCubit, PendingDocState>(
//                 builder: (context, pendingDoc) {
//                   if (pendingDoc is PendingDocLoadingState) {
//                     return Expanded(
//                       child: ListView.builder(
//                           key: listViewKey,
//                           shrinkWrap: true,
//                           itemCount: 10,
//                           itemBuilder: (context, index) {
//                             return Column(
//                               children: [
//                                 Shimmer.fromColors(
//                                   baseColor: Colors.grey[400]!,
//                                   highlightColor: Colors.grey[50]!,
//                                   child: Container(
//                                       height: ScreenSize.screenHeight / 8,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(12))),
//                                 ),
//                                 const SizedBox(
//                                   height: 8,
//                                 )
//                               ],
//                             );
//                           }),
//                     );
//                   } else if (pendingDoc is PendingDocErrorState) {
//                     return Center(
//                       child:
//                           Text(textAlign: TextAlign.center, pendingDoc.message),
//                     );
//                   } else if (pendingDoc is PendingDocSuccessState) {
//                     PendingDocModel data = pendingDoc.pendingDocModel;
//                     return BlocBuilder<IsPressedCubit, int>(
//                         builder: (context, isPressed) {
//                           return Expanded(
//                         child: ListView.builder(
//                             itemCount: data.data!.length,
//                             shrinkWrap: true,
//                             itemBuilder: (BuildContext context, int index) {
//                               final rawStatus = data.data![index].status?.toLowerCase() ?? "";
//                               String status;

//                               if (rawStatus.isEmpty || rawStatus == "-" || rawStatus == "") {
//                                 status = "pending";
//                               } else if (rawStatus == "discrepancy") {
//                                 status = "discrepancy";
//                               } else if (rawStatus == "verified" || rawStatus == "clear") {
//                                 status = "verified";
//                               } else {
//                                 status = rawStatus; // fallback for other values
//                               }
//                               return Card(
//                                 color: Theme.of(context).cardColor,
//                                 child: Column(
//                                   children: [
//                                     ListTile(
//                                       onTap: () {
//                                         context.read<IsPressedCubit>().isPressed(index);
//                                       },
//                                       tileColor: Colors.orangeAccent,
//                                       shape: const RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(8),
//                                           topRight: Radius.circular(8),
//                                         ),
//                                       ),
//                                       title: data.data![index].first_name != null
//                                           ? Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               // ✅ Case name (fixed width via Expanded, wraps to next line)
//                                               Expanded(
//                                                 child: Text(
//                                                   "${data.data![index].first_name} ${data.data![index].middle_name} ${data.data![index].last_name}",
//                                                   maxLines: 2,
//                                                   softWrap: true,
//                                                   style: Theme.of(context)
//                                                       .textTheme
//                                                       .bodySmall!
//                                                       .copyWith(
//                                                     color: Colors.black,
//                                                     fontSize: 15,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ),

//                                               if(status.toLowerCase() != "pending")
//                                                 BlocBuilder<VerifyRequestReportCubit, VerifyRequestReportState>(
//                                                   builder: (context, state) {
//                                                     return InkWell(
//                                                       onTap: () async {
//                                                         setState(() {
//                                                           loadingIndexes.add(index);
//                                                         });

//                                                         await context.read<VerifyRequestReportCubit>().verifyRequestReport(
//                                                           token: context.read<TokenCubit>().state,
//                                                           case_uuid: data.data![index].uuid.toString(),
//                                                         );

//                                                         setState(() {
//                                                           loadingIndexes.remove(index);
//                                                         });
//                                                       },
//                                                       child: loadingIndexes.contains(index)
//                                                           ? const Padding(
//                                                         padding: EdgeInsets.all(6.0),
//                                                         child: SizedBox(
//                                                           height: 16,
//                                                           width: 16,
//                                                           child: CircularProgressIndicator(strokeWidth: 2),
//                                                         ),
//                                                       )
//                                                           : const Padding(
//                                                         padding: EdgeInsets.all(6.0),
//                                                         child: Icon(Icons.get_app, color: Colors.black, size: 16),
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),

//                                               // ✏️ Edit icon (unchanged)
//                                               InkWell(
//                                                 onTap: () {
//                                                   context.pushNamed(
//                                                     "VerifyRequestEditFormNew",
//                                                     pathParameters: {
//                                                       'request_id': data.data![index].requestId!.toString(),
//                                                       'uuid': data.data![index].uuid.toString(),
//                                                       'service_title': data.data![index].entity!.entityName!
//                                                     },
//                                                   );
//                                                 },
//                                                 child: const Padding(
//                                                   padding: EdgeInsets.all(6.0),
//                                                   child: Icon(
//                                                     Icons.mode_edit,
//                                                     color: Colors.black,
//                                                     size: 16,
//                                                   ),
//                                                 ),
//                                               ),

//                                               // ⬆⬇ Arrow (ONLY change)
//                                               Icon(
//                                                 isPressed == index
//                                                     ? Icons.keyboard_arrow_up
//                                                     : Icons.keyboard_arrow_down,
//                                                 color: Colors.black,
//                                               ),
//                                             ],
//                                           ),

//                                           status.toLowerCase() == "discrepancy" ?
//                                           BlinkingStatus( icon: Icons.not_interested, text: "Discrepancy", color: Colors.black, ) :
//                                           Row(
//                                             children: [
//                                               Icon(
//                                                 status.toLowerCase() == "verified"
//                                                     ? Icons.verified
//                                                     : Icons.schedule,
//                                                 // : status.toLowerCase() == "discrepancy"
//                                                 // ? Icons.not_interested
//                                                 // : Icons.schedule,
//                                                 color: Colors.black,
//                                                 size: 14,
//                                               ),
//                                               const SizedBox(width: 4),
//                                               Text(
//                                                 status.toLowerCase() == "verified"
//                                                     ? "Clear"
//                                                     : "Pending",
//                                                 // : status.toLowerCase() == "discrepancy" || status.toLowerCase() == "rejected"
//                                                 // ? "Discrepancy"
//                                                 // : "Pending",
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodySmall!
//                                                     .copyWith(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       )
//                                           : Text(data.data![index].entity!.entityName.toString(),),
//                                     ),
//                                     isPressed == index
//                                         ? ListView.builder(
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             shrinkWrap: true,
//                                             itemCount: data.data![index].services!.length,
//                                             itemBuilder: (BuildContext context, int servicesIndex) {

//                                               final rawServiceStatus = data.data![index].services![servicesIndex].status?.toLowerCase() ?? "";
//                                               String serviceStatus;
//                                               print("verification service status : ${rawServiceStatus}");

//                                               if (rawServiceStatus.isEmpty || rawServiceStatus == "-" || rawServiceStatus == "" || rawServiceStatus == "NA") {
//                                                 serviceStatus = "pending";
//                                               } else if (rawStatus == "discrepancy") {
//                                                 serviceStatus = "discrepancy";
//                                               } else if (rawStatus == "verified" || rawStatus == "clear") {
//                                                 serviceStatus = "verified";
//                                               } else if (rawStatus == "rejected") {
//                                                 serviceStatus = "rejected";
//                                               }else {
//                                                 serviceStatus = rawServiceStatus; // fallback for other values
//                                               }

//                                               return Column(
//                                                 children: [
//                                                   ListTile(
//                                                     contentPadding:
//                                                         const EdgeInsets
//                                                             .symmetric(
//                                                             horizontal: 8,
//                                                             vertical: 4),
//                                                     onTap: () {
//                                                       serviceRequestId = data.data![index].services![servicesIndex].serviceRequestId.toString();
//                                                       requestId = data.data![index].requestId.toString();

//                                                       if (data.data![index].detailsUpdated == 0) {
//                                                         context.pushNamed("verifyRequestUpdateNew",
//                                                             pathParameters:
//                                                             {
//                                                               'uuid': data.data![index].uuid.toString(),
//                                                               'service_title': data.data![index].entity!.entityName!
//                                                             }
//                                                         );
//                                                       } else if (data.data![index].detailsUpdated == 1) {
//                                                         if (data.data![index].services![servicesIndex].status == "pending") {
//                                                           if (data.data![index].services![servicesIndex].serviceTitle == "Employment Verification") {
//                                                             context.pushNamed("EmployDataList",pathParameters: {
//                                                               'uid': data.data![index].case_uuid.toString()}
//                                                             );
//                                                           } else if (data.data![index].services![servicesIndex].serviceTitle =="Education Verification") {
//                                                             print("case_uuid at pending doc: ${data.data![index].case_uuid.toString()}");
//                                                             context.pushNamed("EducationList",pathParameters: {
//                                                             'uid': data.data![index].case_uuid.toString()
//                                                             });
//                                                           } else if (data.data![index].services![servicesIndex].serviceTitle =="Address verification") {
//                                                             print("case_uuid at pending doc: ${data.data![index].case_uuid.toString()}");
//                                                             context.pushNamed("AddressList",pathParameters: {
//                                                               'uid': data.data![index].case_uuid.toString()
//                                                             });
//                                                           } else {
//                                                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please wait your application under process")));
//                                                           }
//                                                         } else if (data.data![index].services![servicesIndex].status == "verified") {
//                                                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your application already verified")));
//                                                         } else if (data
//                                                                 .data![index]
//                                                                 .services![
//                                                                     servicesIndex]
//                                                                 .status ==
//                                                             "rejected") {
//                                                           secondCheckCase(
//                                                               data: data,
//                                                               context: context,
//                                                               index: index,
//                                                               servicesIndex:
//                                                                   servicesIndex);
//                                                         } else if (data
//                                                                 .data![index]
//                                                                 .services![
//                                                                     servicesIndex]
//                                                                 .status ==
//                                                             "failed") {
//                                                           secondCheckCase(
//                                                               data: data,
//                                                               context: context,
//                                                               index: index,
//                                                               servicesIndex:
//                                                                   servicesIndex);
//                                                         } else {
//                                                           checkCase(
//                                                               title: data
//                                                                   .data![index]
//                                                                   .services![
//                                                                       servicesIndex]
//                                                                   .serviceTitle
//                                                                   .toString(),
//                                                               context: context);
//                                                         }
//                                                       }
//                                                     },
//                                                     leading: Image.network(
//                                                       "$imageUrl${data.data![index].services![servicesIndex].serviceIcon}",
//                                                       width: 30,
//                                                     ),
//                                                     title: Text(
//                                                       '${data.data![index].services![servicesIndex].serviceTitle}',
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .bodySmall,
//                                                     ),
//                                                     subtitle: serviceStatus.toLowerCase() == "discrepancy" ?
//                                                     BlinkingStatus( icon: Icons.not_interested, text: "Discrepancy", color: Colors.red, ) :
//                                                     Row(
//                                                       children: [
//                                                         Icon(
//                                                           serviceStatus.toLowerCase() == "verified"
//                                                               ? Icons.verified
//                                                               : Icons.schedule,
//                                                           // : serviceStatus.toLowerCase() == "discrepancy"
//                                                           // ? Icons.not_interested
//                                                           // : Icons.schedule,
//                                                           color:
//                                                           serviceStatus.toLowerCase() == "verified"
//                                                               ? Colors.green
//                                                               : Colors.orangeAccent,
//                                                           // : serviceStatus.toLowerCase() == "discrepancy"
//                                                           // ? Colors.red
//                                                           // : Colors.orangeAccent,
//                                                           size: 14,
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 4,
//                                                         ),
//                                                         Text(
//                                                             serviceStatus.toLowerCase() == "verified"
//                                                                 ? "Verified"
//                                                                 : "Pending",
//                                                             // : serviceStatus.toLowerCase() == "discrepancy"
//                                                             // ? "Discrepancy"
//                                                             // : "Pending",
//                                                             style: Theme.of(
//                                                                 context)
//                                                                 .textTheme
//                                                                 .bodySmall!
//                                                                 .copyWith(
//                                                                 fontSize:
//                                                                 14,
//                                                                 color: serviceStatus.toLowerCase() == "verified"
//                                                                     ? Colors.green
//                                                                     : Colors.orangeAccent
//                                                               // : serviceStatus.toLowerCase() == "discrepancy"
//                                                               // ? Colors.red
//                                                               // : Colors.orangeAccent
//                                                             )
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     trailing: data
//                                                                     .data![
//                                                                         index]
//                                                                     .services![
//                                                                         servicesIndex]
//                                                                     .status ==
//                                                                 "failed" ||
//                                                             data
//                                                                     .data![
//                                                                         index]
//                                                                     .services![
//                                                                         servicesIndex]
//                                                                     .status ==
//                                                                 "rejected"
//                                                         ? TextButton(
//                                                             onPressed: null,
//                                                             child: Text(
//                                                               "Update",
//                                                               style: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .bodySmall,
//                                                             ))
//                                                         : data.data![index]
//                                                                         .detailsUpdated ==
//                                                                     1 &&
//                                                                 data
//                                                                         .data![
//                                                                             index]
//                                                                         .services![
//                                                                             servicesIndex]
//                                                                         .status ==
//                                                                     "NA"
//                                                             ? TextButton(
//                                                                 onPressed: null,
//                                                                 child: Text(
//                                                                   "Verify Now >",
//                                                                   style: Theme.of(
//                                                                           context)
//                                                                       .textTheme
//                                                                       .bodySmall,
//                                                                 ))
//                                                             : Icon(
//                                                                 Icons
//                                                                     .arrow_forward_ios,
//                                                                 size: 15,
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .iconTheme
//                                                                     .color,
//                                                               ),
//                                                   ),
//                                                   data.data![index].services!
//                                                               .length ==
//                                                           1
//                                                       ? const SizedBox()
//                                                       : const Divider(),
//                                                 ],
//                                               );
//                                             })
//                                         : const SizedBox()
//                                   ],
//                                 ),
//                               );
//                             }),
//                       );
//                     });
//                   }
//                   return const Center(
//                     child: Text("something went"),
//                   );
//                 },
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
