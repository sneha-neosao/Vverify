import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:v_verify/commonComponent/bloc/shared_preferences_cubit.dart';
import 'package:v_verify/commonComponent/custom_button.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_list_bloc/employment_doc_list_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_list_bloc/employment_doc_list_state.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_upload_bloc/employment_document_upload_cubit.dart';
import 'package:v_verify/screen/VerificationForms/EmploymentVerification/Documents/Blocs/employment_document_upload_bloc/employment_document_upload_state.dart';
import 'package:v_verify/screen/VerificationForms/common/pick_multiple_photos.dart';
import 'package:url_launcher/url_launcher.dart';

class EmploymentDocumentUpload extends StatefulWidget {
  String Case_uuid;

  EmploymentDocumentUpload({super.key,required this.Case_uuid});

  @override
  State<EmploymentDocumentUpload> createState() => _EmploymentDocumentUploadState();
}

class _EmploymentDocumentUploadState extends State<EmploymentDocumentUpload> {

  @override
  void initState() {
    // TODO: implement initState
    educationList();
    super.initState();
  }

  void educationList() {
    String token = context.read<TokenCubit>().state;
    context.read<EmploymentDocumentListCubit>().loadEmploymentDocumentList(
        token: token,
        caseUuid: widget.Case_uuid,
        type: "employment"
    );
  }

  void employmentUploadDocData() async {
    String token = context.read<TokenCubit>().state;
    context.read<EmploymentUploadCubit>().employmentUpload(
        token: token,
        caseUuid: widget.Case_uuid,
        documents: context.read<EmploymentDocsFileCubit>().state,
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
                  "Employment Verification",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(height: 16,),
                BlocBuilder<EmploymentDocsFileCubit, List<File>>(
                  builder: (context, uploadDocs) {
                    return PickMultiplePhoto(
                      widthSize: double.infinity,
                      title: "Select Documents",
                      mainTitle: "Upload Certificate/Marksheet/Documents",
                      onPressedPickImage: () {
                        context.read<EmploymentDocsFileCubit>().pickMultipleFiles().then((_) {
                          context.pop();
                        });
                      },
                      onPressedTakePhoto: () {
                        context.read<EmploymentDocsFileCubit>().pickImageFromCamera().then((_) {
                          context.pop();
                        });
                      },
                      onRemoveFile: (index) { context.read<EmploymentDocsFileCubit>().removeFileAt(index); },
                      // Pass the list of files instead of a single File
                      files: uploadDocs,
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                    "Note : Uploaded documents must not exceed 2 MB."
                ),
                const SizedBox(
                  height: 24,
                ),
                BlocConsumer<EmploymentUploadCubit, EmploymentUploadState>(
                    listener: (context, employmentDoc) {
                      if (employmentDoc is EmploymentUploadSuccessState) {
                        if (employmentDoc.data["status"] == 200) {
                          context.pushNamed("EmployDataList",pathParameters: {
                            'uid': widget.Case_uuid
                          });
                          context.read<EmploymentDocsFileCubit>().clearFiles();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                employmentDoc.data["message"],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )));
                        }
                      } else if (employmentDoc is EmploymentUploadErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              employmentDoc.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )));
                        print("uploadMessage ${employmentDoc.message}");
                      }
                    }, builder: (context, educationDoc) {
                  return CustomButton(
                    isLoading: educationDoc is EmploymentUploadLoadingState,
                    onTap: () {
                      if (context.read<EmploymentDocsFileCubit>().state.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Please Upload Certificate/Marksheet/Documents")));
                      } else {
                        employmentUploadDocData();
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
                  "Employment Documents List",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<EmploymentDocumentListCubit, EmploymentDocumentListState>(
                  builder: (context, state) {
                    if (state is EmploymentDocumentListLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is EmploymentDocumentListEmptyState) {
                      return const Text("No related data found");
                    } else if (state is EmploymentDocumentListSuccessState) {
                      final data = state.educationDocuments;

                      // If no documents, show button
                      if (data.data.documents.isEmpty) {
                        return const Text("No related data found");
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.data.documents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final doc = data.data.documents[index];
                          final url = doc.documentUrl;

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

                              // Get the value of `path` query parameter
                              final pathParam = uri.queryParameters['path'];

                              if (pathParam == null || pathParam.isEmpty) {
                                return 'Documents';
                              }

                              // Extract filename from that path
                              return pathParam.split('/').last;
                            } catch (e) {
                              return 'Documents';
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
                            title: Text(fileNameFromUrl(url),style: TextStyle(fontSize: 10),),
                            // subtitle: Text(url),
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
                                child: Center(
                                  child: Text("View",style: TextStyle(color: Colors.white),
                                )
                                ),
                              ),
                            )
                          );
                        },
                      );
                    } else if (state is EmploymentDocumentListErrorState) {
                      return Text("Error: ${state.message}");
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
