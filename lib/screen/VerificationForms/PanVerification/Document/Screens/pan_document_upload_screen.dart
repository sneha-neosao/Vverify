import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Document/Blocs/pan_document_upload_bloc/pan_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Document/Blocs/pan_document_upload_bloc/pan_document_upload_state.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Form/Blocs/pan_save_form_bloc/pan_save_form_cubit.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/pick_multiple_photos.dart';
import 'package:url_launcher/url_launcher.dart';

class PanDocumentUpload extends StatefulWidget {

  const PanDocumentUpload({super.key,});

  @override
  State<PanDocumentUpload> createState() => _PanDocumentUploadState();
}

class _PanDocumentUploadState extends State<PanDocumentUpload> {

  @override
  void initState() {
    // TODO: implement initState
    // educationList();
    super.initState();
  }

  // void educationList() {
  //   String token = context.read<TokenCubit>().state;
  //   context.read<AddressDocumentListCubit>().loadAddressDocumentList(
  //       token: token,
  //       caseUuid: widget.Case_uuid,
  //       type: "all"
  //   );
  // }

  void educationUploadDocData() async {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<PanDocsUploadCubitNew>().uploadPanDocs(
      token: token,
      request_id: requestId!,
      service_request_id: serviceRequestId!,
      customer_id: customerId,
      documents: context.read<PanDocsFileCubit>().state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KYC / Identity Verification",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Identity Details",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text("Choose an Option:",style: Theme.of(context).textTheme.bodySmall),
                BlocProvider(
                  create: (_) => FormUploadPanCubit(),
                  child: BlocBuilder<FormUploadPanCubit, bool>(
                      builder: (context, frmUpload) {
                        return Column(
                          children: [
                            ListTile(
                              splashColor: Colors.transparent,
                              onTap: () {
                                context.pushReplacementNamed("PanSaveFormScreen");

                                context
                                    .read<FormUploadPanCubit>()
                                    .formUploadYesNo(yesNo: true);

                                context
                                    .read<FormUploadPanCubit>()
                                    .formUploadYesNo(yesNo: false);
                              },
                              contentPadding: const EdgeInsets.all(0),
                              leading: Icon(Icons.radio_button_checked,
                                  color: frmUpload
                                      ? Theme.of(context).primaryColorLight
                                      : Theme.of(context).iconTheme.color),
                              title: Text("Fill the Form Manually",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                            ListTile(
                              splashColor: Colors.transparent,
                              onTap: () {
                                context
                                    .read<FormUploadPanCubit>()
                                    .formUploadYesNo(yesNo: false);
                              },
                              contentPadding: const EdgeInsets.all(0),
                              leading: Icon(
                                Icons.radio_button_checked,
                                color: !frmUpload
                                    ? Theme.of(context).primaryColorLight
                                    : Theme.of(context).iconTheme.color,
                              ),
                              title: Text("Upload Documents",
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                          ],
                        );
                      }),
                ),
                const SizedBox(height: 16,),
                BlocBuilder<PanDocsFileCubit, List<File>>(
                  builder: (context, uploadDocs) {
                    return PickMultiplePhoto(
                      widthSize: double.infinity,
                      title: "Select Documents",
                      mainTitle: "Upload Pan/Passport/Driving Licence",
                      onPressedPickImage: () {
                        context.read<PanDocsFileCubit>().pickMultipleFiles().then((_) {
                          context.pop();
                        });
                      },
                      onPressedTakePhoto: () {
                        context.read<PanDocsFileCubit>().pickImageFromCamera().then((_) {
                          context.pop();
                        });
                      },
                      onRemoveFile: (index) { context.read<PanDocsFileCubit>().removeFileAt(index); },
                      // Pass the list of files instead of a single File
                      files: uploadDocs,
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Note : Uploaded documents must not exceed 2 MB.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<PanDocsUploadCubitNew, PanDocUploadState>(
                    listener: (context, addressDoc) {
                      if (addressDoc is PanDocUploadSuccessState) {
                        if (addressDoc.data["status"] == 200) {
                          context.pushNamed("PendingDoc");
                          context.read<PanDocsFileCubit>().clearFiles();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                addressDoc.data["message"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )));
                        }
                      } else if (addressDoc is PanDocUploadErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              addressDoc.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )));
                        print("uploadMessage ${addressDoc.message}");
                      }
                    }, builder: (context, addressDoc) {
                  return CustomButton(
                    isLoading: addressDoc is PanDocUploadLoadingState,
                    onTap: () {
                      if (context.read<PanDocsFileCubit>().state.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Please Upload Pan/Passport/Driving Licence")));
                      } else {
                        educationUploadDocData();
                      }
                    },
                    text: "SUBMIT",
                    gradientColors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark
                    ],
                  );
                }),
                // const SizedBox(height: 16),
                // Text(
                //   "KYC / Identity Documents List",
                //   style: Theme.of(context)
                //       .textTheme
                //       .titleMedium!
                //       .copyWith(color: Theme.of(context).primaryColorDark),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // BlocBuilder<AddressDocumentListCubit, AddressDocumentListState>(
                //   builder: (context, state) {
                //     if (state is AddressDocumentListLoadingState) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (state is AddressDocumentListErrorState) {
                //       return const Text("No related data found");
                //     } else if (state is AddressDocumentListSuccessState) {
                //       final data = state.addressDocuments;
                //
                //       // If no documents, show button
                //       if (data.data.documents.isEmpty) {
                //         return const Text("No related data found");
                //       }
                //       return ListView.separated(
                //         shrinkWrap: true,
                //         physics: const NeverScrollableScrollPhysics(),
                //         itemCount: data.data.documents.length,
                //         separatorBuilder: (_, __) => const SizedBox(height: 12),
                //         itemBuilder: (context, index) {
                //           final doc = data.data.documents[index];
                //           final url = doc.documentUrl;
                //
                //           // Helper to launch URL
                //           Future<void> _openUrl(String url) async {
                //             final uri = Uri.parse(url);
                //             if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                //               ScaffoldMessenger.of(context).showSnackBar(
                //                 const SnackBar(content: Text("Could not open document")),
                //               );
                //             }
                //           }
                //
                //           String fileNameFromUrl(String url) {
                //             try {
                //               final uri = Uri.parse(url);
                //
                //               // Get the value of `path` query parameter
                //               final pathParam = uri.queryParameters['path'];
                //
                //               if (pathParam == null || pathParam.isEmpty) {
                //                 return 'Documents';
                //               }
                //
                //               // Extract filename from that path
                //               return pathParam.split('/').last;
                //             } catch (e) {
                //               return 'Documents';
                //             }
                //           }
                //           return ListTile(
                //               leading: Container(
                //                 width: 60,
                //                 height: 60,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(6),
                //                   border: Border.all(color: Colors.grey.shade300),
                //                 ),
                //                 child: url.toLowerCase().endsWith(".png") ||
                //                     url.toLowerCase().endsWith(".jpg") ||
                //                     url.toLowerCase().endsWith(".jpeg")
                //                     ? ClipRRect(
                //                   borderRadius: BorderRadius.circular(6),
                //                   child: Image.network(
                //                     url,
                //                     fit: BoxFit.cover,
                //                     errorBuilder: (context, error, stackTrace) {
                //                       return const Icon(Icons.attach_file, color: Colors.red);
                //                     },
                //                   ),
                //                 )
                //                     : const Icon(Icons.picture_as_pdf, color: Colors.red),
                //               ),
                //               title: Text(fileNameFromUrl(url),style: TextStyle(fontSize: 10),),
                //               // subtitle: Text(url),
                //               trailing: InkWell(
                //                 onTap: () => _openUrl(url),
                //                 child: Container(
                //                   height: 35,
                //                   width: 65,
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(8),
                //                     gradient: LinearGradient(
                //                       colors: [
                //                         Theme.of(context).primaryColor,
                //                         Theme.of(context).primaryColorDark,
                //                       ],
                //                       begin: Alignment.topLeft,
                //                       end: Alignment.bottomRight,
                //                     ),
                //                   ),
                //                   child: Center(
                //                       child: Text("View",style: TextStyle(color: Colors.white),
                //                       )
                //                   ),
                //                 ),
                //               )
                //           );
                //         },
                //       );
                //     } else if (state is AddressDocumentListErrorState) {
                //       return SizedBox.shrink();
                //     }
                //     return const SizedBox();
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
