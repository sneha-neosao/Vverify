import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Document/Blocs/pan_document_update_bloc/pan_document_update_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Document/Blocs/pan_document_update_bloc/pan_document_update_state.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Form/Blocs/pan_show_details_bloc/pan_show_details_cubit.dart';
import 'package:v_verify/screen/VerificationForms/PanVerification/Form/Blocs/pan_show_details_bloc/pan_show_details_state.dart';
import 'package:v_verify/screen/VerificationForms/common/id.dart';
import 'package:v_verify/screen/VerificationForms/common/pick_multiple_photos.dart';
import 'package:url_launcher/url_launcher.dart';

class PanDocumentUpdate extends StatefulWidget {
  String uid;

  PanDocumentUpdate({super.key,required this.uid});

  @override
  State<PanDocumentUpdate> createState() => _PanDocumentUpdateState();
}

class _PanDocumentUpdateState extends State<PanDocumentUpdate> {

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

  void educationUpdateDocData() async {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;

    context.read<PanDocsUpdateCubitNew>().updatePanDocs(
      token: token,
      request_id: requestId!,
      service_request_id: serviceRequestId!,
      customer_id: customerId,
      documents: context.read<PanDocsUpdateFileCubit>().state,
    );
  }

  @override
  Widget build(BuildContext context) {
    String token = context.read<TokenCubit>().state;
    String customerId = context.read<IdCubit>().state;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (_) => PanVerificationShowCubit(ApiService())
                ..panCardNumberShow(
                  token: token,
                  uid: widget.uid,
                  // request_id: requestId!,
                  // service_request_id: serviceRequestId!,
                  // customer_id: customerId
                ),
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
                  BlocBuilder<PanDocsUpdateFileCubit, List<File>>(
                    builder: (context, uploadDocs) {
                      return PickMultiplePhoto(
                        widthSize: double.infinity,
                        title: "Select Documents",
                        mainTitle: "Upload Pan/Passport/Driving Licence",
                        onPressedPickImage: () {
                          context.read<PanDocsUpdateFileCubit>().pickMultipleFiles().then((_) {
                            context.pop();
                          });
                        },
                        onPressedTakePhoto: () {
                          context.read<PanDocsUpdateFileCubit>().pickImageFromCamera().then((_) {
                            context.pop();
                          });
                        },
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
                  BlocConsumer<PanDocsUpdateCubitNew, PanDocUpdateState>(
                      listener: (context, addressDoc) {
                        if (addressDoc is PanDocUpdateSuccessState) {
                          if (addressDoc.data["status"] == 200) {
                            context.pushNamed("PendingDoc");
                            context.read<PanDocsUpdateFileCubit>().clearFiles();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  addressDoc.data["message"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )));
                          }
                        } else if (addressDoc is PanDocUpdateErrorState) {
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
                      isLoading: addressDoc is PanDocUpdateLoadingState,
                      onTap: () {
                        if (context.read<PanDocsUpdateFileCubit>().state.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Please Upload Pan/Passport/Driving Licence")));
                        } else {
                          educationUpdateDocData();
                        }
                      },
                      text: "SUBMIT",
                      gradientColors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  Text(
                    "KYC / Identity Documents List",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColorDark),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  BlocBuilder<PanVerificationShowCubit, PanVerificationShowState>(
                      builder: (context, panShowData) {
                        if (panShowData is PanVerificationShowLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (panShowData is PanVerificationShowErrorState) {
                          return Center(
                            child: Text(panShowData.message),
                          );
                        } else if (panShowData is PanVerificationShowSuccessState) {

                          final data = panShowData.panVerificationShowModel.data!;

                          // If no documents, show button
                          if (data.documents!.isEmpty) {
                            return const Text("No related data found");
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.documents?.length ?? 0,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final url = data.documents![index]; // each item is just a string

                              // Helper to launch URL
                              Future<void> _openUrl(String url) async {
                                final uri = Uri.parse(url);
                                if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Could not open document")),
                                  );
                                }
                              }

                              String fileNameFromUrl(String url) {
                                try {
                                  final uri = Uri.parse(url);
                                  final pathParam = uri.queryParameters['path'];
                                  if (pathParam == null || pathParam.isEmpty) {
                                    return 'Document';
                                  }
                                  return pathParam.split('/').last;
                                } catch (e) {
                                  return 'Document';
                                }
                              }

                              return ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: url.toLowerCase().endsWith(".png") ||
                                      url.toLowerCase().endsWith(".jpg") ||
                                      url.toLowerCase().endsWith(".jpeg")
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.attach_file, color: Colors.red);
                                      },
                                    ),
                                  )
                                      : const Icon(Icons.picture_as_pdf, color: Colors.red),
                                ),
                                title: Text(
                                  fileNameFromUrl(url),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                trailing: InkWell(
                                  onTap: () => _openUrl(url),
                                  child: Container(
                                    height: 35,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColorDark,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text("View", style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );

                        }
                        else {
                          return SizedBox.shrink();
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
